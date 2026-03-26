# Code Cleanup (Garbage Collection)

Inspired by the "entropy and garbage collection" principle: continuously pay off technical debt in small installments rather than letting it accumulate.

## Scope

$ARGUMENTS

If no scope given, scan the entire project.

## Cleanup Targets

### Dead Code
- Unused imports and require statements
- Unused variables, functions, classes
- Commented-out code blocks
- Unreachable code after return/throw/break

### Consistency
- Mixed naming conventions (camelCase vs snake_case inconsistency)
- Mixed quote styles in the same file
- Inconsistent error handling patterns
- Mixed async patterns (callbacks vs promises vs async/await)

### Code Smells
- Files over 300 lines (candidates for splitting)
- Functions over 50 lines (candidates for extraction)
- Deeply nested blocks (>3 levels)
- Duplicated code blocks (3+ copies)
- Magic numbers without named constants
- `TODO`/`FIXME`/`HACK` comments that are stale

### Dependencies
- Unused dependencies in package.json / requirements.txt
- Outdated lock files
- `npm audit` / security warnings

## Process

1. Scan for each cleanup target
2. List findings grouped by category
3. Get user confirmation before making changes
4. Apply fixes in small, atomic commits (one category per commit)
5. Run tests after each change

## Rules
- Never change behavior — cleanup only
- If unsure whether something is unused, leave it and flag it
- Prefer deleting over commenting out
- No "while I'm here" improvements — stay focused on cleanup
