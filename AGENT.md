# AGENT.md — Verve Cognitive Commerce Platform

**Version:** 3.0.0 (Post-Audit Rebuild)  
**Last Updated:** 2026-05-13  
**Status:** REBUILD IN PROGRESS — Phase 0

---

## Project Map

```
Verve/
├── .agents/                    # Agentic development system
│   ├── manifest.json           # Skill registry + phase definitions
│   ├── state/build-state.json  # Verified build state (reset v3.0.0)
│   └── skills/                 # 9 feature-building skills
├── apps/
│   ├── mobile/                 # Flutter Consumer App (Dart)
│   ├── rider/                  # Flutter Rider App (Dart)
│   └── admin/                  # React Admin Panel (NEW — Phase 0)
├── services/
│   ├── orchestrator/           # Go WebSocket Gateway (:8080)
│   ├── intent-engine/          # Python FastAPI AI Engine (:8000)
│   └── nexus-api/              # Node.js GraphQL Fulfillment (:4000)
├── ops/                        # Docker, Prometheus, Grafana
├── docs/                       # Engineering-ready specifications (16 docs)
└── tests/                      # E2E test suites
```

## Architecture (5 Layers)

| Layer | Technology | Port | Status |
|-------|-----------|------|--------|
| **Consumer App** | Flutter 3.22 / Dart / Impeller | — | Scaffold only |
| **Rider App** | Flutter 3.22 / Dart | — | Scaffold only |
| **Admin Panel** | React / Vite / TanStack | :3001 | Not started |
| **Orchestrator** | Go 1.22 / gorilla/websocket | :8080 | Skeleton |
| **Intent Engine** | Python 3.11 / FastAPI | :8000 | Mock stubs |
| **Nexus API** | Node.js 20 / Apollo GraphQL | :4000 | Skeleton |
| **PostgreSQL** | v16 | :5432 | Not connected |
| **Redis** | v7 | :6379 | Not connected |

## Rebuild Phases (6 Phases)

### Phase 0: Foundation & Infrastructure (Weeks 1-4) — CURRENT
> The missing basement. Build real database, auth, navigation, and environment.

**Tasks:**
- P0-T01: PostgreSQL schema migration scripts (from `Verve Database Schema.md`)
- P0-T02: Redis connection + session management
- P0-T03: JWT auth system (register/login/refresh) in Nexus API
- P0-T04: GraphQL schema implementation (types, queries, mutations)
- P0-T05: Flutter navigation shell (GoRouter + bottom nav)
- P0-T06: Flutter auth flow (login/register screens)
- P0-T07: Go Orchestrator JWT validation + Redis session store
- P0-T08: Docker Compose for full local stack
- P0-T09: Seed data script (test products, hubs, users)
- P0-T10: CI pipeline (GitHub Actions)
- P0-T11: .env configuration for all services
- P0-T12: Admin Panel scaffolding (Vite + React + GraphQL client)

### Phase 1: Invisible Intelligence REDO (Weeks 5-8)
> Replace mocks with real AI. Voice capture, Whisper, LLM, RAG.

### Phase 2: Visual Stage REDO (Weeks 9-12)
> Wire the shader, build real Synapse listener, functional viewport transitions.

### Phase 3: Nexus Pilot REDO (Weeks 13-18)
> Real orders, real payments, real riders, real inventory. The commerce engine.

### Phase 4: Guardian & Scale REDO (Weeks 19-22)
> Real encryption, real purge, admin panel completion, NDPA compliance.

### Phase 5: Holographic Ecosystem (Weeks 23-26)
> Edge AI, wearables, multi-hub mesh, autonomous provisioning.

## Coding Rules

1. **300-Line Rule:** No file exceeds 300 lines. Split into focused modules.
2. **4-File Context Budget:** No task touches more than 4 files at once.
3. **No Stubs:** Every new file must contain real, tested, functional code. Stub era is over.
4. **Test First:** Every feature needs at least unit tests before marking complete.
5. **`_stub` Files:** Existing `_stub` files are reference blueprints — read them for intent, then build real implementations alongside them.
6. **Commit Format:** `feat(scope): description` | `fix(scope):` | `test(scope):`

## Documentation Index (16 Documents)

| # | Document | Purpose |
|---|----------|---------|
| 1 | Product Requirements Document | User stories, cold start, revenue, constraints |
| 2 | Core Blueprint | Visual synapse, memory architecture, failure modes |
| 3 | System Architecture | Technology stack, service topology, observability |
| 4 | Build Strategy & Roadmap | Phase logic, risk register, success metrics |
| 5 | Home Screen Specification | Morphing viewport, sentinel zone, shader states |
| 6 | Secondary Screens Specification | Guardian vault, pantry, history, human bridge |
| 7 | Brand & Persona Manual | Aura personality, trust ladder, color system |
| 8 | Guardian Protocol | Data privacy, encryption, purge, NDPA |
| 9 | Nexus Operations Manual | Hub topology, 15-min loop, 10 chaos protocols |
| 10 | Research & Analysis | Market analysis, competitive landscape |
| 11 | Phase 5 Architecture | Edge AI, ambient, mesh routing, zero-touch |
| 12 | Risk Register | Operational + security risk catalog |
| 13 | **Database Schema** ★ NEW | PostgreSQL + Redis schema, indexes, migrations |
| 14 | **API Contracts** ★ NEW | WebSocket, REST, GraphQL schemas + auth flow |
| 15 | **Environment & Deployment Guide** ★ NEW | Setup, Docker, CI/CD, testing |
| 16 | **Admin Panel Specification** ★ NEW | All admin screens, roles, white-label config |
| 17 | **Testing Strategy** ★ NEW | Test pyramid, critical scenarios, benchmarks |

## Skill Registry

| Skill | Purpose |
|-------|---------|
| `verve-conductor` | Phase-aware task orchestration and build coordination |
| `verve-planner` | Implementation planning with dependency graphs |
| `verve-backend-builder` | Go + Python + Node.js real service implementation |
| `verve-flutter-builder` | Flutter consumer + rider app feature building |
| `verve-nexus-builder` | GraphQL schema, resolvers, inventory, payments, chaos |
| `verve-edge-builder` | Edge AI, SQLite-VEC, offline queue, sync |
| `verve-memory` | Context management, conversation logs, knowledge items |
| `verve-verifier` | Test execution, build verification, lint enforcement |
| `verve-cognitive-load` | 300-line rule, file structure, naming conventions |
