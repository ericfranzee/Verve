export interface FleetStatus {
  totalRiders: number;
  availableRiders: number;
  nexusLeadTrigger: boolean;
}

export function detect(status: FleetStatus): boolean {
  const capacity = status.availableRiders / Math.max(1, status.totalRiders);
  if (status.nexusLeadTrigger || capacity < 0.40) {
    console.log(`[Chaos 5.6] Fleet Immobilization detected. Capacity at ${(capacity*100).toFixed(1)}%.`);
    return true;
  }
  return false;
}

export function resolve(): string {
  console.log(`[Chaos 5.6] Activating FLEET CONSTRAINED mode.`);
  console.log(`[Chaos 5.6] Adjusting delivery promises: 15-min -> 30-min, 30-min -> 60-min.`);
  console.log(`[Chaos 5.6] Aura notifying users of adjusted ETA due to fuel constraints.`);
  return `Resolved: FLEET CONSTRAINED mode activated. ETAs adjusted.`;
}
