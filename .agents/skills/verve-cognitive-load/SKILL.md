---
name: verve-cognitive-load
description: "MANDATORY: Enforce file size limits (300-500 lines), context window management, file splitting rules, and structural mapping for all Verve builder skills. Read this BEFORE writing any code."
category: workflow
risk: safe
source: project
tags: "[context-management, file-splitting, memory, cognitive-load, code-structure, agent-rules]"
date_added: "2026-05-10"
priority: critical
---

# Verve Cognitive Load Manager — Agent Writing & Reading Rules

## Purpose

Prevent agent hallucination, context overflow, and structural drift during multi-file development. This skill defines **mandatory rules** for how agents read, write, split, and map files across the Verve codebase. Every builder skill MUST follow these rules.

**Why this exists:** Large Language Models have 128k+ token context windows, but their *effective reasoning window* is significantly smaller. Empirical evidence shows that agent code quality degrades sharply when:
- A single file exceeds ~500 lines
- More than 3-4 files are held in working context simultaneously
- The agent lacks a structural map of the codebase

This skill ensures the agentic build system produces code that is correct, maintainable, and within the agent's reliable cognition boundary.

---

## The Three Laws of Agent Cognition

### Law 1: The 300-Line Rule

> **No source file shall exceed 500 lines. Target 300 lines. Plan splits at 250.**

| Zone | Lines | Action |
|------|-------|--------|
| 🟢 Green | 1–250 | Normal. File can grow. |
| 🟡 Yellow | 251–400 | **Plan a split.** Identify logical boundaries NOW. |
| 🔴 Red | 401–500 | **Execute split immediately.** Extract the next logical module before adding more code. |
| ⛔ Forbidden | 500+ | **NEVER write a file this long.** If a task would produce 500+ lines, decompose it BEFORE writing. |

### Law 2: The Context Budget

> **Never hold more than 4 files in active reasoning context simultaneously.**

When working on a task:
1. **1 primary file** — the file being written/modified
2. **1 interface file** — the contract this file must satisfy (types, API schema, trait)
3. **1 dependency file** — the upstream module this file calls
4. **1 reference file** — the doc or spec being implemented

If a task requires understanding more than 4 files, the agent MUST first create a **Context Summary** (see below) that compresses the other files into a structural map.

### Law 3: The Structural Map

> **Every directory with 5+ files MUST have a `_MAP.md` file summarizing the structure.**

A structural map is a compressed representation that lets an agent understand a directory without reading every file. It lives alongside the code and is updated by whichever builder creates or modifies files in that directory.

---

## File Splitting Protocol

### When to Split

Before writing any file, the builder MUST estimate the output size:

```
ESTIMATE: websocket_handler.go
- WebSocket upgrade: ~30 lines
- Read loop: ~40 lines
- Write loop: ~40 lines
- Session state machine: ~80 lines
- Error handling: ~30 lines
- Tests inline: NO (separate file)
TOTAL ESTIMATE: ~220 lines → 🟢 Green. Proceed.
```

```
ESTIMATE: prompt_builder.py
- Trust Ladder gating: ~60 lines
- Context assembly: ~50 lines
- Dietary constraint injection: ~40 lines
- Temporal resolution: ~60 lines
- Ambiguity resolution: ~80 lines
- Emotional state adaptation: ~50 lines
- Template rendering: ~40 lines
TOTAL ESTIMATE: ~380 lines → 🟡 Yellow. Plan split NOW.
```

### How to Split

Split by **single responsibility**, not by arbitrary line count. Each extracted file should answer: *"What is the ONE thing this module does?"*

**Split hierarchy (prefer top to bottom):**

1. **By domain concern** — dietary logic vs. temporal logic vs. ambiguity logic
2. **By data flow stage** — input validation → processing → output formatting
3. **By abstraction level** — interfaces/types → core logic → utilities
4. **By test boundary** — each testable unit in its own file

**Example split (prompt_builder.py → 3 files):**

```
BEFORE: rag/prompt_builder.py (380 lines)

AFTER:
  rag/prompt_builder.py     (120 lines) — Orchestrates context assembly + template rendering
  rag/trust_gate.py         (100 lines) — Trust Ladder context filtering
  rag/ambiguity_resolver.py (160 lines) — Vague intent, contradiction, emotional state
```

### Split Naming Convention

| Pattern | Use When |
|---------|----------|
| `module.py` + `module_types.py` | Types/interfaces exceed 50 lines |
| `module.py` + `module_utils.py` | Utility functions exceed 40 lines |
| `feature/index.ts` + `feature/logic.ts` + `feature/types.ts` | Feature module with distinct concerns |
| `handler.go` + `handler_test.go` | Always separate tests |

---

## Context Summary Format

When a task requires understanding a module that the agent isn't actively reading, create a **Context Summary** instead of loading the full file:

