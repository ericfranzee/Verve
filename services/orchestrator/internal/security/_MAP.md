# services/orchestrator/internal/security/ — Structure Map

## Purpose
Go Orchestrator internal modules handling zero-trust validations, attestation, and anti-tamper checking to secure the Edge AI and distributed logic.

## Files
- `attestation.go`: HMAC-based device payload verification enforcing the Edge model extraction defense (Phase 5).

## Constraints
- Cryptographic checks must not block the main connection loop (keep lightweight).