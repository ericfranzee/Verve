export interface EventContext {
  eventName: string;
  hoursUntilEvent: number;
  historicalDemandMultiplier: number;
}

export function detect(context: EventContext): boolean {
  if (context.hoursUntilEvent <= 48 && context.historicalDemandMultiplier >= 1.5) {
    console.log(`[Chaos 5.10] Holiday Surge detected for ${context.eventName}. Hours until: ${context.hoursUntilEvent}.`);
    return true;
  }
  return false;
}

export function resolve(context: EventContext): string {
  if (context.hoursUntilEvent <= 48 && context.hoursUntilEvent > 24) {
    console.log(`[Chaos 5.10] T-48h: Auto-increasing base inventory targets for Zone Alpha by 200%.`);
    return `Resolved: Pre-staging inventory for ${context.eventName}`;
  } else if (context.hoursUntilEvent <= 24 && context.hoursUntilEvent > 0) {
    console.log(`[Chaos 5.10] T-24h: Aura proactively prompting frequent users to pre-stage/lock items.`);
    return `Resolved: Pre-staging Aura prompts initiated for ${context.eventName}`;
  } else {
    console.log(`[Chaos 5.10] Event Active: Tightening PoF thresholds (>0.90 required). Activating standby rider roster.`);
    return `Resolved: Active Surge Protocol enforced for ${context.eventName}`;
  }
}