```markdown
## Context Summary: services/orchestrator/internal/circuit/

### Purpose
Per-service circuit breakers for the Go Orchestrator (Blueprint §5.4).

### Public Interface
- `NewCircuitBreaker(name, threshold, window, cooldown) → *CircuitBreaker`
- `breaker.Execute(fn) → (result, error)`
- `breaker.IsOpen() → bool`
- `breaker.State() → CLOSED | OPEN | HALF_OPEN`

### Key Constraints
- Threshold: 5 failures in 60s window
- Open duration: 30s cooldown
- Each downstream service has its own breaker instance

### Files (3 files, ~280 total lines)
- `breaker.go` (120 lines) — Core state machine
- `registry.go` (80 lines) — Named breaker registry
- `metrics.go` (80 lines) — Prometheus counter integration

### Dependencies
- Upstream: websocket/handler.go calls breaker.Execute()
- Downstream: Wraps calls to Intent Engine, Nexus API, Payment Router
```

**Rule:** A context summary MUST fit in **< 30 lines**. If it takes more, the module is too complex — split it further.

---

## Directory Map (_MAP.md) Format

Every directory with 5+ source files MUST contain a `_MAP.md`:

```markdown
# services/intent-engine/rag/ — Structure Map

## Purpose
RAG (Retrieval-Augmented Generation) pipeline for the Intent Engine.

## Files

| File | Lines | Responsibility | Key Exports |
|------|-------|---------------|-------------|
| prompt_builder.py | 120 | Orchestrates context assembly | `build_prompt(user, intent, inventory)` |
| context_retriever.py | 90 | Query SQLite-VEC or Pinecone | `retrieve_context(embedding, top_k)` |
| temporal_resolver.py | 85 | "Monday" → specific date → SKU | `resolve_temporal_ref(text, user)` |
| trust_gate.py | 100 | Filter context by Trust Level | `gate_context(raw, trust_level)` |
| ambiguity_resolver.py | 160 | Handle vague/contradictory intent | `resolve(intent, context)` |

## Data Flow
```
User speech → transcribe → [context_retriever] → [trust_gate] → [prompt_builder]
                                                                       ↓
                                            [ambiguity_resolver] ← if vague
                                                                       ↓
                                                                  LLM inference
```

## Constraints
- Total directory: ~555 lines across 5 files (avg 111/file ✅)
- All files import from `../models/` for type definitions
- trust_gate.py MUST be called before prompt_builder.py
```

**When to update:** Any builder that creates, deletes, or significantly modifies a file in the directory MUST update `_MAP.md`.

---

## Builder Pre-Flight Checklist

Every builder skill MUST run this checklist before writing code:

```
PRE-FLIGHT: [TASK-ID]
□ Estimated output size: ___ lines
□ Size zone: 🟢 Green / 🟡 Yellow / 🔴 Red
□ If Yellow/Red: split plan defined? Y/N
□ Files in active context: ___ / 4 max
□ Context summaries created for non-active dependencies? Y/N
□ Target directory has _MAP.md? Y/N (create if 5+ files after this task)
□ Proceeding.
```

## Builder Post-Flight Checklist

After completing any file:

```
POST-FLIGHT: [TASK-ID]
□ Final file size: ___ lines
□ Size zone: 🟢 / 🟡 / 🔴
□ If Yellow: split plan noted in verve-memory decision log
□ _MAP.md updated? Y/N
□ Context summaries still accurate? Y/N
□ Checkpoint via verve-memory
```

---

## Reading Strategy for Large Codebases

When an agent needs to understand an existing module:

### Step 1: Read the Map
Read `_MAP.md` first. This gives the structural overview without consuming context.

### Step 2: Read Interfaces Only
Read type definitions, function signatures, and exported APIs. Skip implementation details unless directly relevant.

### Step 3: Depth-First on Target
Only read the full implementation of the specific file being modified or called.

### Step 4: Context Summaries for Rest
For all other files in the dependency chain, use context summaries — never full file reads.

**Anti-Pattern:** Never `view_file` on 5+ files in sequence to "understand the codebase." This floods the context window and degrades reasoning. Use maps and summaries instead.

---

## Memory Integration

### Session Start
When `verve-conductor` starts a session:
1. Load `build-state.json` (via `verve-memory`)
2. Read `_MAP.md` files for the current phase's active directories
3. Generate context summaries for recently modified modules
4. Present the structural overview to the builder

### During Build
- After every file write, check line count against the 300-line rule
- After every 3rd file creation in a directory, check if `_MAP.md` needs creation
- Log any split decisions in the verve-memory decision log

### Session Resume
When resuming after a context reset:
1. `_MAP.md` files serve as instant re-orientation
2. Context summaries in `.agents/context/` provide compressed module understanding
3. The agent should NEVER need to re-read more than 4 files to resume work

---

## File Locations

| File | Purpose |
|------|---------|
| `_MAP.md` (per directory) | Structural map for directories with 5+ source files |
| `.agents/context/*.md` | Persistent context summaries for cross-session memory |
| `.agents/state/build-state.json` | Decision log entries for split decisions |

## Enforcement

This skill is **MANDATORY** for all builder skills. The `verve-verifier` checks:
- [ ] No source file exceeds 500 lines
- [ ] All directories with 5+ files have `_MAP.md`
- [ ] Split decisions are logged in verve-memory
- [ ] Context summaries exist for modules with cross-layer dependencies
