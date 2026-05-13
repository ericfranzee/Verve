# services/nexus-api/src/services/commerce/ — Structure Map

## Purpose
Handles Phase 5 "Zero-Touch Commerce", allowing Verve to autonomously provision items based on depletion horizons without requiring explicit user approval.

## Files
- `trustGate.ts`: Strictly enforces Trust Level 4 (Partner) before permitting autonomous generation.
- `smartLedger.ts`: Interface to securely deduct from Verve Wallets without user initiation.
- `provisioningEngine.ts`: The cron-based coordinator that scans depletion horizons, calls the Trust Gate, executes via the Smart Ledger, and issues dispatch orders.

## Constraints
- Max 500 lines per file.
- Any failure in the `SmartLedger` for an autonomous charge immediately triggers a demotion from Trust Level 4 in the real application lifecycle.