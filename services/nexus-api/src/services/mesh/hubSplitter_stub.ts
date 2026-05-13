/**
 * P5-T07: Dynamic Hub Splitter
 *
 * Algorithm for splitting single orders across multiple Micro-Fulfillment Centers (MFCs)
 * when a single hub cannot fulfill the entire order inventory.
 */

export interface OrderItem {
    id: string;
    quantity: number;
}

export interface HubInventory {
    hubId: string;
    stock: Record<string, number>;
}

export interface SplitOrderResult {
    hubId: string;
    items: OrderItem[];
}

export class HubSplitter {
    /**
     * Splits an order across available hubs based on stock.
     * Prioritizes fulfilling as much as possible from the primary hub to minimize splits.
     */
    public splitOrder(orderItems: OrderItem[], hubs: HubInventory[], primaryHubId: string): SplitOrderResult[] {
        // Deep copy inputs to prevent mutating the original arguments
        const remainingItems = orderItems.map(item => ({ ...item }));
        const hubsCopy = hubs.map(hub => ({
            ...hub,
            stock: { ...hub.stock }
        }));

        const splitResults: SplitOrderResult[] = [];

        // 1. Sort hubs: Primary first, then by total inventory size (heuristic)
        const sortedHubs = hubsCopy.sort((a, b) => {
            if (a.hubId === primaryHubId) return -1;
            if (b.hubId === primaryHubId) return 1;
            return Object.keys(b.stock).length - Object.keys(a.stock).length;
        });

        // 2. Iterate through hubs and allocate items
        for (const hub of sortedHubs) {
            const allocatedItems: OrderItem[] = [];

            for (let i = remainingItems.length - 1; i >= 0; i--) {
                const item = remainingItems[i];
                const availableStock = hub.stock[item.id] || 0;

                if (availableStock > 0) {
                    const takeQty = Math.min(item.quantity, availableStock);
                    allocatedItems.push({ id: item.id, quantity: takeQty });

                    item.quantity -= takeQty;
                    hub.stock[item.id] -= takeQty; // Mutate local copy

                    if (item.quantity === 0) {
                        remainingItems.splice(i, 1);
                    }
                }
            }

            if (allocatedItems.length > 0) {
                splitResults.push({ hubId: hub.hubId, items: allocatedItems });
            }

            if (remainingItems.length === 0) {
                break; // Fully allocated
            }
        }

        if (remainingItems.length > 0) {
            console.warn(`HubSplitter: Unfulfillable items remaining: ${JSON.stringify(remainingItems)}`);
            // In reality, this would trigger a backorder or user notification protocol
        }

        return splitResults;
    }
}
