# Verve Risk Register & Mitigation Log (Phase 4)

## Operational Risks

### OR-01: Rider Device Failure Mid-Delivery
* **Risk:** A rider loses network or power during an active delivery, preventing the required Bio-Handshake.
* **Mitigation:** Implemented Chaos Protocol 5.4 (`rider_device.ts`). Detects offline riders (>3 mins) and triggers a degraded handshake cascade (Visual -> OTP -> Hub Callback). If >10 mins, automatically dispatches a backup rider.

### OR-02: Extreme Weather / Hub Flooding
* **Risk:** Nigerian rainy season causes physical water ingress into Micro-Fulfillment Center (MFC) zones.
* **Mitigation:** Implemented Chaos Protocol 5.7 (`hub_flooding.ts`). Locks out affected zones from the Probability of Fulfillment (PoF) engine instantly.

### OR-03: Rider Dispatch in Ban Zones
* **Risk:** Riders are illegally routed through motorcycle ban zones (e.g. Third Mainland Bridge in Lagos), endangering their safety.
* **Mitigation:** Implemented strict route enforcement checks (`apps/rider/lib/features/safety/route_enforcement.dart`) validating against known `BanZone` polygons. Returns `RouteSafetyStatus(isSafe: false)` and prevents dispatch.

## Security & Compliance Risks

### SC-01: Unauthorized API Origin Spoofing
* **Risk:** Attackers bypass web client bounds by spoofing origins on the Go Orchestrator WebSocket endpoints.
* **Mitigation:** `CheckOrigin` configuration on gorilla/websocket upgrader strictly validates incoming origins against an `ALLOWED_ORIGINS` environment variable whitelist.

### SC-02: Unauthorized Context Purge
* **Risk:** An attacker or malicious extension forces a total erasure of a user's local and cloud AI context (Purge Protocol).
* **Mitigation:** The `HandlePurge` endpoint in Go Orchestrator and `/internal/purge` in Python Intent Engine demand authenticated `Authorization: Bearer` headers.

### SC-03: Plaintext PII Data Leakage (NDPA Compliance)
* **Risk:** The Nigeria Data Protection Act (NDPA) and strict privacy bounds are violated due to PII logged or hardcoded in repositories.
* **Mitigation:** Automated `scripts/ndpa_compliance_audit.py` integrated to actively regex-scan all commits across Go, Python, Dart, and Node.js for 11-digit BVNs, passwords, and credit card numbers.

### SC-04: Circuit Breaker Failure Cascades
* **Risk:** Downstream Intent Engine failures crash the Go Orchestrator or hang incoming WebSockets indefinitely.
* **Mitigation:** Implemented state-machine Circuit Breakers (`breaker.go`) and configured PromQL alerts (`ops/prometheus/alert_rules.yml` -> `CircuitBreakerTripped`) to monitor and handle `StateOpen` fallbacks securely.
