import logging

logger = logging.getLogger(__name__)

class DietaryEnforcer:
    def __init__(self, allergen_blocklist: list):
        self.allergen_blocklist = allergen_blocklist

    def enforce(self, skus: list) -> list:
        """
        P1-T09: Dietary constraint enforcement (allergen interception).
        Returns a filtered list or substitutes.
        """
        safe_skus = []
        for sku in skus:
            if not any(allergen in sku.get("ingredients", []) for allergen in self.allergen_blocklist):
                safe_skus.append(sku)
            else:
                logger.warning(f"Intercepted allergen in SKU: {sku['id']}")
                # Would do substitution here
        return safe_skus
