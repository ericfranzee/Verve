import os
import logging
from sgqlc.endpoint.http import HTTPEndpoint

logger = logging.getLogger(__name__)

class NexusAPIClient:
    def __init__(self):
        # Default to local but can be overridden for compose environments
        url = os.environ.get("NEXUS_API_URL", "http://localhost:4000/graphql")
        self.endpoint = HTTPEndpoint(url)

    def verify_inventory(self, hub_id: str, skus: list) -> dict:
        """
        P3-T04: Wire Intent Engine to Nexus API inventory queries.
        """
        query = '''
        query VerifyInventory($hubId: String!, $skus: [String!]!) {
          verifyInventory(hubId: $hubId, skus: $skus) {
            isFulfillable
            overallPoF
            errors
          }
        }
        '''

        variables = {
            "hubId": hub_id,
            "skus": skus
        }

        try:
            data = self.endpoint(query, variables)
            if "errors" in data:
                logger.error(f"GraphQL errors: {data['errors']}")
                return {"isFulfillable": False, "overallPoF": 0.0}

            return data["data"]["verifyInventory"]
        except Exception as e:
            logger.error(f"Failed to communicate with Nexus API: {e}")
            return {"isFulfillable": False, "overallPoF": 0.0}
