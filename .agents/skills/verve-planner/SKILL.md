---
name: verve-planner
description: "Use when decomposing a Verve build phase into executable tasks, mapping dependencies, or generating phase plans with acceptance criteria and success metrics."
category: workflow
risk: safe
source: project
tags: "[planning, decomposition, dependency-mapping, task-graph, critical-path, success-metrics]"
date_added: "2026-05-10"
date_updated: "2026-05-10"
---

# Verve Planner — Phase & Task Decomposition

## Purpose

Transform Verve product requirements into executable, dependency-aware task graphs. Each task has inputs, outputs, acceptance criteria, layer ownership, and ties to measurable success metrics (Build Strategy §8).

## Source Documents

| Document | What It Provides |
|----------|-----------------|
| PRD | Features, cold start, revenue model, ambiguity resolution, failure tolerances |
| Core Blueprint | Architecture, Visual Synapse, failure mode map, circuit breakers, multi-hub routing |
| System Architecture | Components, data flows, security, observability pipeline |
| Build Strategy & Roadmap | Phases, risk register, success metrics per phase |
| Home Screen Spec | Morphing Viewport states, shader specs |
| Secondary Screens Spec | Guardian Vault, Pantry, History, Payments |
| Brand & Persona Manual | Colors, typography, Trust Ladder, Aura ambiguity resolution |
| Guardian Protocol | Privacy, purge, Trust Ladder technical, degraded handshake cascade |
| Nexus Operations Manual | MFC zones, 10 chaos protocols, rider reality |

## Task Anatomy

Every task MUST include:
```markdown
### [TASK-ID] Task Name
- **Layer:** Flutter | Go | Python | Node.js | Edge
- **Phase:** 1-4
- **Depends On:** [task IDs]
- **Inputs / Outputs / Acceptance Criteria / Edge Cases**
- **Builder:** verve-flutter-builder | verve-backend-builder | verve-nexus-builder | verve-edge-builder
- **Success Metric Link:** Which Build Strategy §8 metric this contributes to
```

---

## Phase 1: Invisible Intelligence (Weeks 1-4)

### Week 1 — Infrastructure
- P1-T01: Go Orchestrator skeleton (WebSocket server, session state machine)
- P1-T02: Python FastAPI Intent Engine (health endpoint, Whisper stub, LLM stub)
- P1-T03: Mono-repo scaffold (Flutter, Go, Python, Node.js directories)

### Week 2 — The Memory Vault
- P1-T04: SQLite-VEC integration (schema with trust_level_required column)
- P1-T05: CRUD for local embeddings (save, retrieve, reinforce, delete)
- P1-T06: SQLCipher encryption with Keystore/Secure Enclave
- **P1-T14: [NEW] Trust Ladder data access enforcement in SQLite-VEC queries**
- **P1-T15: [NEW] Temporal decay pruning (90-day archive threshold)**
- **P1-T16: [NEW] DB corruption recovery (integrity check → cloud restore → Day 1 reset)**

### Week 3 — The Brain
- P1-T07: RAG prompt pipeline with Trust Ladder context gating
- P1-T08: Temporal reference resolution ("Monday" → SKU lookup)
- P1-T09: Dietary constraint enforcement (allergen interception)
- **P1-T17: [NEW] Ambiguity Resolution engine (vague, contradiction, emotional state)**
- **P1-T18: [NEW] MoE LLM router (simple → fast model <200ms, complex → large model)**

### Week 4 — The Voice Loop
- P1-T10: PCM audio capture pipeline (Flutter → C++ FFI → WebSocket)
- P1-T11: Whisper transcription with confidence threshold (<60% → retry)
- P1-T12: Complete round-trip loop (Voice → Transcription → Inference → TTS)
- P1-T13: Optimize round-trip latency (target: <1.2s P95)
- **P1-T19: [NEW] Circuit breaker skeleton (per-service breakers in Go Orchestrator)**
- **P1-T20: [NEW] Redis session state snapshots (5-second intervals)**
- **P1-T21: [NEW] Session crash recovery (reconnect with session_id → Redis restore)**

**Success Metrics (Build Strategy §8):**
- Voice-to-TTS round trip < 1.2s (P95)
- RAG recall accuracy > 90%
- SQLite-VEC query latency < 50ms
- Whisper accuracy (Nigerian English) > 90%

**Dependency Graph:**
```
P1-T03 → P1-T01, P1-T02 (parallel)
P1-T04, P1-T05, P1-T06 → P1-T03
P1-T14, P1-T15, P1-T16 → P1-T04, P1-T05 (parallel)
P1-T07 → P1-T04, P1-T05, P1-T14
P1-T17 → P1-T07
P1-T18 → P1-T07
P1-T10, P1-T11 → P1-T01
P1-T12 → P1-T10, P1-T11, P1-T07
P1-T13 → P1-T12
P1-T19 → P1-T01
P1-T20, P1-T21 → P1-T19
```

---

## Phase 2: Visual Stage (Weeks 5-8)

