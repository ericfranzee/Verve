---
name: verve-verifier
description: "Use when verifying completed tasks against acceptance criteria, running phase gates with success metrics, testing chaos protocols, validating failure tolerance thresholds, and auditing security compliance."
category: testing
risk: safe
source: project
tags: "[verification, acceptance-testing, quality-gates, chaos-testing, failure-tolerance, compliance, metrics]"
date_added: "2026-05-10"
date_updated: "2026-05-10"
---

# Verve Verifier — Build Verification & Acceptance Gates

## Purpose

Enforce quality at every stage. No task is "done" until verified. No phase transition without acceptance gate + success metrics passing. This skill now includes chaos protocol simulation testing, failure tolerance threshold validation, and Trust Ladder progression verification.

## Verification Levels

| Level | Scope | Triggered By |
|-------|-------|-------------|
| **Task** | Single task output | Builder reports completion |
| **Integration** | Cross-layer communication | Multiple related tasks complete |
| **Phase** | All tasks + success metrics | All phase tasks verified |
| **Chaos** | Simulated failure protocols | Phase 3 gate |
| **Compliance** | Security, NDPA, Trust Ladder | Phase 4 gate or on-demand |
| **Cognitive** | File size, structural maps, context budget | Every task |

## Acceptance Criteria Sources

| Source | Criteria Type |
|--------|-------------|
| PRD §3-4 | Features, edge cases, performance, **failure tolerances (§4.4)** |
| Blueprint §3 | Visual Synapse timing (50ms) |
| Blueprint §5.3-5.4 | **Failure mode map, circuit breakers** |
| Blueprint §7 | **Multi-hub routing policy** |
| Architecture §7 | **Observability pipeline** |
| Brand Manual §3.2 | **Ambiguity Resolution, One-Question Rule** |
| Guardian §5.3-5.4 | **Trust Ladder technical, degraded handshake** |
| Nexus §5-6 | **10 chaos protocols, rider safety** |
| Build Strategy §8 | **23 success metrics across 4 phases** |
| Cognitive Load Skill | **File ≤ 500 lines, _MAP.md exists, context budget ≤ 4 files** |

---

## Task-Level Verification

Same as before: artifact existence, acceptance criteria, edge case coverage.

## Integration-Level Verification (Enhanced)

### Flutter ↔ Go Orchestrator
- WebSocket connection + **session recovery after disconnect**
- PCM audio + **Whisper confidence threshold handling**
- **Circuit breaker fallback (cached suggestion when Intent Engine breaker open)**

### Go Orchestrator ↔ Python Intent Engine
- Audio routing + transcription
- **Trust Ladder context gating (Level N user → only level ≤ N context)**
- **Ambiguity Resolution (vague intent → confident proposal, not question)**
- **Emotional State detection → appropriate Aura verbosity**

### Python Intent Engine ↔ Node.js Nexus API
- PoF queries + dietary constraints
- **Single-hub policy enforcement (no split orders)**
- **Redis desync detection and recovery**

### Bio-Handshake Cascade
- **Level 0: BLE + visual (< 5s)**
- **Level 1: Visual only (< 10s)**
- **Level 2: OTP 6-digit, 30s expiry**
- **Level 3: Hub callback (manual trigger)**
- **Auto-escalation between levels**

---

## Phase-Level Acceptance Gates (Enhanced with Success Metrics)

### Phase 1 Gate: Invisible Intelligence

**MUST PASS:**
- [ ] Go Orchestrator handles WebSocket connections under load
- [ ] Python Intent Engine extracts intents from transcribed text
- [ ] SQLite-VEC stores/retrieves embeddings correctly
- [ ] Temporal references resolve to correct SKUs
- [ ] Full voice loop round-trip < 1.2 seconds (P95)
- [ ] SQLCipher encryption active
- [ ] Allergen interception working
- [ ] **Trust Ladder Level 0 data enforcement working**
- [ ] **Ambiguity Resolution: vague intent → proposal (not question)**
- [ ] **Circuit breaker skeleton functional (breaker opens/closes correctly)**
- [ ] **Session recovery from Redis snapshot after simulated crash**

**SUCCESS METRICS (Build Strategy §8):**
- [ ] Voice-to-TTS P95 < 1,200ms — Measured: ___ms
- [ ] RAG recall accuracy > 90% — Measured: ___%
- [ ] SQLite-VEC query < 50ms — Measured: ___ms
- [ ] Whisper Nigerian English > 90% — Measured: ___%

---

### Phase 2 Gate: Visual Stage

**MUST PASS:**
- [ ] Morphing Viewport 60fps minimum
- [ ] UI transitions within 50ms of TTS word
- [ ] Breathing Wave shader jank-free (both full + lite variants)
- [ ] Adaptive Fidelity triggers at >400ms ping
- [ ] SVG fallback loads without spinner
- [ ] Cold start < 1.5 seconds
- [ ] Haptic feedback fires correctly
- [ ] Brand colors match spec
- [ ] **Bootstrap Dialogue completes 90-second calibration successfully**
- [ ] **Trust Ladder display shows correct level and data breakdown**
- [ ] **Emotional State feedback changes Aura UI mode**
- [ ] **Verve+ nudge surfaces after 4+ simulated orders**
- [ ] **Connection-degraded states display correctly (Amber pulse, dim mode)**

