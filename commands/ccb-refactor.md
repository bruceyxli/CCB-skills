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
