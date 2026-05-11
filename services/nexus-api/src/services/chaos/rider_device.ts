export interface RiderStatus {
  riderId: string;
  orderId: string;
  lastPingMinutesAgo: number;
  isInActiveDelivery: boolean;
}

export function detect(status: RiderStatus): boolean {
  if (status.isInActiveDelivery && status.lastPingMinutesAgo > 3) {
    console.log(`[Chaos 5.4] Rider Device Failure detected for Rider ${status.riderId} on Order ${status.orderId}.`);
    return true;
  }
  return false;
}

export function resolve(orderId: string, riderId: string, timeOfflineMinutes: number): string {
  console.log(`[Chaos 5.4] Resolving Device Failure for Order ${orderId}. Alerting Hub.`);

  if (timeOfflineMinutes > 10) {
     console.log(`[Chaos 5.4] Rider offline > 10m. Nexus Lead dispatching backup rider.`);
     return `Resolved: Backup Rider Dispatched for Order ${orderId}`;
  } else {
     console.log(`[Chaos 5.4] Triggering Degraded Handshake Cascade (Level 1/2/3) for Order ${orderId}.`);
     return `Resolved: Degraded Handshake Initiated for Order ${orderId}`;
  }
}
