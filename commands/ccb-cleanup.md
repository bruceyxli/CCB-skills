---
name: ccb-cleanup
description: Garbage collection for code - remove dead code, fix inconsistencies, clean smells
stage: execution
arguments: "scope or empty (defaults to entire project)"
reads:
  - source-code
  - dependencies
writes:
  - code-changes
  - cleanup-report
destructive: true
suggests_next:
  - ccb-review
  - ccb-test
---

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

## Examples

### Example: Quarterly project-wide scan

**Scenario:** Quarterly tech-debt pass before starting a new feature.

**Invocation:** `/ccb-cleanup`

**Output excerpt:**
```
### Dead Code
- lib/store.js:45 — unused export `_legacyGetState`
- public/index.html:1102 — 3 console.log calls left in debug block
- scripts/old-backup.js — entire file appears unreferenced (flagged, not deleted)

### Code Smells
- public/index.html — 1251 lines, consider splitting out skin logic
- lib/anomaly.js:detectCachePattern — 68-line function, extract helpers?

### Dependencies
- package.json: no unused deps found
- npm audit: 0 critical, 0 high

3 commits prepared (one per category), awaiting confirmation.
```

## Known Limitations

- Dead code detection is unreliable for dynamically-loaded modules: plugin systems, reflection-based DI, lazy imports, JIT-loaded classes.
- "Unused exports" may be part of a public API consumed outside the repo — check `package.json` "exports" field and semver impact before deleting.
- Consistency fixes may conflict with intentional style variations (e.g., a legacy module preserved deliberately for compatibility).
- Dependency audit flags vulnerabilities in declared dependencies only; transitive chains, private registries, and vendored code are out of scope.
- Stale `TODO`/`FIXME` detection relies on git blame age, not on whether the comment is still accurate — the skill may flag valid-but-old notes.
