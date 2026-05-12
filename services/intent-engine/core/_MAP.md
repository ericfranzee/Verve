# services/intent-engine/core/ — Structure Map

## Purpose
Core logic for the Intent Engine connecting external APIs (Whisper, TTS) and Routing logic.

## Files

| File | Responsibility |
|------|---------------|
| moe_router.py | MoE routing logic (simple vs complex intents) |
| tts_engine.py | Logic for TTS audio generation (stub) |
| whisper_transcriber.py | Inference using `openai-whisper` |

## Data Flow
User Audio -> [whisper_transcriber] -> Text -> Intent Pipeline -> [moe_router] -> Action -> [tts_engine] -> Audio
