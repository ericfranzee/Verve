# apps/rider/lib/features/handshake/ - Map

## Purpose
Implementation of the Bio-Handshake cascade protocol for secure delivery confirmation.

## Files
- `cascade.dart`: 4-level fallback logic for Bio-Handshake.

## Data Flow
Level 0 (BLE) -> Level 1 (Visual) -> Level 2 (OTP) -> Level 3 (Callback)

## Constraints
- Must handle 4 levels of the cascade.
- Fallback must degrade gracefully without user prompt.
