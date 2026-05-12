# Intent Engine Service

This service handles intent classification, transcription, and TTS for the Verve platform.

## Structure
- `main.py`: Entry point and FastAPI handlers.
- `core/`: Core processing engines (Whisper, TTS, MoE Router).
- `rag/`: RAG-related components (Prompt Builder, Resolvers).

## Constraints
- Performance is critical: Avoid blocking the FastAPI event loop with CPU/IO intensive tasks.
- Use `def` for blocking handlers to allow FastAPI to run them in a threadpool.
- Use `run_in_threadpool` if an `async def` handler must perform a blocking operation.
