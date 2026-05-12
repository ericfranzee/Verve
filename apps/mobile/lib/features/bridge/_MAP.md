# apps/mobile/lib/features/bridge/ — Structure Map

## Purpose
Manages the "Human Bridge" (Nexus Escalation View). (Secondary Screens §6)

## Files

| File | Lines | Responsibility | Key Exports |
|------|-------|---------------|-------------|
| human_bridge_overlay.dart | ~140 | Overlay for Nexus Lead concierge | `HumanBridgeOverlay`, `humanBridgeProvider` |

## Data Flow
User pushes to talk / types → updates `humanBridgeProvider` / sends message to Nexus Lead.

## Constraints
- Total directory: < 200 lines across 1 file.
- The UI features a distinct visual shift with Nexus Amber glowing borders.
