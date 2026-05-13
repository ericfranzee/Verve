---
name: verve-backend-builder
description: Build real Go Orchestrator, Python Intent Engine, and Node.js Nexus API services with production-grade code, database connections, and test coverage.
---

# Verve Backend Builder Skill

## Purpose
You build **real, functional backend services** for Verve. No mocks, no stubs, no hardcoded responses. Every function connects to real databases, real APIs, and real external services.

## Service Ownership

### Go Orchestrator (`services/orchestrator/`)
**Port:** 8080 | **Role:** WebSocket gateway, session manager, circuit breaker

**Build Checklist:**
- [ ] WebSocket upgrade with JWT validation on first message
- [ ] Session state stored in Redis (not in-memory)
- [ ] Audio chunk routing to Intent Engine via HTTP
- [ ] Synapse payload relay from Intent Engine to Flutter client
- [ ] Order update relay from Nexus API to Flutter client
- [ ] Bio-Handshake TOTP generation and BLE token management
- [ ] Circuit breaker for Intent Engine and Nexus API calls
- [ ] Purge endpoint with cascade (Intent Engine + Nexus API)
- [ ] Health check with dependency status
- [ ] OpenTelemetry tracing integration

**File Structure:**
```
services/orchestrator/
├── main.go
├── internal/
│   ├── server/
│   │   ├── ws_server.go       # WebSocket handler
│   │   ├── message_router.go  # Message type dispatcher
│   │   └── auth.go            # JWT validation
│   ├── session/
│   │   ├── manager.go         # Redis-backed session state
│   │   └── state.go           # Session state types
│   ├── circuit/
│   │   └── breaker.go         # Circuit breaker state machine
│   ├── security/
│   │   ├── origin.go          # CORS origin whitelist
│   │   └── purge.go           # Purge cascade handler
│   └── sync/
│       └── reconciler.go      # Edge-cloud sync
├── go.mod
└── go.sum
```

### Python Intent Engine (`services/intent-engine/`)
**Port:** 8000 | **Role:** Voice transcription, LLM inference, TTS generation

**Build Checklist:**
- [ ] Real Whisper API integration (OpenAI or self-hosted)
- [ ] Real LLM integration (GPT-4o / GPT-4o-mini via MoE router)
- [ ] RAG pipeline: prompt builder + temporal resolver + dietary enforcer
- [ ] Nexus API client for PoF verification
- [ ] TTS generation (OpenAI TTS or Azure)
- [ ] Synapse payload construction with timed UI sequences
- [ ] Purge endpoint for vector memory deletion
- [ ] Rider AI Copilot alert generation

**File Structure:**
```
services/intent-engine/
├── main.py
├── core/
│   ├── whisper_transcriber.py  # Real Whisper API
│   ├── moe_router.py           # Model selection logic
│   ├── tts_engine.py           # Real TTS API
│   └── nexus_client.py         # GraphQL client to Nexus API
├── rag/
│   ├── prompt_builder.py       # System prompt construction
│   ├── temporal_resolver.py    # Time-aware intent parsing
│   ├── dietary_enforcer.py     # Allergen blocklist enforcement
│   └── ambiguity_resolver.py   # Clarification logic
├── copilot/
│   └── alerts.py               # Rider hazard alert generator
└── tests/
    ├── test_transcriber.py
    ├── test_moe_router.py
    └── test_voice_loop.py
```

### Node.js Nexus API (`services/nexus-api/`)
**Port:** 4000 | **Role:** GraphQL API, inventory, orders, payments, chaos protocols

**Build Checklist:**
- [ ] PostgreSQL connection pool (pg + node-pg-migrate)
- [ ] Redis connection (ioredis)
- [ ] Full GraphQL schema from `Verve API Contracts.md`
- [ ] Auth resolvers (register, login, refresh with bcrypt + JWT)
- [ ] Product CRUD resolvers
- [ ] Inventory management with PoF scoring
- [ ] Order lifecycle (create → confirm → pick → dispatch → deliver)
- [ ] Payment cascade (Paystack → Flutterwave → Wallet → PoD)
- [ ] 10 Chaos Protocol implementations
- [ ] Rider management resolvers
- [ ] Webhook handlers (Paystack, Flutterwave)
- [ ] Nexus Lead Dashboard (static HTML served via Express)

## Implementation Standards

### Database Queries
```typescript
// CORRECT — parameterized query
const result = await pool.query('SELECT * FROM products WHERE hub_id = $1 AND status = $2', [hubId, 'in_stock']);

// WRONG — string interpolation
const result = await pool.query(`SELECT * FROM products WHERE hub_id = '${hubId}'`);
```

### Error Handling
```go
// CORRECT — explicit error handling
result, err := intentEngine.Infer(ctx, payload)
if err != nil {
    if errors.Is(err, ErrTimeout) {
        breaker.RecordFailure()
        return fallbackResponse(session), nil
    }
    return nil, fmt.Errorf("inference failed: %w", err)
}
```

### Test Pattern
Every new function needs a corresponding test:
```python
# test_whisper_transcriber.py
def test_transcribe_returns_text_and_confidence():
    transcriber = WhisperTranscriber(api_key="test")
    result = transcriber.transcribe(sample_audio_bytes)
    assert "text" in result
    assert "confidence" in result
    assert result["confidence"] >= 0.0
```

## Critical Rules
- **No mock implementations** — if an external API key isn't available, use environment variable checks and skip tests gracefully
- **Always use parameterized queries** — never interpolate user input into SQL
- **Always validate JWT** on authenticated endpoints
- **Always handle timeouts** — 4-second max for payment gateways, 8-second max for LLM calls
- **Read `_stub` files** for architectural intent before building replacements
