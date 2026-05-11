# services/intent-engine/rag/ — Structure Map

## Purpose
RAG (Retrieval-Augmented Generation) pipeline for the Intent Engine.

## Files

| File | Responsibility |
|------|---------------|
| prompt_builder.py | Orchestrates context assembly and Trust Ladder gating |
| temporal_resolver.py | Resolves temporal references (e.g., "Monday" -> SKU date) |
| dietary_enforcer.py | Intercepts allergens based on user dietary blocklists |
| ambiguity_resolver.py | Resolves vague or contradictory intent based on emotional state |

## Data Flow
User Intent -> [ambiguity_resolver] -> [temporal_resolver] -> [prompt_builder (with trust_level)] -> [dietary_enforcer] -> Output
