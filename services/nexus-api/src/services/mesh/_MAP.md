# services/nexus-api/src/services/mesh/ — Structure Map

## Purpose
Handles multi-node routing for Verve Phase 5. Upgrades the fulfillment engine from a single-hub constraint to a dynamic, synchronized distributed mesh of Micro-Fulfillment Centers (MFCs).

## Files
- `hubSplitter.ts`: Algorithm for splitting an order across multiple hubs when inventory demands it.
- `syncDispatch.ts`: Calculates dispatch delays for faster riders to ensure all split orders arrive at the user simultaneously.
- `interHubTransfer.ts`: Predictively balances stock between hubs to prevent depletion.

## Constraints
- TypeScript strict mode must be followed.
- Must not exceed 500 lines per file.