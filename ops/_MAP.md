# ops/ - Map

## Purpose
Infrastructure configuration, deployment manifests, and observability setup (Docker Compose, Kubernetes).

## Directories & Files
- `docker-compose.yml`: Local setup for Prometheus, Grafana, Loki, Promtail, and Jaeger.
- `prometheus/`: Contains `prometheus.yml` and `alert_rules.yml`.
- `grafana/`: Dashboards and provisioning configuration.
- `loki/`: Configuration for log aggregation.
- `jaeger/`: Tracing backend setup.

## Constraints
- Alerting rules must cover LLM latency, WS errors, PoF desync, payment cascade depth, and crashes.
