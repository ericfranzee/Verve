/**
 * P5-T08: Synchronized Dispatch Engine
 *
 * Coordinates multi-rider dispatch by throttling the faster riders.
 * Ensures simultaneous arrival at the destination for a seamless UX.
 */

export interface DispatchRoute {
    riderId: string;
    hubId: string;
    estimatedTravelTimeSeconds: number;
}

export interface SynchronizedDispatchInstruction {
    riderId: string;
    hubId: string;
    delayBeforeDispatchSeconds: number;
    targetArrivalTimeSeconds: number;
}

export class SyncDispatchEngine {
    /**
     * Calculates the dispatch delay required for each rider so they all arrive at the same time.
     */
    public synchronizeArrival(routes: DispatchRoute[]): SynchronizedDispatchInstruction[] {
        if (routes.length === 0) return [];

        // 1. Find the longest travel time (the slowest rider determines the target arrival time)
        const maxTravelTime = Math.max(...routes.map(r => r.estimatedTravelTimeSeconds));

        // 2. Add a buffer for handoff/bio-handshake sync (e.g., 30 seconds)
        const targetArrival = maxTravelTime + 30;

        // 3. Calculate delays for faster riders
        const instructions: SynchronizedDispatchInstruction[] = routes.map(route => {
            // Delay = (Target - Buffer) - Actual Travel Time.
            // The slowest rider gets 0 delay.
            const delay = maxTravelTime - route.estimatedTravelTimeSeconds;

            return {
                riderId: route.riderId,
                hubId: route.hubId,
                delayBeforeDispatchSeconds: delay,
                targetArrivalTimeSeconds: targetArrival
            };
        });

        // Suppress massive logging during load tests
        if (process.env.NODE_ENV !== 'test') {
            console.log(`SyncDispatchEngine: Synchronized ${routes.length} riders to arrive in ${targetArrival}s.`);
        }
        return instructions;
    }
}
