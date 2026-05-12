# apps/rider/lib/features/earnings/ - Map

## Purpose
Rider compensation engine interface and calculation.

## Files
- `engine.dart`: Earnings calculation and state management.

## Data Flow
Nexus API -> Earnings Service -> UI

## Constraints
- Base + Delivery + Surge + Perfect week bonuses.
- Realtime updating of earnings for the current shift.
