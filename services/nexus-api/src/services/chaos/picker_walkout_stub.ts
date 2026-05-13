export interface PickerStatus {
  pickerId: string;
  isOnline: boolean;
  pendingTicketsCount: number;
  remainingPickersInHub: number;
}

export function detect(status: PickerStatus): boolean {
  if (!status.isOnline && status.pendingTicketsCount > 0) {
    console.log(`[Chaos 5.9] Picker Walkout detected for Picker ${status.pickerId}. Pending tickets: ${status.pendingTicketsCount}.`);
    return true;
  }
  return false;
}

export function resolve(status: PickerStatus, pendingTicketIds: string[]): string {
  console.log(`[Chaos 5.9] Redistributing ${pendingTicketIds.length} tickets to remaining pickers.`);

  if (status.remainingPickersInHub < 2) {
    console.log(`[Chaos 5.9] Remaining pickers < 2. Activating REDUCED SPEED mode (+5min ETA).`);
    console.log(`[Chaos 5.9] Paging Nexus Lead and enabling Emergency Pick interface for available Riders/Lead.`);
    return `Resolved: Tickets Redistributed. REDUCED SPEED activated. Emergency Pick enabled.`;
  }

  return `Resolved: Tickets Redistributed successfully.`;
}
