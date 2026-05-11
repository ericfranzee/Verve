# apps/rider/lib/features/shift/ - Map

## Purpose
Rider shift management and time tracking.

## Files
- `manager.dart`: Shift timer enforcing 8h max and 4h mandatory break.

## Data Flow
Rider UI -> Nexus API (Shift Service)

## Constraints
- 8h max shift.
- Mandatory 30-minute break at the 4-hour mark.
