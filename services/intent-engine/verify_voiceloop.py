import requests
import json
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_voice_loop():
    import numpy as np
    audio_data = np.zeros(1024, dtype=np.float32).tobytes()
    response = client.post("/api/v1/voice_loop", json={
        "audio_data_base64": audio_data.hex(),
        "user_trust_level": 1
    })

    assert response.status_code == 200
    data = response.json()
    assert "tts_audio_base64" in data
    assert "transcription" in data
    assert "synapse_payload" in data
    assert data["synapse_payload"]["ui_state"] in ["heroCard", "proposal"]
    print("Voice loop with Synapse Payload verified successfully!")

test_voice_loop()
