---
name: verve-backend-builder
description: "Use when building the Go Orchestrator (WebSocket, circuit breakers, session recovery) and Python Intent Engine (FastAPI, RAG, Whisper, Ambiguity Resolution, Trust Ladder context, Observability) for Verve."
category: development
risk: safe
source: project
tags: "[golang, python, fastapi, websocket, circuit-breaker, observability, opentelemetry, rag]"
date_added: "2026-05-10"
date_updated: "2026-05-10"
---

# Verve Backend Builder — Orchestrator & Intelligence

## Purpose

Build the Go Orchestrator (middleware) and Python Intent Engine (AI brain). This skill covers session management, circuit breakers, crash recovery, PII stripping, Whisper transcription, RAG pipeline, Ambiguity Resolution, Trust Ladder context injection, Observability, and the Payment Cascade Router.

**Note:** The Node.js Nexus API and Rider systems have moved to `verve-nexus-builder`.

## When to Use

- Building the Go WebSocket Orchestrator
- Implementing circuit breaker patterns and crash recovery (Blueprint §5.3-5.4)
- Building the Python FastAPI Intent Engine (Whisper, RAG, LLM)
- Implementing Ambiguity Resolution engine (Brand Manual §3.2)
- Implementing Trust Ladder context injection in RAG prompts (Guardian §5.3)
- Setting up Observability pipeline (Architecture §7)
- Building the Payment Cascade Router microservice

## Architecture

```
[ Flutter Client ] <== WebSocket ==> [ Go Orchestrator ]
                                           |         |
                                    (circuit breakers) (Redis snapshots)
                                           v         v
                           [ Python Intent Engine ]   [ Payment Router ]
                                     |
                              (Trust Ladder context gating)
                              (Ambiguity Resolution)
                                     |
                              [ Nexus API (verve-nexus-builder) ]
```

---

## Component 1: Go Orchestrator

**Language:** Go — max concurrency, low memory

### Project Structure

```
services/orchestrator/
├── cmd/server/main.go
├── internal/
│   ├── websocket/
│   │   ├── handler.go          # WS upgrade, read/write loops
│   │   ├── session.go          # Session state machine
│   │   └── recovery.go         # Reconnect → Redis restore (Blueprint §5.3)
│   ├── audio/
│   │   ├── router.go           # Route PCM to transcription
│   │   └── confidence.go       # Whisper confidence < 60% → retry (Blueprint §5.3)
│   ├── synapse/
│   │   ├── payload.go          # Synapse Payload struct
│   │   └── builder.go          # Assemble TTS + UI-Metadata
│   ├── privacy/
│   │   └── pii_stripper.go     # Remove names, GPS before LLM
│   ├── circuit/
│   │   └── breaker.go          # Per-service breaker: 5 failures/60s → 30s open (Blueprint §5.4)
│   ├── observability/
│   │   ├── tracing.go          # OpenTelemetry OTLP + Jaeger (Architecture §7.3)
│   │   ├── metrics.go          # Prometheus export (Architecture §7.1)
│   │   └── health.go           # Component health checks
│   ├── middleware/
│   │   ├── tls.go              # TLS 1.3 enforcement
│   │   └── bandwidth.go        # low_bandwidth_flag
│   └── state/
│       └── redis_snapshot.go   # Session state persistence every 5s
├── go.mod
└── go.sum
```

### Key Patterns

**Circuit Breaker (Blueprint §5.4):** Each downstream service has an independent breaker (5-failure threshold / 60s window). When Intent Engine breaker is open, don't call Nexus (cascade prevention). Client gets cached suggestion fallback.

**Session Recovery (Blueprint §5.3):** Session state snapshotted to Redis every 5s. On WebSocket drop, client reconnects with `session_id`, Orchestrator restores from Redis. User hears: *"Sorry, brief hiccup. Where were we?"*

**Whisper Confidence (Blueprint §5.3):** If confidence < 60%, Aura asks for repeat naturally. After 2 failures, switch to text input. Keyboard icon pulses.

