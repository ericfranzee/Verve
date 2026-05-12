import datetime
import logging
import dateutil.parser

logger = logging.getLogger(__name__)

class TemporalResolver:
    def resolve(self, intent: str) -> dict:
        """
        P1-T08: Temporal reference resolution ("Monday" -> exact dates).
        """
        today = datetime.date.today()
        logger.info(f"Resolving temporal references for intent: {intent} from base date {today}")

        days_of_week = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
        intent_lower = intent.lower()
        resolved_date = None

        # Resolve simple day references
        for i, day in enumerate(days_of_week):
            if day in intent_lower:
                current_weekday = today.weekday()
                # Find the next occurrence of this day
                days_ahead = i - current_weekday
                if days_ahead <= 0: # Target day already happened this week
                    days_ahead += 7
                resolved_date = today + datetime.timedelta(days=days_ahead)
                logger.info(f"Found temporal match for '{day}'. Resolved to: {resolved_date.isoformat()}")
                break

        if not resolved_date:
            # Fallback
            resolved_date = today

        return {
            "resolved_date": resolved_date.isoformat(),
            "temporal_weight": 0.8
        }
