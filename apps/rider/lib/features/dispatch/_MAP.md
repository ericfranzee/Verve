# apps/rider/lib/features/dispatch/ - Map

## Purpose
Dispatch and routing management for the Verve Rider app. This module handles order routing, GIS mapping visualization, and order dispatch protocols.

## Files
- `gis_canvas.dart`: Simulated Dark Map UI with Rider Chevron and Traffic Heatmap (P3-T11).
- `receipt_overlay.dart`: Frosted receipt UI overlay for displaying items at delivery destination (P3-T12).

## Data Flow
Orchestrator/Nexus -> Dispatch Service -> Map Display

## Constraints
- GIS Canvas state uses a dark map with a rider chevron and traffic heatmap.
