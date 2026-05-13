# AGENT.md — Verve Cognitive Commerce Platform

> **Read this file first.** It contains everything an AI agent needs to understand the project, locate documentation, and execute tasks correctly.

---

## 1. Project Overview

**Verve** is a voice-first cognitive commerce platform for Lagos, Nigeria. Users speak to an AI persona called **Aura** to order groceries, which are fulfilled through a network of micro-fulfillment centers (MFCs/Hubs) and delivered by motorcycle riders.

### Core Architecture (4 Layers)

| Layer | Tech | Directory | Purpose |
|-------|------|-----------|---------|
| **Flutter Consumer App** | Dart/Flutter + Impeller | `apps/mobile/` | Voice UI, Morphing Viewport, shaders, Guardian Vault |
| **Flutter Rider App** | Dart/Flutter (lightweight) | `apps/rider/` | Dispatch, navigation, Bio-Handshake, SOS, earnings |
| **Go Orchestrator** | Go + WebSocket + Redis | `services/orchestrator/` | Session state machine, circuit breakers, audio routing |
| **Python Intent Engine** | Python + FastAPI | `services/intent-engine/` | Whisper transcription, RAG pipeline, LLM inference, Aura persona |
| **Node.js Nexus API** | TypeScript + GraphQL + PostgreSQL | `services/nexus-api/` | Inventory, orders, PoF engine, payments, chaos protocols |
| **Observability** | Prometheus + Grafana + Loki + Jaeger | `ops/` | Metrics, dashboards, logs, distributed tracing |

---

## 2. Required Reading (Priority Order)

Before executing ANY task, read the relevant skill files and documentation:

### Skills (`.agents/skills/`)

| Skill | File | Read When |
|-------|------|-----------|
| **Conductor** | `.agents/skills/verve-conductor/SKILL.md` | Starting any session — master orchestration |
| **Planner** | `.agents/skills/verve-planner/SKILL.md` | Understanding the task list and phase definitions |
| **Cognitive Load** | `.agents/skills/verve-cognitive-load/SKILL.md` | **MANDATORY before writing code** — 300-line rule, 4-file context budget |
| **Flutter Builder** | `.agents/skills/verve-flutter-builder/SKILL.md` | Any Flutter/Dart task |
| **Backend Builder** | `.agents/skills/verve-backend-builder/SKILL.md` | Any Go or Python task |
| **Nexus Builder** | `.agents/skills/verve-nexus-builder/SKILL.md` | Any Node.js/logistics/rider task |
| **Edge Builder** | `.agents/skills/verve-edge-builder/SKILL.md` | SQLite-VEC, TFLite, on-device AI |
| **Verifier** | `.agents/skills/verve-verifier/SKILL.md` | Running verification gates |
| **Memory** | `.agents/skills/verve-memory/SKILL.md` | Loading/saving build state |

### Product Documentation (`docs/`)

| Document | Key Content |
|----------|-------------|
| `docs/Verve Product Requirements Document.md` | Features, cold start, revenue model, failure tolerances (§4.4) |
| `docs/Verve Core Blueprint.md` | Architecture, Visual Synapse, circuit breakers (§5.4), multi-hub routing (§7) |
| `docs/Verve System Architecture.md` | Components, data flows, security, observability (§7) |
| `docs/Verve Build Strategy & Roadmap.md` | Phases, risk register (§7), success metrics (§8) |
| `docs/Verve Home Screen Specification.md` | Morphing Viewport states, shader specs |
| `docs/Verve Secondary Screens Specification.md` | Guardian Vault, Pantry, History, Payments |
| `docs/Verve Brand & Persona Manual.md` | Colors, typography, Trust Ladder (§1.1), Aura ambiguity resolution (§3.2) |
| `docs/Verve Guardian Protocol.md` | Privacy, purge, Trust Ladder technical (§5.3), degraded handshake cascade (§5.4) |
| `docs/Verve Nexus Operations Manual.md` | MFC zones, 10 chaos protocols (§5), rider reality (§6) |

### Build State

| File | Purpose |
|------|---------|
| `.agents/state/build-state.json` | Current phase, task completion status, decision log |
| `.agents/manifest.json` | Skill registry, phase definitions, document paths |
| `.agents/plans/phase-{N}-plan.md` | Detailed task plans per phase |

