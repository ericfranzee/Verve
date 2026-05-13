import { HubInventory } from './hubSplitter';

/**
 * P5-T09: Inter-Hub Transfer Protocol
 *
 * Predictive stock balancing between Micro-Fulfillment Centers (MFCs).
 */

export interface TransferInstruction {
    sourceHubId: string;
    targetHubId: string;
    itemId: string;
    quantity: number;
}

export class InterHubTransferProtocol {
    private depletionThreshold = 5; // Rebalance if stock drops below this

    /**
     * Evaluates hubs and generates transfer instructions to prevent stockouts.
     */
    public balanceStock(hubs: HubInventory[]): TransferInstruction[] {
        const transfers: TransferInstruction[] = [];

        // Aggregate total inventory across the mesh to find surplus hubs
        const itemAggregates: Record<string, { total: number, hubsWithSurplus: { id: string, qty: number }[] }> = {};

        hubs.forEach(hub => {
            Object.entries(hub.stock).forEach(([itemId, qty]) => {
                if (!itemAggregates[itemId]) {
                    itemAggregates[itemId] = { total: 0, hubsWithSurplus: [] };
                }
                itemAggregates[itemId].total += qty;

                if (qty > this.depletionThreshold * 2) { // Arbitrary surplus heuristic
                    itemAggregates[itemId].hubsWithSurplus.push({ id: hub.hubId, qty });
                }
            });
        });

        // Identify hubs that need stock and pull from surplus
        hubs.forEach(targetHub => {
            Object.entries(targetHub.stock).forEach(([itemId, qty]) => {
                if (qty <= this.depletionThreshold) {
                    const aggregate = itemAggregates[itemId];
                    if (aggregate && aggregate.hubsWithSurplus.length > 0) {

                        // Sort surplus hubs by highest quantity
                        aggregate.hubsWithSurplus.sort((a, b) => b.qty - a.qty);
                        const sourceHub = aggregate.hubsWithSurplus[0];

                        // Don't transfer from self
                        if (sourceHub.id !== targetHub.hubId) {
                            const transferQty = this.depletionThreshold; // Transfer just enough to hit threshold

                            transfers.push({
                                sourceHubId: sourceHub.id,
                                targetHubId: targetHub.hubId,
                                itemId: itemId,
                                quantity: transferQty
                            });

                            // Adjust theoretical stock
                            sourceHub.qty -= transferQty;
                            if(sourceHub.qty <= this.depletionThreshold * 2) {
                                aggregate.hubsWithSurplus.shift(); // No longer a surplus hub
                            }
                        }
                    }
                }
            });
        });

        console.log(`InterHubTransferProtocol: Generated ${transfers.length} transfer instructions.`);
        return transfers;
    }
}
