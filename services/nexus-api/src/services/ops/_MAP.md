# services/nexus-api/src/services/ops/ — Structure Map

## Purpose
Agentic Hub Operations. Contains autonomous backend agents that poll observability metrics (e.g. Prometheus) and trigger autonomous protocols (like Chaos Protocol 5.2 or Rider AI Copilot) without human intervention.

## Files
- `prometheusMonitor.ts`: Agent continuously parsing observability metrics and autonomously triggering Gridlock Resolution and Copilot alerts.

## Constraints
- Max 500 lines per file.
- Strict type checking.