---

## 3. Current Project State

### Completed Phases

| Phase | Name | Status | Weeks | Tasks |
|-------|------|--------|-------|-------|
| **1** | Invisible Intelligence | ✅ COMPLETE | 1-4 | 21/21 |
| **2** | Visual Stage | ✅ COMPLETE | 5-8 | 22/22 |
| **3** | Nexus Pilot | ✅ COMPLETE | 9-14 | 33/33 |
| **4** | Guardian & Scale | ✅ COMPLETE | 15-20 | 15/15 |
| **5** | Holographic Ecosystem & Next-Gen Deployments | 🔜 NEXT | 21-26 | 0/18 |

### What Exists in the Codebase

- **`apps/mobile/`** — Full Flutter consumer app with Riverpod, Morphing Viewport, Breathing Wave shader, Guardian Vault, Bootstrap Dialogue, Trust Ladder UI, Adaptive Fidelity
- **`apps/rider/`** — Rider Pulse Flutter app with dispatch, GIS canvas, Bio-Handshake cascade, SOS, shift management, earnings engine
- **`services/orchestrator/`** — Go WebSocket server with circuit breakers, session state, tracing, secure origin validation
- **`services/intent-engine/`** — Python FastAPI with Whisper transcription, RAG pipeline, ambiguity resolver, voice loop, OpenTelemetry tracing
- **`services/nexus-api/`** — Node.js/TypeScript GraphQL API with PostgreSQL, Redis, PoF engine, payment cascade (Paystack→Flutterwave→Wallet→PoD), 10 chaos protocols, OpenTelemetry tracing
- **`ops/`** — Docker Compose for Prometheus, Grafana, Loki, Promtail, Jaeger; Prometheus alerting rules
- **`scripts/`** — Beta seeding script (`seed_beta_events.ts`)

---

## 4. Phase 5: Holographic Ecosystem & Next-Gen Deployments (Weeks 21-26)

This is the current phase. It focuses on Edge AI, ambient computing, fully autonomous AI hub operations, and national rollout.

### Task List (P5-T01 to P5-T18)

| Task | Name | Layer | Description |
|------|------|-------|-------------|
| **P5-T01** | Edge SLM Integrator | Flutter | On-device ONNX/TFLite model integration for zero-latency NLP |
| **P5-T02** | Offline Intent Queue | Flutter | Queueing operations locally during total network collapse |
| **P5-T03** | Hybrid State Sync Engine | Go + Flutter | State reconciliation between Edge and Cloud post-reconnection |
| **P5-T04** | Wearable UI Companion | Flutter | watchOS/WearOS voice-first extension |
| **P5-T05** | Automotive UI | Flutter | Apple CarPlay / Android Auto integration |
| **P5-T06** | Spatial Depletion Horizon | Flutter | AR visualization prototype for predictive pantry |
| **P5-T07** | Dynamic Hub Splitter | Node.js | Splitting single orders across multiple MFC hubs |
| **P5-T08** | Synchronized Dispatch Engine | Node.js | Throttling multi-rider dispatch for simultaneous arrival |
| **P5-T09** | Inter-Hub Transfer Protocol | Node.js | Predictive stock balancing between hubs |
| **P5-T10** | Prometheus AI Monitor | Node.js | Agent continuously parsing observability metrics |
| **P5-T11** | Autonomous Gridlock Resolution | Node.js | AI autonomously triggering Chaos Protocol 5.2 |
| **P5-T12** | Rider AI Copilot | Python + Node.js | Synthesized voice alerts routed to Rider Pulse app |
| **P5-T13** | Autonomous Provisioning Engine | Node.js | Zero-touch Cron-based order generation |
| **P5-T14** | Smart Contract Ledger | Node.js | Automated wallet deduction logic |
| **P5-T15** | Trust Level 4 Gate | All | Strict validation that autonomous operations require Partner status |
| **P5-T16** | Phase 5 Penetration Testing | Go + Flutter | Defending against Edge model extraction and spoofing |
| **P5-T17** | Mesh Network Load Test | Node.js | Simulating 1000+ concurrent multi-node orders |
| **P5-T18** | National Rollout Configuration | All | Removing Wuse II geofence for Lagos/Abuja scaling |

