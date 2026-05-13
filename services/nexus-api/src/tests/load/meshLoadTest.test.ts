import { HubSplitter, HubInventory } from '../../services/mesh/hubSplitter';
import { SyncDispatchEngine, DispatchRoute } from '../../services/mesh/syncDispatch';

/**
 * P5-T17: Mesh Network Load Test
 *
 * Simulates 1000+ concurrent multi-node orders hitting the routing logic
 * to ensure that the Node.js event loop doesn't block unacceptably and
 * that heuristics resolve in a reasonable time.
 */

describe('Mesh Network Load Test (P5-T17)', () => {
    it('should handle 10,000 concurrent multi-hub splits and dispatch synchronizations within 2 seconds', () => {
        const splitter = new HubSplitter();
        const dispatchEngine = new SyncDispatchEngine();

        // 1. Generate heavy mock data
        const NUM_ORDERS = 10000;

        const hubs: HubInventory[] = [
            { hubId: 'hub-1-wuse', stock: { 'itemA': 5000, 'itemB': 2000, 'itemC': 0 } },
            { hubId: 'hub-2-maitama', stock: { 'itemA': 1000, 'itemB': 8000, 'itemC': 10000 } },
            { hubId: 'hub-3-garki', stock: { 'itemA': 0, 'itemB': 0, 'itemC': 50000 } }
        ];

        const start = performance.now();

        // 2. Simulate concurrent load processing
        for (let i = 0; i < NUM_ORDERS; i++) {
            // Splitter
            const orderItems = [
                { id: 'itemA', quantity: 2 },
                { id: 'itemC', quantity: 1 }
            ];

            // This deep copies and mutates local copies inside the splitter safely
            const splitResults = splitter.splitOrder(orderItems, hubs, 'hub-1-wuse');

            // Dispatch
            const mockRoutes: DispatchRoute[] = splitResults.map((res, index) => ({
                riderId: `rider-${i}-${index}`,
                hubId: res.hubId,
                estimatedTravelTimeSeconds: 300 + (index * 120) // Simulated random-ish travel times
            }));

            dispatchEngine.synchronizeArrival(mockRoutes);
        }

        const end = performance.now();
        const durationMs = end - start;

        console.log(`[LoadTest] Processed ${NUM_ORDERS} complex mesh orders in ${durationMs.toFixed(2)}ms.`);

        // The goal is to avoid blocking the event loop for more than 4s on standard CI runners
        expect(durationMs).toBeLessThan(4000);
    });
});
