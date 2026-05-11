export interface IoTEvent {
  sensorId: string;
  type: string;
  value: any;
  timestamp: string;
}

export interface SKU {
  id: string;
  name: string;
  quality: number; // 0-100
}

export function detect(event: IoTEvent, sku: SKU): boolean {
  if (event.type === 'spoilage_detected' || sku.quality < 80) {
    console.log(`[Chaos 5.1] Spoilage detected for SKU: ${sku.id}`);
    return true;
  }
  return false;
}

export function resolve(orderId: string, spoiledSku: SKU, availableInventory: SKU[]): string {
  // Find equivalent or better SKU
  const substitute = availableInventory.find(item => item.quality >= 90 && item.id !== spoiledSku.id);

  if (substitute) {
    console.log(`[Chaos 5.1] Resolving order ${orderId}: Substituted ${spoiledSku.name} with ${substitute.name}. Aura notified.`);
    return `Resolved: Swapped ${spoiledSku.name} for ${substitute.name}`;
  }

  console.log(`[Chaos 5.1] No equivalent SKU found for ${spoiledSku.name}. Aura notifying user of missing item.`);
  return `Unresolved: Missing item ${spoiledSku.name}`;
}