### Success Metrics (Phase 5)

- Offline Intent Resolution Rate > 95%
- Ambient Interface Usage > 15% of total orders
- Agentic Chaos Resolution > 80% (without human intervention)
- Multi-Node Synchronized Arrival Delta < 60 seconds

### Dependency Graph

```
P5-T01 → (standalone)
P5-T02 → P5-T01
P5-T03 → P5-T02
P5-T04 → (standalone)
P5-T05 → (standalone)
P5-T06 → (standalone)
P5-T07 → (standalone)
P5-T08 → P5-T07
P5-T09 → P5-T07
P5-T10 → (standalone)
P5-T11 → P5-T10
P5-T12 → P5-T10
P5-T13 → (standalone)
P5-T14 → P5-T13
P5-T15 → P5-T13
P5-T16 → P5-T01, P5-T03
P5-T17 → P5-T07, P5-T08
P5-T18 → P5-T16, P5-T17
```

---

## 5. Coding Rules

### MANDATORY (from verve-cognitive-load)
1. **No file > 500 lines.** Target 300. Plan splits at 250.
2. **Max 4 files in active context** at any time.
3. **Every directory with 5+ files MUST have a `_MAP.md`.**
4. **Commit to the working branch.** Do NOT create new branches.
5. **Run `tsc` (TypeScript), `go build` (Go), or `flutter analyze` (Dart)** before committing.

### Git Workflow
- **Primary branch:** `main` — all Phase 4 work goes here on a single feature branch.
- **Commit format:** `feat(scope): description` or `fix(scope): description`
- **Push after every task group** — do not batch work across multiple weeks.

### Project-Specific Patterns
- **Node.js Nexus API:** TypeScript strict mode, Apollo Server + Express, PostgreSQL via `pg`, Redis via `redis` package.
- **Go Orchestrator:** Standard library + gorilla/websocket, OpenTelemetry SDK.
- **Python Intent Engine:** FastAPI, `def` (not `async def`) for blocking handlers, OpenTelemetry.
- **Flutter:** Riverpod for state, Impeller rendering, platform channels for native.

---

## 6. Key Design Decisions

1. **Single-Hub Policy:** Orders are NEVER split across hubs in V1.0 (Blueprint §7.1).
2. **Trust Ladder:** 4 levels (Stranger→Acquaintance→Confidant→Partner). Demotion is instant, no guilt messaging (Brand §1.1).
3. **Payment Cascade:** Paystack (4s) → Flutterwave (4s) → Wallet (4s) → PoD. Total 16s max (PRD §4.4).
4. **Bio-Handshake:** 4 degradation levels with automatic escalation (Guardian §5.4).
5. **Aura Persona:** Partner, not servant. Proposes, never interrogates. Max 1 clarifying question per turn (Brand §3).
6. **Purge Protocol:** Complete data deletion in <2s including key destruction and cloud cascade (Guardian §5.1).

---

## 7. Known Tech Debt

| Item | Location | Priority |
|------|----------|----------|
| Earnings engine tiered bonuses | `apps/rider/lib/features/earnings/engine.dart` | Medium — if/else reorder needed for 10km+ |
| GIS ban zones `contains()` | `apps/rider/lib/features/safety/route_enforcement.dart` | Medium — needs real point-in-polygon |
| Native audio FFI | `apps/mobile/lib/core/audio/` | Low — needs compiled native libs for prod |
| build-state.json Phase 3 tasks | `.agents/state/build-state.json` | Low — only tracks Week 9 tasks, Weeks 10-14 not reflected |

---

## 8. Environment & Infrastructure

| Component | Details |
|-----------|---------|
| **Server** | 1GB RAM, 2 vCPU Linux VM |
| **Database** | PostgreSQL (transactional), Redis (cache/sessions) |
| **Observability** | `ops/docker-compose.yml` — runs Prometheus, Grafana, Loki, Jaeger |
| **Mobile** | Flutter → Android APK (primary), iOS secondary |
| **CI/CD** | GitHub Actions (to be configured in Phase 4) |
