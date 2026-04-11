---
name: ccb-plan
description: Design an implementation plan before writing code (no code execution)
stage: planning
arguments: "task description"
reads:
  - source-code
  - existing-patterns
writes:
  - plan-document
destructive: false
suggests_next:
  - ccb-refactor
  - ccb-test
  - ccb-review
---

# Implementation Plan

Design an implementation plan before writing any code. Do NOT write code — only produce the plan.

## Task

$ARGUMENTS

## Process

1. **Understand the goal** — Restate the task in your own words. Identify ambiguities and assumptions.

2. **Explore the codebase** — Read relevant files to understand:
   - Current architecture and patterns in use
   - Existing abstractions that can be reused
   - Naming conventions and code style
   - Test patterns (if tests exist)

3. **Identify affected files** — List every file that needs to change, with a one-line summary of the change.

4. **Design the approach** — For each change:
   - What specifically changes and why
   - Any new files, functions, or types needed
   - Dependencies between changes (what must happen first)

5. **Consider trade-offs** — Call out:
   - Alternative approaches you considered and why you rejected them
   - Risks or edge cases
   - What this does NOT solve (explicit non-goals)

6. **Define the execution order** — Number the steps in dependency order. Group independent steps that can be parallelized.

## Output Format

```
## Summary
One paragraph overview.

## Files to Change
- `path/to/file.ts` — what changes
- `path/to/new-file.ts` — (new) why it's needed

## Approach
Step-by-step with rationale.

## Trade-offs
- Chose X over Y because...
- Risk: ...
- Non-goal: ...

## Execution Order
1. ...
2. ... (can parallel with 3)
3. ...
```

Wait for user confirmation before proceeding to implementation.

## Examples

### Example 1: Feature addition

**Scenario:** Adding rate limiting to an Express API before a public release.

**Invocation:** `/ccb-plan add per-IP rate limiting to all /api routes, 100 req/min`

**Output excerpt:**
```
## Summary
Apply express-rate-limit to the /api router with an in-memory store;
no new infra required.

## Files to Change
- lib/routes.js — wire middleware before route registration
- lib/config.js — add rateLimit subschema (window, max)
- README.md — document the new env vars

## Trade-offs
- Chose in-memory over Redis-backed: matches "no new infra" rule,
  but counters reset on restart — acceptable for burst protection,
  not sustained abuse.
- Non-goal: distributed limiting across multiple server instances.
```

### Example 2: Refactor planning

**Scenario:** `lib/store.js` has grown to 500 lines mixing session state, config, and persistence.

**Invocation:** `/ccb-plan split lib/store.js into sessions, config-store, persistence modules`

**Output excerpt:**
```
## Execution Order
1. Extract persistence.js (atomic save/load) — no call sites change
2. Extract config-store.js — update imports in routes.js
3. (parallel with 2) Extract sessions.js — update imports in tools.js
4. Shrink store.js to a façade for backward compatibility
5. Run /ccb-review on the result
```

## Known Limitations

- Plans are based on a snapshot of the codebase; long execution windows can invalidate assumptions. Re-plan if the scope shifts mid-implementation.
- Ambiguous requirements produce ambiguous plans. If the task has >2 reasonable interpretations, force clarification before planning.
- Trade-off analysis depends on alternatives Claude can enumerate — novel architectures or unfamiliar domains will have thinner alternatives lists.
- The plan does not estimate effort or timeline; step count is not a proxy for work required.
