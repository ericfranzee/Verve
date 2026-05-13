# apps/mobile/lib/features/sync/ — Structure Map

## Purpose
Manages state synchronization, offline intent queuing, and reconciliation between the local Edge environment and the Cloud Orchestrator.

## Files

- `offline_queue.dart`: Local SQLite-VEC queue to capture and store user intents when offline.
- `reconciliation_engine.dart`: Sync engine that synchronizes pending local intents with the cloud backend when connection is re-established.

## Constraints
- Do not exceed 500 lines per file (target 300).
- Must robustly handle offline/online transitions without data loss.
