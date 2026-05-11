from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
import logging
import time
import json

from rag.prompt_builder import PromptBuilder
from rag.temporal_resolver import TemporalResolver
from rag.dietary_enforcer import DietaryEnforcer
from rag.ambiguity_resolver import AmbiguityResolver
from core.moe_router import MoERouter
from core.whisper_transcriber import WhisperTranscriber
from core.tts_engine import TTSEngine

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="Verve Intent Engine", version="1.0.0")

prompt_builder = PromptBuilder()
temporal_resolver = TemporalResolver()
dietary_enforcer = DietaryEnforcer(allergen_blocklist=["peanut", "dairy"])
ambiguity_resolver = AmbiguityResolver()
moe_router = MoERouter()
whisper_transcriber = WhisperTranscriber()
tts_engine = TTSEngine()

class InferenceRequest(BaseModel):
    intent: str
    user_trust_level: int = 0
    emotional_state: str = "neutral"
    context_data: list = []

class InferenceResponse(BaseModel):
    action: str
    confidence: float
    message: str
    synapse_payload: dict # P2-T04

class VoiceLoopRequest(BaseModel):
    audio_data_base64: str
    user_trust_level: int = 0

class VoiceLoopResponse(BaseModel):
    tts_audio_base64: str
    transcription: str
    latency_ms: int
    synapse_payload: dict # P2-T04

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

@app.post("/api/v1/infer", response_model=InferenceResponse)
async def infer_intent(request: InferenceRequest):
    logger.info(f"Received inference request: {request.intent}")

    resolved_temporal = temporal_resolver.resolve(request.intent)
    clarified_intent = ambiguity_resolver.resolve(request.intent, request.emotional_state)
    prompt = prompt_builder.build_prompt(clarified_intent, request.user_trust_level, request.context_data)
    is_complex = len(request.context_data) > 3 or "dunno" in request.intent
    inference_result = moe_router.route_and_infer(prompt, is_complex)

    # Determine Synapse Payload UI state based on intent complexity
    ui_state = "proposal" if is_complex else "heroCard"

    synapse_payload = {
        "ui_state": ui_state,
        "metadata": {
            "title": f"Provisioning for: {clarified_intent}",
            "model_used": inference_result['model']
        },
        "trigger_ms": 500 # MS offset into the TTS track to trigger the UI change
    }

    return InferenceResponse(
        action=inference_result["action"],
        confidence=inference_result["confidence"],
        message=f"I understand you want: {clarified_intent}. Model used: {inference_result['model']}",
        synapse_payload=synapse_payload
    )

@app.post("/api/v1/transcribe")
async def transcribe_audio(request: Request):
    body = await request.body()
    result = whisper_transcriber.transcribe(body)
    if result["confidence"] < 0.60:
        raise HTTPException(status_code=400, detail="Low confidence transcription. Please repeat.")
    return result

@app.post("/api/v1/voice_loop", response_model=VoiceLoopResponse)
async def voice_loop(request: VoiceLoopRequest):
    start_time = time.time()

    # 1. Transcription
    try:
        audio_bytes = bytes.fromhex(request.audio_data_base64)
    except ValueError:
        audio_bytes = b""

    transcription_result = whisper_transcriber.transcribe(audio_bytes)
    if transcription_result["confidence"] < 0.60:
         return VoiceLoopResponse(tts_audio_base64="", transcription="", latency_ms=int((time.time() - start_time) * 1000), synapse_payload={})
    intent = transcription_result["text"]

    # 2. Inference
    clarified_intent = ambiguity_resolver.resolve(intent, "neutral")
    prompt = prompt_builder.build_prompt(clarified_intent, request.user_trust_level, [])
    inference_result = moe_router.route_and_infer(prompt, False)

    # Generate Synapse Payload
    ui_state = "proposal" if "bundle" in intent.lower() else "heroCard"
    synapse_payload = {
        "ui_state": ui_state,
        "metadata": {
            "title": f"Provisioning: {clarified_intent}"
        },
        "trigger_ms": 300
    }

    # 3. TTS
    tts_audio = tts_engine.generate_speech(inference_result["action"])

    latency_ms = int((time.time() - start_time) * 1000)
    logger.info(f"Voice loop completed in {latency_ms}ms")

    return VoiceLoopResponse(
        tts_audio_base64=tts_audio.hex() if tts_audio else "",
        transcription=intent,
        latency_ms=latency_ms,
        synapse_payload=synapse_payload
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
