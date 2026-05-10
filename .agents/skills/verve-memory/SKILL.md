---
name: verve-memory
description: "Use when you need to persist build state, resume a previous session, record decisions, track success metrics, or checkpoint progress during the Verve agentic build process."
category: workflow
risk: safe
source: project
tags: "[state-management, persistence, checkpointing, session-resume, decision-log, metrics-tracking]"
date_added: "2026-05-10"
date_updated: "2026-05-10"
---

# Verve Memory — State Persistence & Session Resume

## Purpose

Maintain persistent build state across agent sessions so that progress is never lost. This skill is the foundation of the agentic build system — every other Verve skill writes to and reads from the state managed here.

## When to Use

- At the start of any Verve build session (to load current state)
- After completing any task or milestone (to checkpoint)
- When resuming a previously interrupted build session
- When recording an architectural decision or trade-off
- When the conductor needs to determine "where are we?"
- When tracking success metrics for phase gate validation
- When recording chaos protocol test results
- When tracking risk mitigations status

## Core Concepts

### The Build State File

All persistent state lives in `.agents/state/build-state.json`. This file is the single source of truth.

### The Decision Log

Every non-trivial choice (technology selection, design trade-off, scope change) is recorded with rationale. This ensures institutional memory survives session boundaries.

### Success Metrics

Each phase has explicit, measurable success metrics (from Build Strategy §8). The memory tracks measured values against targets so the verifier can gate phase transitions.

### Risk Register

Active risks (from Build Strategy §7) are tracked with current mitigation status so the conductor can surface blockers proactively.

### Checkpointing

After every successful verification gate, the memory skill snapshots the full state. Failed tasks include error context for debugging on resume.

---

## Step-by-Step Guide

### 1. Initialize State (First Run Only)

If `.agents/state/build-state.json` does not exist, create it:

