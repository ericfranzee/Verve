import logging
from gtts import gTTS
import io

logger = logging.getLogger(__name__)

class TTSEngine:
    def generate_speech(self, text: str) -> bytes:
        """
        P1-TechDebt: Actual text-to-speech engine using gTTS.
        """
        logger.info(f"Generating TTS for text: {text}")
        try:
            tts = gTTS(text=text, lang='en', tld='co.za') # Nigerian/African accent approx via tld where supported
            fp = io.BytesIO()
            tts.write_to_fp(fp)
            fp.seek(0)
            audio_bytes = fp.read()
            logger.info("Successfully generated TTS audio.")
            return audio_bytes
        except Exception as e:
            logger.error(f"TTS Generation failed: {e}")
            return b""
