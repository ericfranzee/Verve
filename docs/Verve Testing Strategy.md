# Verve: Testing Strategy v1.0

**Document Status:** Engineering Ready  
**Date:** May 13, 2026

## 1. Testing Philosophy

Every feature in Verve must pass three gates before merge: **Unit Tests** (logic correctness), **Integration Tests** (service-to-service contracts), and **Smoke Tests** (critical user paths). Code without tests is considered unfinished, regardless of feature completeness.

## 2. Test Pyramid by Layer

### 2.1 Flutter Consumer App — `apps/mobile/test/`

| Type | Framework | What to Test | Coverage |
|------|-----------|-------------|----------|
| **Unit** | `flutter_test` | State management (Riverpod notifiers), business logic, data transformations | 80% |
| **Widget** | `flutter_test` + `mocktail` | Individual widgets render correctly, state changes trigger UI updates | 70% |
| **Integration** | `integration_test` | Full flows: onboarding → voice → order → tracking → handshake | Critical paths |

**Key Test Files:**
```
test/
├── core/
│   ├── edge_db/db_service_test.dart
│   ├── encryption/encryption_service_test.dart
│   └── theme/verve_theme_test.dart
├── features/
│   ├── viewport/morphing_viewport_test.dart
│   ├── aura/breathing_wave_test.dart
│   ├── voice/audio_capture_test.dart
│   ├── synapse/synapse_listener_test.dart
│   ├── payment/payment_cascade_test.dart
│   ├── memory/memory_manager_test.dart
│   ├── onboarding/bootstrap_dialogue_test.dart
│   └── vault/guardian_vault_test.dart
└── integration/
    ├── onboarding_flow_test.dart
    ├── order_flow_test.dart
    └── purge_protocol_test.dart
```

### 2.2 Flutter Rider App — `apps/rider/test/`

| Type | What to Test |
|------|-------------|
| **Unit** | Shift enforcement logic, earnings calculation, SOS state machine |
| **Widget** | GIS canvas rendering, handshake cascade UI, dispatch receipt |
| **Integration** | Dispatch accept → navigate → handshake flow |

### 2.3 Go Orchestrator — `services/orchestrator/internal/*_test.go`

| Type | What to Test |
|------|-------------|
| **Unit** | Circuit breaker state transitions, session state management, TOTP generation |
| **Integration** | WebSocket connection lifecycle, message routing, purge cascade |
| **Load** | WebSocket concurrent connections (target: 5000 simultaneous) |

```bash
cd services/orchestrator && go test ./... -v -count=1
```

### 2.4 Python Intent Engine — `services/intent-engine/tests/`

| Type | Framework | What to Test |
|------|-----------|-------------|
| **Unit** | `pytest` | Prompt builder output, temporal resolver, dietary enforcer blocklist |
| **API** | `httpx` + `pytest` | All FastAPI endpoints with mock LLM responses |
| **Contract** | `pytest` | Synapse payload schema validation |

```bash
cd services/intent-engine && python -m pytest tests/ -v
```

### 2.5 Node.js Nexus API — `services/nexus-api/src/tests/`

| Type | Framework | What to Test |
|------|-----------|-------------|
| **Unit** | `jest` | PoF engine scoring, payment cascade routing, chaos protocol triggers |
| **Integration** | `jest` + `supertest` | GraphQL queries/mutations against test database |
| **Schema** | `jest` | GraphQL schema validation, type checking |

```bash
cd services/nexus-api && npm test
```

## 3. Critical Test Scenarios

### Scenario 1: Voice-to-Order Pipeline
```
1. Audio capture → Orchestrator WebSocket → Intent Engine transcription
2. Intent Engine → inference → synapse payload
3. Synapse payload → Nexus API inventory check → PoF verification
4. Order creation → payment cascade → picker assignment
```

### Scenario 2: Payment Cascade Exhaustion
```
1. Paystack → 5xx error → cascade to Flutterwave
2. Flutterwave → timeout (>4s) → cascade to Wallet
3. Wallet → insufficient balance → cascade to PoD
4. PoD → order flagged as pay-on-delivery
```

### Scenario 3: Bio-Handshake Degradation
```
1. BLE handshake → success (Level 0)
2. BLE failure → Visual color match (Level 1)
3. Visual failure → OTP fallback (Level 2)
4. OTP failure → Hub callback (Level 3)
```

### Scenario 4: Chaos Protocol Triggers
```
Test each of the 10 chaos protocols independently:
1. Spoilage Swap: Picker rejects → user notified → substitute offered
2. Power Grid: Temp rise → Zone Beta locked → PoF zeroed
3. Hub Flooding: Zone locked → reduced capacity notification
4. Fleet Immobilization: ETAs extended → Verve+ priority maintained
```

## 4. Test Data & Fixtures

- **Seed script:** `services/nexus-api/scripts/seed.ts`
- **Test hub:** "WUSE-II" with 50 products across all zones
- **Test users:** 5 customers (trust levels 0-3), 3 riders, 2 pickers, 1 hub manager, 1 admin
- **Test products:** Representative items from each zone (eggs, salmon, rice, whisky)

## 5. E2E Mobile Testing

**Framework:** Maestro  
**Location:** `tests/e2e/`

```yaml
# tests/e2e/onboarding_flow.yaml
appId: ng.verve.app
---
- launchApp
- assertVisible: "Verve — The Void"
- tapOn: { id: "mic_button" }
- assertVisible: { text: "Listening" }
- inputText: "I need milk and eggs"
- assertVisible: { text: "Provisioning" }
```

## 6. Performance Benchmarks

| Metric | Target | Test Method |
|--------|--------|-------------|
| Voice-to-TTS round trip | < 1.2s | Automated API timing |
| App cold start | < 1.5s | Flutter profile build timing |
| Morphing Viewport transition | 120fps | Flutter DevTools frame analysis |
| GraphQL product query (50 items) | < 200ms | Jest timing assertions |
| WebSocket connection setup | < 500ms | Go benchmark test |
| Bio-Handshake total | < 3s | Integration test timing |
