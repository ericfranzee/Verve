# services/nexus-api/src/dashboard/ — Structure Map

## Purpose
Nexus Lead Operations Dashboard (Web App) for hub leads. (PRD Phase 4, P4-T07).

## Files

| File | Lines | Responsibility | Key Exports |
|------|-------|---------------|-------------|
| index.html | ~40 | Lightweight static UI for Hub operations | N/A |

## Data Flow
User visits `/dashboard` → Express serves `index.html` → JavaScript triggers Nexus API endpoints to handle chaos modes.

## Constraints
- Total directory: < 50 lines across 1 file.
- The UI must be lightweight, providing immediate access to chaos triggers and active orders tracking without complex React/frontend builds (as per instructions it is a basic static view).