```json
{
  "project": "verve",
  "version": "2.0.0",
  "created_at": "<ISO-8601 timestamp>",
  "last_checkpoint": null,
  "current_phase": 1,
  "current_phase_name": "Invisible Intelligence",
  "phases": {
    "1": {
      "name": "Invisible Intelligence",
      "status": "pending",
      "weeks": "1-4",
      "tasks": [],
      "success_metrics": {
        "voice_to_tts_round_trip_p95_ms": { "target": 1200, "measured": null, "status": "pending" },
        "rag_recall_accuracy_pct": { "target": 90, "measured": null, "status": "pending" },
        "sqlite_vec_query_latency_ms": { "target": 50, "measured": null, "status": "pending" },
        "whisper_accuracy_nigerian_english_pct": { "target": 90, "measured": null, "status": "pending" }
      }
    },
    "2": {
      "name": "Visual Stage",
      "status": "pending",
      "weeks": "5-8",
      "tasks": [],
      "success_metrics": {
        "ui_frame_rate_fps": { "target": 60, "measured": null, "status": "pending" },
        "cold_start_to_idle_wave_ms": { "target": 1500, "measured": null, "status": "pending" },
        "battery_per_5min_session_pct": { "target": 2, "measured": null, "status": "pending" },
        "visual_synapse_sync_accuracy_ms": { "target": 50, "measured": null, "status": "pending" },
        "adaptive_fidelity_trigger_correct": { "target": true, "measured": null, "status": "pending" }
      }
    },
    "3": {
      "name": "Nexus Pilot",
      "status": "pending",
      "weeks": "9-14",
      "tasks": [],
      "success_metrics": {
        "closed_beta_deliveries": { "target": 50, "measured": null, "status": "pending" },
        "pof_accuracy_pct": { "target": 95, "measured": null, "status": "pending" },
        "payment_cascade_success_pct": { "target": 99, "measured": null, "status": "pending" },
        "bio_handshake_success_pct": { "target": 95, "measured": null, "status": "pending" },
        "order_to_delivery_p80_min": { "target": 15, "measured": null, "status": "pending" }
      },
      "chaos_protocol_tests": {
        "spoilage_swap": { "tested": false, "result": null },
        "gridlock_reroute": { "tested": false, "result": null },
        "power_grid_failure": { "tested": false, "result": null },
        "rider_device_failure": { "tested": false, "result": null },
        "user_not_home": { "tested": false, "result": null },
        "fleet_immobilization": { "tested": false, "result": null },
        "hub_flooding": { "tested": false, "result": null },
        "coordinated_fraud": { "tested": false, "result": null },
        "picker_walkout": { "tested": false, "result": null },
        "holiday_surge": { "tested": false, "result": null }
      }
    },
    "4": {
      "name": "Guardian & Scale",
      "status": "pending",
      "weeks": "15-20",
      "tasks": [],
      "success_metrics": {
        "nps_score": { "target": 70, "measured": null, "status": "pending" },
        "dau_retention_30d_pct": { "target": 40, "measured": null, "status": "pending" },
        "ndpa_violations": { "target": 0, "measured": null, "status": "pending" },
        "trust_ladder_level2_30d_pct": { "target": 60, "measured": null, "status": "pending" },
        "human_bridge_escalation_pct": { "target": 5, "measured": null, "status": "pending" },
        "purge_protocol_success_pct": { "target": 100, "measured": null, "status": "pending" }
      }
    }
  },
  "trust_ladder_implementation": {
    "level_0_stranger": { "status": "pending", "features": ["anonymous_browsing", "hub_popularity_only"] },
    "level_1_acquaintance": { "status": "pending", "features": ["purchase_history_access", "basic_preferences"] },
    "level_2_confidant": { "status": "pending", "features": ["dietary_profile", "depletion_modeling", "household_size"] },
    "level_3_partner": { "status": "pending", "features": ["voice_patterns", "address_book", "payment_cascade", "auto_provisioning"] }
  },
  "risk_register": {
    "technical": [
      { "id": "RISK-T01", "name": "LLM latency > 1.2s", "probability": "high", "status": "open", "mitigation": "MoE routing" },
      { "id": "RISK-T02", "name": "Whisper Pidgin accuracy < 85%", "probability": "medium", "status": "open", "mitigation": "Pre-fine-tune 50h corpus" },
      { "id": "RISK-T03", "name": "Impeller Samsung stability", "probability": "medium", "status": "open", "mitigation": "Canvas fallback renderer" },
      { "id": "RISK-T04", "name": "SQLite-VEC > 10k vectors", "probability": "low", "status": "open", "mitigation": "90-day decay pruning" },
      { "id": "RISK-T05", "name": "Mali GPU shader jank", "probability": "medium", "status": "open", "mitigation": "Dual shader variants" }
    ],
    "operational": [
      { "id": "RISK-O01", "name": "Hub lease overbudget", "probability": "high", "status": "open", "mitigation": "3 backup locations" },
      { "id": "RISK-O02", "name": "Rider recruitment insufficient", "probability": "medium", "status": "open", "mitigation": "Gokada/MAX.ng backup" },
      { "id": "RISK-O03", "name": "NEPA uptime < 95%", "probability": "high", "status": "open", "mitigation": "Dual generator + IoT" },
      { "id": "RISK-O04", "name": "Picker quality inconsistency", "probability": "medium", "status": "open", "mitigation": "Gamified quality scoring" }
    ],
    "market": [
      { "id": "RISK-M01", "name": "Competitor launch", "probability": "medium", "status": "open", "mitigation": "Edge-AI moat" },
      { "id": "RISK-M02", "name": "NDPA regulatory change", "probability": "low", "status": "open", "mitigation": "GDPR-level compliance" },
      { "id": "RISK-M03", "name": "Voice-AI trust deficit", "probability": "medium", "status": "open", "mitigation": "Text-first fallback" }
    ]
  },
  "decision_log": [],
  "artifacts": [],
  "errors": []
}
```

### 2. Load State (Every Session Start)

1. Read `.agents/state/build-state.json`.
2. Parse `current_phase` and scan the tasks array for the first `pending` or `failed` task.
3. Check risk register for any `critical` status risks.
4. Report a status summary:

```
╔══════════════════════════════════════════════════════════╗
║  VERVE BUILD STATE                                       ║
╠══════════════════════════════════════════════════════════╣
║  Phase: 1 — Invisible Intelligence                       ║
║  Status: IN_PROGRESS                                     ║
║  Tasks: 4/16 complete │ 1 failed │ 11 pending           ║
║  Metrics: 0/4 measured                                   ║
║  Risks: 0 critical │ 5 high │ 8 open                    ║
║  Trust Ladder: Level 0 implemented │ Levels 1-3 pending  ║
║  Last Checkpoint: 2026-05-10T04:30:00Z                   ║
╚══════════════════════════════════════════════════════════╝
```

### 3. Checkpoint (After Task Completion)

When a task is verified as complete:

1. Update the task entry:
   ```json
   {
     "id": "P1-T03",
     "name": "Build RAG prompt pipeline with Trust Ladder context injection",
     "status": "complete",
     "completed_at": "<timestamp>",
     "artifacts": ["services/intent-engine/rag/prompt_builder.py"],
     "verified_by": "verve-verifier",
     "notes": "Trust Ladder level determines context depth in RAG prompt"
   }
   ```
