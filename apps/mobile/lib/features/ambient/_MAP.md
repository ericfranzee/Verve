# apps/mobile/lib/features/ambient/ — Structure Map

## Purpose
Contains the ambient computing extensions for Verve (Phase 5), integrating the voice interface directly into environmental factors outside the smartphone.

## Files
- `wearable_companion.dart`: watchOS/WearOS platform channel scaffolding.
- `automotive_ui.dart`: CarPlay/Android Auto continuous voice listener.
- `spatial_horizon.dart`: AR prototype overlay mapping pantry depletion spatially.

## Constraints
- Max 500 lines per file.
- Wearable/Auto integrations strictly use platform channels targeting native extensions, rather than running full Flutter engines in the background.