### Week 5 — State & Structure
- P2-T01: Riverpod state management architecture
- P2-T02: Morphing Viewport widget stack
- P2-T03: Design system tokens (Teal, Amber, Emerald, Cyan)

### Week 6 — The Visual Synapse
- P2-T04: Intent Engine → JSON UI-Metadata (Synapse Payload)
- P2-T05: Audio-Metadata Sync Listener (tts_position_ms → ui transition)
- P2-T06: Hero Card state (parallax, overlays, swipe gestures)
- P2-T07: Proposal state (overlapping cards, Z-index, Guardian Shield)

### Week 7 — Aura Identity & Trust UI
- P2-T08: Breathing Wave GLSL shader (4 states) — full + lite variants
- P2-T09: Pre-compile shaders via Impeller pipeline
- P2-T10: Haptic feedback system
- P2-T11: Auditory cues (Wake, Synapse, Confirmation)
- **P2-T15: [NEW] Bootstrap Dialogue screen (Day 1 onboarding — 90s voice calibration)**
- **P2-T16: [NEW] Neighborhood Starter Basket screen (cold start fallback)**
- **P2-T17: [NEW] Trust Ladder display in Guardian Vault (level + data breakdown)**
- **P2-T18: [NEW] Emotional State visual feedback (Execution/Discovery/Precision modes)**

### Week 8 — Adaptive Fidelity & Subscription
- P2-T12: Network monitoring background isolate
- P2-T13: Adaptive Fidelity Engine (high-res → SVG at >400ms or 3G)
- P2-T14: TTS bitrate downgrade for low bandwidth
- **P2-T19: [NEW] Connection-degraded UI states (Amber pulse, "Aura is thinking...", offline dim)**
- **P2-T20: [NEW] Verve+ subscription card in Payments screen**
- **P2-T21: [NEW] Verve+ natural nudge logic (Aura surfaces savings after 4+ orders)**
- **P2-T22: [NEW] Cold Start Pantry ("Popular in Your Area" with personalization label)**

**Success Metrics (Build Strategy §8):**
- UI frame rate > 60fps sustained (120fps target)
- Cold start to Idle Wave < 1.5s
- Battery < 2% per 5-min session
- Visual Synapse sync within 50ms of TTS word
- Adaptive Fidelity triggers correctly on simulated 3G

---

## Phase 3: Nexus Pilot (Weeks 9-14)

### Week 9 — Nexus API Foundation
- P3-T01: Node.js/GraphQL Nexus API skeleton
- P3-T02: PostgreSQL schema + Redis caching layer
- P3-T03: PoF engine with Redis desync detection and recovery
- P3-T04: Wire Intent Engine → Nexus API inventory queries
- **P3-T14: [NEW] Single-Hub routing policy enforcement (no split orders)**

### Week 10 — Payments
- P3-T05: Paystack integration (primary)
- P3-T06: Flutterwave integration (secondary)
- P3-T07: Payment Cascade Router (16s total timeout, 4 levels)
- P3-T08: Verve Wallet (pre-funded NGN balance)
- **P3-T15: [NEW] Pay-on-Delivery fallback via Bio-Handshake terminal**

### Week 11 — Rider & Delivery
- P3-T09: Rider Pulse App (lightweight Flutter — dispatch, navigation, earnings)
- P3-T10: Bio-Handshake protocol (Level 0: full BLE + Visual TOTP)
- P3-T11: GIS Canvas state (dark map, rider chevron, traffic heatmap)
- P3-T12: Frosted Receipt overlay
- **P3-T16: [NEW] Degraded Bio-Handshake cascade (Levels 1-3: Visual, OTP, Callback)**
- **P3-T17: [NEW] Rider SOS protocol (3-second hold, GPS broadcast, delivery freeze)**
- **P3-T18: [NEW] Rider compensation engine (base + delivery + surge + perfect week)**
- **P3-T19: [NEW] Route safety enforcement (ban zones, night cutoff, weather lockout)**
- **P3-T20: [NEW] Rider shift manager (8h max, mandatory break at 4h)**

### Week 12-13 — Chaos Protocols
- **P3-T21: [NEW] Chaos Protocol 5.1: Spoilage Swap**
- **P3-T22: [NEW] Chaos Protocol 5.2: Traffic Gridlock Reroute**
- **P3-T23: [NEW] Chaos Protocol 5.3: Power Grid Failure (IoT temp → PoF zero)**
- **P3-T24: [NEW] Chaos Protocol 5.4: Rider Device Failure (degraded handshake dispatch)**
- **P3-T25: [NEW] Chaos Protocol 5.5: User Not Home (cold-hold return)**
- **P3-T26: [NEW] Chaos Protocol 5.6: Fleet Immobilization (fuel scarcity mode)**
- **P3-T27: [NEW] Chaos Protocol 5.7: Hub Flooding (zone lockout)**
- **P3-T28: [NEW] Chaos Protocol 5.8: Coordinated Fraud (velocity model)**
- **P3-T29: [NEW] Chaos Protocol 5.9: Picker Walkout (ticket redistribution)**
- **P3-T30: [NEW] Chaos Protocol 5.10: Holiday Surge (pre-staging)**

