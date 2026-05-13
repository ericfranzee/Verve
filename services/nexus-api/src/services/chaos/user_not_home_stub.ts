export interface DeliveryEvent {
  orderId: string;
  riderId: string;
  action: string;
  timeAtDestinationMinutes: number;
}

export function detect(event: DeliveryEvent): boolean {
  if (event.action === 'RECIPIENT_UNAVAILABLE' || event.timeAtDestinationMinutes >= 5) {
    console.log(`[Chaos 5.5] User Not Home detected for Order ${event.orderId}.`);
    return true;
  }
  return false;
}

export function resolve(orderId: string, timeAtDestinationMinutes: number): string {
  if (timeAtDestinationMinutes < 10) {
    console.log(`[Chaos 5.5] Aura notifying user: 'Your rider is at your door. Waiting 5 more minutes.'`);
    return `Pending: Waiting at destination for Order ${orderId}`;
  } else {
    console.log(`[Chaos 5.5] Time exceeded. Rider returning to Hub. Cold items to Zone Beta.`);
    console.log(`[Chaos 5.5] Aura notifying user: 'Returned to hub. Hold for 2 hours.'`);
    return `Resolved: Order ${orderId} returned to hub for Cold-Hold`;
  }
}
