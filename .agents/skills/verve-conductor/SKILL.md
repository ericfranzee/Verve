---
name: verve-conductor
description: "Use when orchestrating the full Verve build lifecycle: reading the build manifest, routing tasks to domain builders, enforcing phase gates with success metrics, managing chaos tests, tracking risks, and driving the project from Phase 1 through launch."
category: workflow
risk: safe
source: project
tags: "[orchestration, conductor, lifecycle, phase-gates, multi-agent, build-system, metrics, chaos]"
date_added: "2026-05-10"
date_updated: "2026-05-10"
---

# Verve Conductor — Master Build Orchestrator

## Purpose

The central brain of the Verve agentic build system. Reads build manifest, determines current phase, routes tasks to builders, enforces gates with success metrics, tracks risk mitigations, manages chaos protocol testing, and drives the full project lifecycle.

## When to Use

- Starting a new Verve build session (auto-loads state)
- Determining what to build next
- Routing a task to the correct domain builder
- Running verification gates with success metrics
- Tracking risk register status
- Managing chaos protocol test execution (Phase 3)
- Recovering from failures
- Reporting overall project status

## Core Principles

1. **Never skip verification.** Every completed task goes through `verve-verifier`.
2. **Never skip checkpointing.** Every verified task is saved via `verve-memory`.
3. **Hard gates between phases.** Phase N success metrics must pass before Phase N+1.
4. **User approval at phase boundaries.** Present verification + metrics report and wait.
5. **Fail gracefully.** On error: log, checkpoint, report, offer retry/replan/escalate.
6. **[NEW] Track risks.** Surface HIGH probability risks as build constraints.
7. **[NEW] Validate metrics.** Phase gates require quantitative metric validation.

---

## The Orchestration Loop

```
┌─────────────────────────────────────────────────┐
│                 SESSION START                     │
│  1. Load state (verve-memory)                    │
│  2. Check risk register for critical items       │
│  3. Display status dashboard                     │
│  4. Determine next action                        │
└──────────────────────┬──────────────────────────┘
                       │
              ┌────────▼────────┐
              │ Is there a plan │──No──> Invoke verve-planner
              │ for this phase? │
              └────────┬────────┘
                       │ Yes
              ┌────────▼────────┐
              │ Find next       │
              │ pending task    │
              └────────┬────────┘
                       │
              ┌────────▼────────┐
              │ Route to        │
              │ domain builder  │
              └────────┬────────┘
                       │
              ┌────────▼────────┐
              │ Run verifier    │
              └────────┬────────┘
                       │
              ┌────────▼────────┐
         ┌─No─┤ Verified?       ├─Yes─┐
         │    └─────────────────┘     │
    ┌────▼────┐                 ┌─────▼─────┐
    │ Failure │                 │ Checkpoint │
    │ Protocol│                 │ + metrics  │
    └─────────┘                 └─────┬──────┘
                                      │
                             ┌────────▼────────┐
                             │ All tasks done? │
                             └───┬─────────┬───┘
                              No │      Yes│
                          (loop)─┘   ┌────▼──────┐
                                     │ Phase Gate │
                                     │ + Metrics  │
                                     │ + Chaos?   │
                                     └────┬───────┘
                                          │
                                   ┌──────▼──────┐
                                   │ User        │
                                   │ Approval    │
                                   │ HARD GATE   │
                                   └──────┬──────┘
                                          │
                                   ┌──────▼──────┐
                                   │ Next phase  │
                                   └─────────────┘
```

---

## Session Start Dashboard

```
╔══════════════════════════════════════════════════════════════╗
║  🎯 VERVE CONDUCTOR — Build Orchestrator                    ║
╠══════════════════════════════════════════════════════════════╣
║  Project: Verve Cognitive Commerce Platform                  ║
║  Phase:   1 — Invisible Intelligence (Weeks 1-4)            ║
║  Status:  IN_PROGRESS                                        ║
║  Tasks:   4/21 complete │ 0 failed │ 17 pending             ║
║  Metrics: 0/4 measured                                       ║
║  Risks:   0 critical │ 5 high │ 13 total                    ║
║  Trust:   Level 0 implementing │ Levels 1-3 pending          ║
╠══════════════════════════════════════════════════════════════╣
║  Next Task: P1-T05 — Build CRUD for local embeddings        ║
║  Builder:   verve-edge-builder                               ║
╚══════════════════════════════════════════════════════════════╝
```

## Task Routing

