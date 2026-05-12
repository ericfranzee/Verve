import pytest
from core.whisper_transcriber import WhisperTranscriber

def test_transcribe_success():
    transcriber = WhisperTranscriber()
    result = transcriber.transcribe(b"dummy_audio")
    assert result["confidence"] > 0.6
    assert result["text"] == "I need some plantains and milk."
