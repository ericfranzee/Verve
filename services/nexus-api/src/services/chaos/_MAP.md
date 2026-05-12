# services/nexus-api/src/services/chaos/ - Map

## Purpose
Implementation of the 10 Chaos Protocols required for the Verve Nexus API, ensuring resilient operations against common operational disruptions in the Nigerian market.

## Files
| File | Responsibility |
|------|----------------|
| `spoilage_swap.ts` | Chaos 5.1: Detect spoilage via IoT, auto-substitute SKU. |
| `traffic_gridlock.ts` | Chaos 5.2: Detect rider stall, evaluate ETA, compensate user. |
| `power_grid.ts` | Chaos 5.3: Detect power failure, zero PoF for cold chain. |
| `rider_device.ts` | Chaos 5.4: Handle rider device failure, trigger degraded handshake cascade. |
| `user_not_home.ts` | Chaos 5.5: Enforce cold-hold return if user is not available. |
| `fleet_immobilization.ts` | Chaos 5.6: Manage fuel scarcity mode and adjust ETAs. |
| `hub_flooding.ts` | Chaos 5.7: Lockout affected zones, reduce hub capacity. |
| `coordinated_fraud.ts` | Chaos 5.8: Velocity model for detecting order/cancellation fraud patterns. |
| `picker_walkout.ts` | Chaos 5.9: Redistribute picking tickets, activate emergency pick mode. |
| `holiday_surge.ts` | Chaos 5.10: Pre-stage inventory, prompt users, tighten PoF threshold. |

## Data Flow
Trigger -> Detection (`detect()` returns boolean) -> Action & Aura Comm (`resolve()` returns resolution string).

## Constraints
- Each module must export `detect(context)` and `resolve(context)` functions.
- All protocols are designed to fail gracefully and communicate transparently to users via Aura.