| Layer | Builder Skill |
|-------|--------------|
| Flutter (consumer) | `verve-flutter-builder` |
| Flutter (rider) | `verve-nexus-builder` |
| Go | `verve-backend-builder` |
| Python | `verve-backend-builder` |
| Node.js (Nexus API) | `verve-nexus-builder` |
| Node.js (Pay Router) | `verve-backend-builder` |
| Edge | `verve-edge-builder` |
| Chaos Protocols | `verve-nexus-builder` |
| Observability | `verve-backend-builder` |

## Build Phases Summary (Enhanced)

| Phase | Name | Key Deliverables |
|-------|------|-----------------|
| 1 | Invisible Intelligence | Go WS + circuit breakers, FastAPI + ambiguity resolution, SQLite-VEC + trust enforcement, Voice loop <1.2s, Session recovery |
| 2 | Visual Stage | Impeller UI, Breathing Wave (full+lite), Morphing Viewport, Bootstrap Dialogue, Trust Ladder UI, Verve+ surfaces, Adaptive Fidelity |
| 3 | Nexus Pilot | GraphQL + PoF, Payment Cascade (16s), Bio-Handshake (4 levels), Rider Pulse App (SOS/safety/compensation), 10 Chaos Protocols, Observability (Prometheus/Grafana/Jaeger), 50 beta deliveries |
| 4 | Guardian & Scale | Privacy dashboard + Trust Ladder display, Purge <2s, NDPA audit, Circuit breaker verification, Failure tolerance validation, Chaos simulation CI, Human Bridge, Soft launch |

## Phase Gate (Enhanced)

When all tasks complete, present **metrics + chaos report**:

```
╔══════════════════════════════════════════════════════════════╗
║  ✅ PHASE 3 COMPLETE — Nexus Pilot                          ║
╠══════════════════════════════════════════════════════════════╣
║  MUST PASS:  18/18 ✅                                        ║
║  SUCCESS METRICS:                                            ║
║    Deliveries: 53/50 ✅                                      ║
║    PoF Accuracy: 96.2% > 95% ✅                              ║
║    Payment Cascade: 99.3% > 99% ✅                           ║
║    Bio-Handshake L0: 97.1% > 95% ✅                          ║
║    Order-to-Delivery P80: 13.4min < 15min ✅                 ║
║  CHAOS PROTOCOLS: 10/10 PASSED ✅                            ║
║  RISKS MITIGATED: 3 (T02, O03, O04)                         ║
╠══════════════════════════════════════════════════════════════╣
║  ⏸️  AWAITING USER APPROVAL TO ADVANCE TO PHASE 4           ║
╚══════════════════════════════════════════════════════════════╝
```

## Document References

| Doc | Used For |
|-----|---------|
| PRD | Features, cold start, revenue, ambiguity resolution, **failure tolerances §4.4** |
| Core Blueprint | Architecture, Visual Synapse, **failure mode map §5.3**, **circuit breakers §5.4**, **multi-hub routing §7** |
| System Architecture | Components, data flows, security, **observability §7** |
| Build Strategy | Phases, milestones, **risk register §7**, **success metrics §8** |
| Home Screen Spec | UI states, shader specs |
| Secondary Screens Spec | Guardian, Pantry, History, Payments |
| Brand Manual | Colors, typography, **Trust Ladder §1.1**, **ambiguity resolution §3.2** |
| Guardian Protocol | Privacy, purge, **Trust Ladder technical §5.3**, **degraded handshake §5.4** |
| Nexus Manual | MFC zones, **10 chaos protocols §5**, **rider reality §6** |

## Skill Dependencies

| Skill | Role |
|-------|------|
| `verve-cognitive-load` | **MANDATORY** — File size limits, context budget, structural maps |
| `verve-memory` | Load/save state, metrics, chaos results, risk status |
| `verve-planner` | Generate phase plans with new task structure |
| `verve-flutter-builder` | Consumer Flutter UI tasks |
| `verve-backend-builder` | Go Orchestrator + Python Intent Engine + Payment Router |
| `verve-nexus-builder` | Node.js Nexus API + Rider App + Chaos Protocols |
| `verve-edge-builder` | Edge AI, local DB, Trust Ladder enforcement |
| `verve-verifier` | Verify tasks, phase gates, success metrics, chaos tests |

## Invocation

```
@verve-conductor start    # Begin or resume the build
@verve-conductor status   # Show progress + metrics + risks
@verve-conductor plan     # Generate/regenerate current phase plan
@verve-conductor verify   # Run phase-level acceptance gate
@verve-conductor metrics  # Show success metrics for current phase
@verve-conductor risks    # Show risk register status
@verve-conductor chaos    # Run chaos protocol test suite (Phase 3+)
@verve-conductor history  # Show decision log
```
