import logging

logger = logging.getLogger(__name__)

class AmbiguityResolver:
    def resolve(self, intent: str, emotional_state: str) -> str:
        """
        P1-T17: Ambiguity Resolution engine (vague, contradiction, emotional state).
        Returns a clarified hypothesis.
        """
        if "dunno" in intent or "surprise" in intent:
            if emotional_state == "exhausted":
                return "Proposing comfort food bundle based on 'exhausted' state."
            else:
                return "Proposing standard popular bundle."

        logger.info(f"Resolved ambiguity for intent: {intent}")
        return intent
