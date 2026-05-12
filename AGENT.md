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
| **4** | Guardian & Scale | 🔜 NEXT | 15-20 | 0/15 |

### What Exists in the Codebase

- **`apps/mobile/`** — Full Flutter consumer app with Riverpod, Morphing Viewport, Breathing Wave shader, Guardian Vault, Bootstrap Dialogue, Trust Ladder UI, Adaptive Fidelity
- **`apps/rider/`** — Rider Pulse Flutter app with dispatch, GIS canvas, Bio-Handshake cascade, SOS, shift management, earnings engine
- **`services/orchestrator/`** — Go WebSocket server with circuit breakers, session state, tracing, secure origin validation
- **`services/intent-engine/`** — Python FastAPI with Whisper transcription, RAG pipeline, ambiguity resolver, voice loop, OpenTelemetry tracing
- **`services/nexus-api/`** — Node.js/TypeScript GraphQL API with PostgreSQL, Redis, PoF engine, payment cascade (Paystack→Flutterwave→Wallet→PoD), 10 chaos protocols, OpenTelemetry tracing
- **`ops/`** — Docker Compose for Prometheus, Grafana, Loki, Promtail, Jaeger; Prometheus alerting rules
- **`scripts/`** — Beta seeding script (`seed_beta_events.ts`)

---

## 4. Phase 4: Guardian & Scale (Weeks 15-20)

This is the current phase. It focuses on privacy, security hardening, compliance, and launch preparation.

### Task List (P4-T01 to P4-T15)

| Task | Name | Layer | Description |
|------|------|-------|-------------|
| **P4-T01** | Guardian Vault Screen | Flutter | Ledger, Purge, KYC, Trust Ladder display — full screen implementation |
| **P4-T02** | Predictive Pantry Screen | Flutter | Depletion Horizon, Train-the-AI, cold start fallback |
| **P4-T03** | Semantic History Screen | Flutter | Event timeline, Re-Provision CTA |
| **P4-T04** | Payment Cascade Manager Screen | Flutter | Drag-drop reordering, wallet top-up, Verve+ card |
| **P4-T05** | Human Bridge Escalation Overlay | Flutter | Nexus Lead concierge, hybrid text/push-to-talk |
| **P4-T06** | Purge Protocol | Flutter + Go + Python | Full data purge <2s (key destruction + cloud cascade) |
| **P4-T07** | Nexus Lead Dashboard | Node.js (Web App) | Operations dashboard for hub leads |
| **P4-T08** | Penetration Testing | Go | Security audit of the Go Orchestrator |
| **P4-T09** | NDPA Compliance Audit | All | Nigeria Data Protection Act compliance + Trust Ladder alignment |
| **P4-T10** | Geo-fenced Soft Launch | All | Feature flags, staged rollout infrastructure |
| **P4-T11** | Circuit Breaker Verification | Go | Verify all 3 breakers under simulated failure |
| **P4-T12** | Failure Tolerance Monitoring | All | Validate 7 PRD §4.4 failure metrics |
| **P4-T13** | Chaos Protocol CI | Node.js | Automated CI tests for all 10 chaos protocols |
| **P4-T14** | Degraded Handshake Verification | Flutter + Node.js | Field test all 4 Bio-Handshake levels |
| **P4-T15** | Risk Register Review | All | Mitigate/close all HIGH probability risks |

### Success Metrics (Build Strategy §8)

- NPS > 70
- DAU retention at 30 days > 40%
- NDPA violations: 0
- Trust Ladder: >60% users reach Level 2 within 30 days
- Human Bridge escalation < 5%
- Purge Protocol: 100% within 2 seconds

### Dependency Graph

```
P4-T01 → (standalone, uses existing Guardian Vault scaffolding)
P4-T02 → (standalone, uses existing Pantry scaffolding)
P4-T03 → (standalone)
P4-T04 → (standalone, uses existing payment cascade)
P4-T05 → (standalone)
P4-T06 → P4-T01 (Purge button lives in Guardian Vault)
P4-T07 → (standalone, new web app)
P4-T08 → (requires P4-T06 for purge endpoint testing)
P4-T09 → P4-T06, P4-T08
P4-T10 → P4-T07, P4-T09
P4-T11 → (standalone, tests existing circuit breakers)
P4-T12 → (standalone, reads from observability pipeline)
P4-T13 → (standalone, tests existing chaos protocols)
P4-T14 → (standalone, tests existing handshake cascade)
P4-T15 → P4-T08, P4-T09, P4-T11, P4-T12, P4-T13, P4-T14
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
