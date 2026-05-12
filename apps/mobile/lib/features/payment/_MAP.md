# apps/mobile/lib/features/payment/ — Structure Map

## Purpose
Manages the Payment and Routing Configuration. (PRD §4.4, Secondary Screens §5)

## Files

| File | Lines | Responsibility | Key Exports |
|------|-------|---------------|-------------|
| payment_cascade_screen.dart | ~160 | Payment cascade and Verve+ wallet top-up UI | `PaymentCascadeScreen`, `paymentCascadeProvider` |

## Data Flow
User reorders list → updates `paymentCascadeProvider` → repaints UI cascade slots.

## Constraints
- Total directory: < 200 lines across 1 file.
- Strict utilitarian design, uses ReorderableListView for drag-and-drop ordered fallback.