### Week 14 — Beta & Observability
- P3-T13: 50 closed-beta provisioning events
- **P3-T31: [NEW] Observability pipeline (Prometheus + Grafana + Loki + Jaeger)**
- **P3-T32: [NEW] Alerting thresholds (5 metrics: LLM latency, WS errors, payment depth, PoF desync, crashes)**
- **P3-T33: [NEW] Distributed tracing across Go → Python → Node.js**

**Success Metrics (Build Strategy §8):**
- 50+ closed-beta deliveries
- PoF accuracy > 95%
- Payment cascade success > 99%
- Bio-Handshake Level 0 success > 95%
- Order-to-delivery < 15 min (P80, 5km)

---

## Phase 4: Guardian & Scale (Weeks 15-20)

- P4-T01: Guardian Vault screen (Ledger, Purge, KYC, Trust Ladder display)
- P4-T02: Predictive Pantry screen (Depletion Horizon, Train-the-AI)
- P4-T03: Semantic History screen (event timeline, Re-Provision)
- P4-T04: Payment Cascade Manager screen
- P4-T05: Human Bridge escalation overlay
- P4-T06: Purge Protocol (< 2s, key destruction + cloud cascade)
- P4-T07: Nexus Lead dashboard (web app)
- P4-T08: Penetration testing of Go Orchestrator
- P4-T09: NDPA compliance audit (+ Trust Ladder compliance)
- P4-T10: Geo-fenced soft launch
- **P4-T11: [NEW] Circuit breaker behavior verification (all 3 breakers tested)**
- **P4-T12: [NEW] Failure tolerance threshold monitoring (7 metrics from PRD §4.4)**
- **P4-T13: [NEW] Chaos protocol simulation testing (all 10 protocols in CI)**
- **P4-T14: [NEW] Degraded handshake cascade verification (all 4 levels field-tested)**
- **P4-T15: [NEW] Risk register review (mitigate/close all HIGH probability risks)**

**Success Metrics (Build Strategy §8):**
- NPS > 70
- DAU retention at 30 days > 40%
- NDPA violations: 0
- Trust Ladder: > 60% users reach Level 2 within 30 days
- Human Bridge escalation < 5%
- Purge Protocol: 100% within 2 seconds

---

## Phase 5: Holographic Ecosystem & Next-Gen Deployments (Weeks 21-26)

### Week 21 — Edge AI Infrastructure
- **P5-T01: Edge SLM Integrator (Flutter → Local ONNX/TFLite)**
- **P5-T02: Offline Intent Queue (Local queuing of un-synced commands)**
- **P5-T03: Hybrid State Sync Engine (Edge-Cloud reconciliation)**

### Week 22 — Ambient Extensions
- **P5-T04: Wearable UI Companion (watchOS/WearOS)**
- **P5-T05: Automotive UI (CarPlay/Android Auto)**
- **P5-T06: Spatial Depletion Horizon (AR prototype)**

### Week 23 — Multi-Node Mesh Routing
- **P5-T07: Dynamic Hub Splitter (Nexus API algorithm)**
- **P5-T08: Synchronized Dispatch Engine (Rider throttling for simultaneous arrival)**
- **P5-T09: Inter-Hub Transfer Protocol (Predictive stock balancing)**

### Week 24 — Agentic Hub Operations
- **P5-T10: Prometheus AI Monitor (Node.js agent polling telemetry)**
- **P5-T11: Autonomous Gridlock Resolution (Agent triggering Chaos Protocols)**
- **P5-T12: Rider AI Copilot (Synthesized voice alerts for Rider Pulse)**

### Week 25 — Zero-Touch Commerce
- **P5-T13: Autonomous Provisioning Engine (Cron-based automatic fulfillment)**
- **P5-T14: Smart Contract Ledger (Automated deductions logic)**
- **P5-T15: Trust Level 4 Gate (Enforcement of zero-touch requirements)**

### Week 26 — Scale & National Rollout
- **P5-T16: Phase 5 Penetration Testing (Edge model extraction defense)**
- **P5-T17: Mesh Network Load Test (1000+ concurrent multi-node orders)**
- **P5-T18: National Rollout Configuration (Lagos & Abuja un-geofencing)**

**Success Metrics (Build Strategy §8):**
- Offline Intent Resolution Rate > 95%
- Ambient Interface Usage > 15% of total orders
- Agentic Chaos Resolution > 80%
- Multi-Node Synchronized Arrival Delta < 60 seconds

---

## Plan Output Format

Each phase plan saved as `.agents/plans/phase-N-plan.md`:

```markdown
# Phase N: [Name] — Build Plan
## Overview, Task List, Dependency Graph (Mermaid)
## Critical Path, Parallelization Opportunities
## Success Metrics (from Build Strategy §8)
## Acceptance Gate (MUST PASS + SHOULD PASS)
```
