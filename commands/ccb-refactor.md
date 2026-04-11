---
name: ccb-refactor
description: Restructure code for maintainability without changing behavior
stage: execution
arguments: "target files or modules"
reads:
  - source-code
  - tests
writes:
  - code-changes
destructive: true
suggests_next:
  - ccb-review
  - ccb-test
---

# Refactor

Restructure code for better maintainability without changing behavior.

## Target

$ARGUMENTS

## Principles

1. **Read first** — Understand the full scope before making changes. Read all affected files.
2. **Preserve behavior** — No functional changes. If tests exist, they must still pass.
3. **One concern per module** — Split files that do multiple unrelated things.
4. **Encapsulate state** — Don't export raw mutable data structures. Provide accessor functions.
5. **Eliminate duplication** — But only extract when there are 3+ copies. Two similar blocks are fine.
6. **Name things clearly** — Rename unclear variables/functions. Use domain language.
7. **Remove dead code** — Delete unused imports, functions, variables. No commented-out code.
8. **Keep it boring** — Prefer well-known patterns over clever abstractions.

## Process

1. Read the target code and its dependents
2. Identify specific refactoring opportunities (list them)
3. Propose the restructured file/module layout
4. Get user confirmation
5. Execute the refactoring
6. Run tests if available
7. Verify no behavior change with `git diff`

## Anti-patterns to Fix
- God files (>300 lines doing multiple things)
- Circular dependencies
- Deep nesting (>3 levels of if/for)
- require/import inside functions
- Magic numbers without constants
- Silent error swallowing (`catch {}`)
- Leaky abstractions (internals exposed through exports)

## Examples

### Example: Extract a module

**Scenario:** `lib/store.js` is 500 lines and mixes session logic with persistence.

**Invocation:** `/ccb-refactor extract atomic save/load logic from lib/store.js into lib/persistence.js`

**Output excerpt:**
```
## Plan
1. Move saveAtomic, loadFromDisk, and related helpers to lib/persistence.js
2. Update lib/store.js to import from persistence
3. Keep the same public API — no call sites change
4. Run existing tests (lib/anomaly.test.js) to verify no regression

## Changes Made
- lib/persistence.js (new) — 87 lines
- lib/store.js — 502 → 418 lines, now imports from persistence
- No test changes required (no public API changed)
```

## Known Limitations

- "Preserve behavior" is only verifiable when meaningful tests exist. Without tests, every refactor carries regression risk — consider running `/ccb-test` first.
- Cannot detect subtle semantic changes: exception propagation, timing dependencies, side-effect ordering, garbage collection pressure. The test suite must catch these.
- Encapsulating state in deeply leaky codebases often requires coordinated changes across many files — the "minimal change" principle may not apply at scale.
- Does not refactor public APIs. API-breaking changes are a migration (`/ccb-migrate`); architecture changes need a plan (`/ccb-plan`) first.
- Renaming across dynamic references (reflection, string-based lookup, DSL code generation) will miss call sites.
