# apps/rider/lib/features/safety/ - Map

## Purpose
Rider safety and SOS protocols.

## Files
- `route_enforcement.dart`: Evaluates route safety (weather, night cutoff, ban zones).
- `sos.dart`: SOS button and trigger engine.

## Data Flow
SOS Button (3s hold) -> Orchestrator (Freezes delivery, alerts hub, broadcasts GPS)

## Constraints
- Route safety enforcement (ban zones, weather lockout).
