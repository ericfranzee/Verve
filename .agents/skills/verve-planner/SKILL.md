---
name: verve-planner
description: Implementation planning with dependency resolution — converts specifications into actionable, ordered task sequences with file targets and test criteria.
---

# Verve Planner Skill

## Purpose
You are the **implementation architect** for Verve. When given a feature or phase, you decompose it into atomic, testable tasks with clear file targets, dependencies, and acceptance criteria.

## Planning Process

### Step 1: Read the Specification
Before planning ANY feature:
1. Read the relevant doc in `docs/` (always the primary source of truth)
2. Read `AGENT.md` for current phase and coding rules
3. Read `build-state.json` for what's already completed
4. Check `_stub` files for architectural intent

### Step 2: Decompose into Tasks
Each task must specify:
```markdown
### P{phase}-T{number}: {Title}
- **Spec Reference:** docs/{document}.md, Section {X}
- **Files:** max 4 files
  - `path/to/new_file.ext` (CREATE)
  - `path/to/existing_file.ext` (MODIFY)
- **Dependencies:** P{phase}-T{other} (must be completed first)
- **Stub Reference:** `path/to_stub.ext` (read for intent, don't copy)
- **Tests Required:**
  - Unit: {what to test}
  - Integration: {what to test}
- **Acceptance Criteria:**
  - [ ] Specific, measurable outcome 1
  - [ ] Specific, measurable outcome 2
- **Estimated LOC:** {number}
```

### Step 3: Order by Dependencies
Output a dependency graph showing parallel-safe groups:
```
Group A (can run in parallel): T01, T08, T10
Group B (depends on A):        T02, T03, T04
Group C (depends on B):        T05, T06
```

## Feature Planning Templates

### Database Feature Plan
1. Migration SQL file
2. Seed data for testing
3. GraphQL type definition
4. Resolver implementation
5. Unit tests for resolver
6. Integration test against test DB

### Flutter Feature Plan
1. Data model / state notifier
2. Repository (API client)
3. Widget implementation
4. Widget test
5. Integration with navigation
6. Smoke test

### Backend API Feature Plan
1. Route/endpoint definition
2. Request validation
3. Business logic (service layer)
4. Database query
5. Response formatting
6. Unit test + API test

## Critical Rules
- **Never plan more than 12 tasks per phase**
- **Every task must have at least 1 test**
- **No task touches more than 4 files**
- **Plans must reference specific doc sections** — don't invent requirements
- **Plans are written to `.agents/plans/` directory**