**Session States:** `IDLE → BROWSING → CHECKOUT → TRACKING → DELIVERED`. Any state can escalate to `HUMAN_BRIDGE`. Any disconnect triggers Redis snapshot + exponential backoff reconnect.

---

## Component 2: Python Intent Engine

**Framework:** Python + FastAPI

### Project Structure

```
services/intent-engine/
├── main.py
├── api/
│   ├── transcribe.py           # POST /transcribe
│   ├── intent.py               # POST /intent
│   └── synapse.py              # POST /synapse
├── rag/
│   ├── prompt_builder.py       # Context + query + constraints
│   ├── context_retriever.py    # SQLite-VEC or Pinecone
│   ├── temporal_resolver.py    # "Monday" → date → SKU
│   └── trust_gate.py           # Filter context by Trust Ladder level (Guardian §5.3)
├── llm/
│   ├── router.py               # MoE: simple < 200ms, complex → large model
│   └── inference.py            # Structured output
├── persona/
│   ├── aura.py                 # Linguistic guidelines
│   ├── ambiguity.py            # Vague intent, contradiction, bridge proposals (Brand §3.2)
│   └── emotional_state.py      # Execution/Discovery/Precision mode detection
├── observability/
│   ├── tracing.py              # OpenTelemetry propagation
│   └── metrics.py              # Prometheus: latency, confidence, cache hits
├── models/
│   └── whisper_ng.py           # Nigerian-tuned Whisper
└── requirements.txt
```

### Trust Ladder Context Gating (Guardian §5.3)

Context injection is filtered by the user's current trust level:
- **Level 0 (Stranger):** Hub popularity data only. No personal context.
- **Level 1 (Acquaintance):** Recent orders (last 10), basic preferences.
- **Level 2 (Confidant):** Full dietary profile, household size, depletion model.
- **Level 3 (Partner):** Everything — voice patterns, address, full anticipatory provisioning.

### Ambiguity Resolution (Brand Manual §3.2)

- **Vague Intent:** Synthesize day-of-week + weather + time + depletion model → confident proposal. Never ask "Can you be more specific?"
- **Contradiction:** Propose a bridge between stated desire and behavioral pattern. Never judge.
- **Emotional State Detection:** Terse → Execution Mode (short, no humor). Exploratory → Discovery Mode. Frustrated → Precision Mode (explicit confirmation).
- **One-Question Rule:** Max one clarifying question per turn. If still ambiguous, commit to hypothesis.

### Aura Persona (Brand Manual §3)

- Partner, not servant. Decisive, not open-ended.
- Short, information-dense sentences.
- Dry humor — disabled in Execution Mode.
- Nigerian English fluent, Pidgin-capable.
- Anti-Interrogation Rule: propose, don't interrogate.

---

## Component 3: Payment Cascade Router

```
services/pay-router/
├── src/
│   ├── index.ts
│   ├── gateways/
│   │   ├── paystack.ts         # Primary
│   │   ├── flutterwave.ts      # Secondary
│   │   └── wallet.ts           # Tertiary
│   ├── cascade.ts              # 16s total timeout (PRD §4.4)
│   └── pod_fallback.ts         # Pay-on-Delivery via Bio-Handshake
```

**Cascade:** Paystack (4s) → Flutterwave (4s) → Wallet (4s) → Pay-on-Delivery. Total 16s max.

---

## Key Constraints

| Metric | Target | Source |
|--------|--------|--------|
| Voice-to-intent | < 800ms | PRD §3.1 |
| Simple intent (MoE fast) | < 200ms | Build Strategy §7.1 |
| Payment total timeout | 16s all gateways | PRD §4.4 |
| Round-trip latency | < 1.2s (P95) | Build Strategy §8 |
| Circuit breaker threshold | 5 failures / 60s | Blueprint §5.4 |
| Session snapshot interval | Every 5 seconds | Blueprint §5.3 |
| Whisper confidence floor | 60% | Blueprint §5.3 |

## Dependencies

**Needs:** PCM audio from Flutter, SQLite-VEC vectors from Edge builder, PoF scores from Nexus API
**Provides:** Synapse Payload to Flutter, trace context to Nexus, payment status, Prometheus metrics
