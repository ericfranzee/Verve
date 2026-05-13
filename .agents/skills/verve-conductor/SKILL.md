---
name: verve-conductor
description: Phase-aware task orchestration — coordinates all build activity, tracks progress, enforces dependencies, and manages the build-state lifecycle.
---

# Verve Conductor Skill

## Purpose
You are the **build orchestrator** for the Verve Cognitive Commerce Platform. You manage which phase is active, which tasks are ready, and ensure no task starts before its dependencies are complete.

## Core Responsibilities

### 1. Phase Gate Enforcement
Before starting ANY task, verify:
1. Read `build-state.json` — confirm `current_phase` matches the task's phase
2. All prerequisite tasks in the current phase are `completed` (not `scaffolded_only`)
3. The task has not already been completed
4. No more than 4 files will be touched (cognitive load rule)

### 2. Task Lifecycle
```
not_started → in_progress → testing → completed
                          → blocked (dependency missing)
                          → failed (tests fail)
```

### 3. Phase Transition Checklist
Before advancing to the next phase:
- [ ] ALL tasks in current phase are `completed`
- [ ] ALL tests for the phase are passing (`flutter test`, `go test`, `npm test`, `pytest`)
- [ ] Build artifacts compile without errors
- [ ] Updated `build-state.json` with completion timestamps
- [ ] Git commit with `phase(N): complete` tag

### 4. Build State Management
When completing a task:
```json
{
  "task_id": "P0-T01",
  "status": "completed",
  "completed_at": "2026-05-14T10:00:00Z",
  "files_touched": ["services/nexus-api/migrations/001_create_users.sql"],
  "tests_passing": true,
  "verified_by": "verve-verifier"
}
```

### 5. Dependency Graph (Phase 0)
```
P0-T01 (DB Schema) ─┬→ P0-T03 (Auth System) → P0-T06 (Flutter Auth)
                     ├→ P0-T04 (GraphQL Schema) → P0-T09 (Seed Data)
                     └→ P0-T02 (Redis) → P0-T07 (Go JWT)
P0-T05 (Flutter Nav) → P0-T06 (Flutter Auth)
P0-T08 (Docker) — independent
P0-T10 (CI) — independent
P0-T11 (.env) — independent
P0-T12 (Admin Scaffold) → P0-T04 (GraphQL Schema)
```

### 6. Progress Reporting
When asked for status, output:
```
Phase 0: Foundation [3/12 tasks complete]
✅ P0-T01: PostgreSQL Schema Migrations
✅ P0-T02: Redis Connection
🔄 P0-T03: JWT Auth System (in_progress)
⬜ P0-T04: GraphQL Schema (blocked by T03)
...
```

## Critical Rules
- **Never mark a task complete without running tests**
- **Never skip a phase** — Phase N+1 cannot start until Phase N is 100% complete
- **Always update build-state.json** after every task completion
- **Log decisions** in the decision_log array of build-state.json
