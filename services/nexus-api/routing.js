// P3-T14: Single-Hub routing policy enforcement

class Router {
    constructor() {
        this.hubZones = {
            'Lekki': ['hub-1'],
            'Ikeja': ['hub-2'],
            'VictoriaIsland': ['hub-1', 'hub-3']
        };
    }

    resolveHub(userLocation, requestedItems) {
        // Enforce Single-Hub: an order MUST be fulfilled by exactly ONE hub.
        // If hub-1 has 2/3 items and hub-2 has 3/3, pick hub-2.
        // Never split.
        return 'hub-1'; // Stub
    }
}

module.exports = Router;
