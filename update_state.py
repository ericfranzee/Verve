import json

with open('.agents/state/build-state.json', 'r') as f:
    state = json.load(f)

tasks = [
    {"id": "P1-T01", "name": "Go Orchestrator skeleton", "status": "pending"},
    {"id": "P1-T02", "name": "Python FastAPI Intent Engine", "status": "pending"},
    {"id": "P1-T03", "name": "Mono-repo scaffold", "status": "pending"},
    {"id": "P1-T04", "name": "SQLite-VEC integration", "status": "pending"},
    {"id": "P1-T05", "name": "CRUD for local embeddings", "status": "pending"},
    {"id": "P1-T06", "name": "SQLCipher encryption", "status": "pending"},
    {"id": "P1-T07", "name": "RAG prompt pipeline", "status": "pending"},
    {"id": "P1-T08", "name": "Temporal reference resolution", "status": "pending"},
    {"id": "P1-T09", "name": "Dietary constraint enforcement", "status": "pending"},
    {"id": "P1-T10", "name": "PCM audio capture pipeline", "status": "pending"},
    {"id": "P1-T11", "name": "Whisper transcription", "status": "pending"},
    {"id": "P1-T12", "name": "Complete round-trip loop", "status": "pending"},
    {"id": "P1-T13", "name": "Optimize round-trip latency", "status": "pending"},
    {"id": "P1-T14", "name": "Trust Ladder data access enforcement", "status": "pending"},
    {"id": "P1-T15", "name": "Temporal decay pruning", "status": "pending"},
    {"id": "P1-T16", "name": "DB corruption recovery", "status": "pending"},
    {"id": "P1-T17", "name": "Ambiguity Resolution engine", "status": "pending"},
    {"id": "P1-T18", "name": "MoE LLM router", "status": "pending"},
    {"id": "P1-T19", "name": "Circuit breaker skeleton", "status": "pending"},
    {"id": "P1-T20", "name": "Redis session state snapshots", "status": "pending"},
    {"id": "P1-T21", "name": "Session crash recovery", "status": "pending"}
]

state['phases']['1']['tasks'] = tasks

with open('.agents/state/build-state.json', 'w') as f:
    json.dump(state, f, indent=2)
