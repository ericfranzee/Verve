import logging

logger = logging.getLogger(__name__)

class PromptBuilder:
    def build_prompt(self, user_intent: str, user_trust_level: int, context_data: list):
        """
        P1-T07: RAG prompt pipeline with Trust Ladder context gating.
        Only uses context_data that matches the user_trust_level.
        """
        gated_context = [c for c in context_data if c.get("trust_level_required", 0) <= user_trust_level]

        prompt = f"User Intent: {user_intent}\n"
        prompt += f"Context: {gated_context}\n"
        prompt += "Action: Provide a provisioning hypothesis based on the intent and context."

        logger.info(f"Built prompt with {len(gated_context)} context items.")
        return prompt