**SUCCESS METRICS:**
- [ ] UI frame rate > 60fps — Measured: ___fps
- [ ] Cold start < 1,500ms — Measured: ___ms
- [ ] Battery < 2% per 5min — Measured: ___%
- [ ] Synapse sync < 50ms — Measured: ___ms
- [ ] Adaptive Fidelity triggers correctly — Verified: ___

---

### Phase 3 Gate: Nexus Pilot

**MUST PASS:**
- [ ] GraphQL inventory queries return PoF scores
- [ ] Inventory sync < 2 seconds
- [ ] Payment Cascade fallback works (all 4 levels including Pay-on-Delivery)
- [ ] Bio-Handshake Level 0 BLE exchange succeeds
- [ ] GIS Canvas renders rider position
- [ ] Frosted Receipt displays correct breakdown
- [ ] **Single-hub policy rejects split orders with user-friendly message**
- [ ] **Degraded Handshake: all 4 levels tested with auto-escalation**
- [ ] **Rider SOS protocol broadcasts GPS and freezes delivery**
- [ ] **Rider shift manager enforces 8h max and mandatory break**
- [ ] **Route safety rejects banned bridge crossings**
- [ ] **Observability pipeline: traces visible in Jaeger, metrics in Grafana**

**CHAOS PROTOCOL TESTS (simulated):**
- [ ] 5.1 Spoilage Swap: substitute generated + user notified
- [ ] 5.2 Gridlock: re-route triggered + ETA updated
- [ ] 5.3 Power Failure: PoF drops to 0 for cold-chain items
- [ ] 5.4 Rider Device Failure: degraded handshake + backup rider
- [ ] 5.5 User Not Home: cold-hold return + 2h hold
- [ ] 5.6 Fleet Immobilization: ETAs extended + Verve+ priority
- [ ] 5.7 Hub Flooding: zone lockout from PoF engine
- [ ] 5.8 Coordinated Fraud: velocity detection + verification hold
- [ ] 5.9 Picker Walkout: ticket redistribution
- [ ] 5.10 Holiday Surge: pre-staging triggered 48h ahead

**SUCCESS METRICS:**
- [ ] 50+ closed-beta deliveries — Count: ___
- [ ] PoF accuracy > 95% — Measured: ___%
- [ ] Payment cascade > 99% — Measured: ___%
- [ ] Bio-Handshake Level 0 > 95% — Measured: ___%
- [ ] Order-to-delivery < 15min P80 — Measured: ___min

---

### Phase 4 Gate: Guardian & Scale

**MUST PASS:**
- [ ] Purge Protocol < 2 seconds (key destruction + cloud webhook)
- [ ] Guardian Vault displays all memory vectors
- [ ] Individual memory deletion works
- [ ] No raw audio on any server (audit)
- [ ] TLS 1.3 on all channels (audit)
- [ ] PII stripped before cloud LLM (audit)
- [ ] BVN hashed locally, never transmitted raw
- [ ] Data localized to Nigerian territory
- [ ] **Trust Ladder: users can see and adjust their level**
- [ ] **Trust Ladder: demotion is instant and silent**
- [ ] **Circuit breakers verified under sustained failure conditions**
- [ ] **All 7 failure tolerance thresholds within acceptable range (PRD §4.4)**

**FAILURE TOLERANCE THRESHOLDS (PRD §4.4):**
- [ ] LLM Hallucination Rate < 0.1%
- [ ] Inventory Desync < 120 seconds
- [ ] Payment Cascade Total < 16 seconds
- [ ] Voice-to-Intent < 1,500ms
- [ ] Bio-Handshake < 10 seconds
- [ ] Purge Protocol < 2 seconds
- [ ] Rider ETA Accuracy ±5 minutes

**SUCCESS METRICS:**
- [ ] NPS > 70 — Measured: ___
- [ ] DAU 30-day retention > 40% — Measured: ___%
- [ ] NDPA violations: 0 — Count: ___
- [ ] Trust Ladder Level 2 within 30 days > 60% — Measured: ___%
- [ ] Human Bridge escalation < 5% — Measured: ___%
- [ ] Purge 100% within 2s — Measured: ___%

---

## Verification Report Format

```markdown
# Verification Report: [TASK-ID]
**Task:** [Name] | **Builder:** [Skill] | **Verified At:** [Timestamp]
**Result:** PASS | FAIL | PARTIAL

## Checks
| # | Criterion | Status | Notes |
|---|-----------|--------|-------|

## Success Metrics (if phase gate)
| Metric | Target | Measured | Status |

## Chaos Tests (if Phase 3 gate)
| Protocol | Tested | Result | Notes |

## Recommendation
PROCEED | RETRY | ESCALATE
```

## Failure Handling

1. Write failure report to `.agents/reports/`
2. Update task status via `verve-memory`
3. Notify conductor: RETRY (fixable) | REPLAN (structural) | ESCALATE (systemic, retry > 3)
4. **Never silently skip a failing check. Never mark a phase complete if any MUST PASS fails or any SUCCESS METRIC misses target.**