2. Update `last_checkpoint` timestamp.
3. Check if task completion changes trust_ladder_implementation status.
4. Write the file back to disk.

### 4. Record Failure (When Task Fails Verification)

```json
{
  "id": "P3-T18",
  "name": "Implement Coordinated Fraud Protocol",
  "status": "failed",
  "failed_at": "<timestamp>",
  "error": {
    "type": "verification_failure",
    "detail": "Velocity model false positive rate too high (12% vs. target <5%)",
    "verifier_report": ".agents/reports/verify-P3-T18.md"
  },
  "retry_count": 1
}
```

### 5. Record Success Metric Measurement

When the verifier measures a phase metric:

```json
{
  "metric_id": "voice_to_tts_round_trip_p95_ms",
  "phase": 1,
  "target": 1200,
  "measured": 980,
  "measured_at": "<timestamp>",
  "method": "End-to-end trace timing in staging",
  "status": "pass"
}
```

### 6. Record Chaos Protocol Test Result

```json
{
  "protocol": "rider_device_failure",
  "tested_at": "<timestamp>",
  "test_type": "simulated",
  "scenario": "Rider BLE disabled mid-delivery, phone at 5% battery",
  "result": "pass",
  "fallback_used": "Level 1 (Visual Only)",
  "resolution_time_ms": 4200,
  "notes": "Visual color pulse recognized on first attempt"
}
```

### 7. Record Decision

Append to the `decision_log` array:

```json
{
  "id": "DEC-007",
  "timestamp": "<ISO-8601>",
  "phase": 1,
  "topic": "State Management Choice",
  "decision": "Use Riverpod over BLoC for Flutter state management",
  "alternatives": ["BLoC", "Provider", "GetX"],
  "rationale": "Riverpod handles complex async streams from WebSocket better. PRD requires Orchestrator WebSocket → UI-Metadata → Morphing Viewport pipeline. Riverpod's AsyncNotifier pattern maps cleanly.",
  "risk": "Team must learn Riverpod if unfamiliar",
  "related_risk_id": null
}
```

### 8. Track Artifacts

Every file created or modified by a builder skill is registered:

```json
{
  "path": "services/orchestrator/internal/circuit/breaker.go",
  "created_by": "verve-backend-builder",
  "task_id": "P1-T14",
  "phase": 1,
  "type": "source"
}
```

### 9. Update Risk Status

When a mitigation is implemented or a risk materializes:

```json
{
  "risk_id": "RISK-T02",
  "previous_status": "open",
  "new_status": "mitigated",
  "updated_at": "<timestamp>",
  "evidence": "Whisper fine-tuned on 52h corpus. Test accuracy: 91.3%"
}
```

---

## State Queries

The conductor and other skills may query memory for:

| Query | How |
|-------|-----|
| "What phase are we in?" | Read `current_phase` |
| "What's the next task?" | Find first `pending` task in current phase |
| "Did we already build X?" | Search `artifacts` array by path |
| "Why did we choose Y?" | Search `decision_log` by topic |
| "What failed last time?" | Filter tasks by `status: "failed"` |
| "How many tasks left?" | Count `pending` tasks in current phase |
| "Are phase metrics passing?" | Read `success_metrics` for current phase |
| "What's the Trust Ladder status?" | Read `trust_ladder_implementation` |
| "Any critical risks?" | Filter `risk_register` by status |
| "Which chaos protocols passed?" | Read `chaos_protocol_tests` in Phase 3 |

---

## Phase Transition Protocol

When all tasks in a phase are `complete`:

1. Set phase status to `"complete"`.
2. Verify ALL `success_metrics` for the phase have `status: "pass"`.
3. If Phase 3: verify ALL `chaos_protocol_tests` have `tested: true` and `result: "pass"`.
4. Increment `current_phase`.
5. Set next phase status to `"in_progress"`.
6. Write a phase-completion entry to the decision log.
7. **HARD GATE:** Do NOT advance until `verve-verifier` has run the phase-level acceptance check and the user has approved the transition.

---

## Recovery Protocol

If a session starts and finds tasks in `failed` state:

1. Report the failures with full error context.
2. Check if any risks have escalated to `critical`.
3. Ask the conductor: retry the failed task, skip it, or re-plan.
4. If retrying, increment `retry_count`. If `retry_count > 3`, escalate to the user.

## File Locations

| File | Purpose |
|------|---------|
| `.agents/state/build-state.json` | Primary state file |
| `.agents/plans/phase-N-plan.md` | Phase plans (written by verve-planner) |
| `.agents/reports/verify-*.md` | Verification reports (written by verve-verifier) |
| `.agents/manifest.json` | Project manifest and skill registry |
