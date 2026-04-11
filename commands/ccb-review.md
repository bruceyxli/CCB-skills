---
name: ccb-review
description: Thorough code review with data-flow security tracing and consistency analysis
stage: verification
arguments: "files or empty (defaults to uncommitted changes)"
reads:
  - git-diff
  - source-code
writes:
  - review-report
destructive: false
suggests_next:
  - ccb-refactor
  - ccb-security-audit
research:
  - "Steenhoek et al., ASE 2024 (data-flow tracing)"
  - "Li et al., LLift, USENIX Security 2024 (consistency analysis)"
---

# Code Review

Perform a thorough code review of the specified files or recent changes.

## Scope

$ARGUMENTS

If no specific files are given, review all uncommitted changes (`git diff` + `git diff --cached`).

## Methodology

This review combines checklist-based inspection with two research-backed techniques:
1. **Data-flow tracing** for security checks — trace inputs to sinks, don't rely on naming patterns
   (Steenhoek et al., "Do LLMs Learn Semantics of Code?", ASE 2024)
2. **Consistency analysis** — flag deviations from majority patterns in the codebase
   (Li et al., "LLift", USENIX Security 2024)

## Review Checklist

### Security (CWE-referenced)
- [ ] **Injection (CWE-89, CWE-78, CWE-79):** Trace user input from entry point to sensitive sink (SQL, shell, HTML). Is it parameterized/escaped at every path?
- [ ] **Auth bypass (CWE-287, CWE-862):** Does every route/endpoint enforce authentication? Run consistency check — if most routes check auth, flag any that don't
- [ ] **Timing-safe comparisons (CWE-208):** Secrets/tokens compared with `crypto.timingSafeEqual` or `hmac.compare_digest`, not `==`
- [ ] **Hardcoded secrets (CWE-798):** No API keys, passwords, or tokens in source code
- [ ] **Password storage (CWE-916):** Uses proper KDF (bcrypt/scrypt/argon2/PBKDF2), NOT plain SHA/MD5
- [ ] **Rate limiting (CWE-307):** Auth endpoints have brute-force protection
- [ ] **CORS (CWE-942):** Not wildcard `*` in production

### Architecture
- [ ] Modules have clear boundaries; no circular dependencies
- [ ] State is encapsulated (no raw Map/object exports that leak mutation)
- [ ] `require`/`import` at module level, not inside functions (unless lazy-loading is intentional)
- [ ] Error handling: no silent `catch {}` — log or propagate
- [ ] No dead code or unused imports

### Reliability
- [ ] Graceful degradation on external service failure
- [ ] Timeouts on all network requests and child processes
- [ ] Resource cleanup (file handles, connections, intervals, event listeners)
- [ ] Bounded growth (queues, caches, maps have size limits or TTL)

### Code Quality
- [ ] No magic numbers — use named constants
- [ ] Functions do one thing
- [ ] No over-engineering (premature abstractions, unnecessary generics)
- [ ] Consistent naming conventions
- [ ] Tests cover the change (if test files exist)

### Consistency Analysis (LLift-style)

After the checklist review, perform an automated consistency check:
1. Identify the **dominant patterns** in the changed files' neighborhood (error handling style, auth checks, input validation approach, logging format)
2. Check whether the new/changed code **follows or deviates** from these patterns
3. Flag deviations — they are often bugs (a forgotten auth check) or future maintenance problems (inconsistent error handling)

## Output Format

For each finding:
```
[SEVERITY] file:line — description
  Data flow: [source] → [sink] (for security findings)
  → suggested fix
```

Severities: `CRITICAL` (security/data loss), `HIGH` (bugs), `MEDIUM` (maintainability), `LOW` (style/nit)

End with a summary table:
| Severity | Count |
|----------|-------|
| CRITICAL | X     |
| HIGH     | X     |
| MEDIUM   | X     |
| LOW      | X     |

If consistency violations were found, add:
```
## Consistency Violations
- [pattern] is used in N/M locations; this change deviates at file:line
```

## Examples

### Example: Pre-commit sanity check

**Scenario:** Just finished a feature, want to catch issues before committing.

**Invocation:** `/ccb-review`

**Output excerpt:**
```
[CRITICAL] lib/routes.js:87 — User input reaches shell via execSync
  Data flow: req.body.path → sanitize() (regex only) → execSync(cmd + path)
  → The regex misses backticks. PoC: path = "a`rm -rf /`"
  → fix: use execFile with argument array, not string concat

[MEDIUM] lib/store.js:234 — Silent catch swallows save failures
  → replace `catch {}` with explicit logger.error + metric increment

## Consistency Violations
- Timing-safe comparison is used in 5 of 6 secret checks;
  lib/auth.js:102 uses === on the legacy token path.

| Severity | Count |
|----------|-------|
| CRITICAL | 1     |
| MEDIUM   | 2     |
| LOW      | 4     |
```

## Known Limitations

- Consistency analysis (LLift-style) needs a dominant pattern to compare against — ineffective on tiny codebases, greenfield code, or files reviewed in complete isolation.
- Data-flow tracing degrades on heavy metaprogramming, dynamic dispatch, reflection, and cross-language boundaries (e.g., Python → C extension, JS → WASM).
- CWE checklist is calibrated for web/backend code; noisy for CLI tools and minimally useful for ML training/inference code.
- Static-only: runtime-only bugs (race conditions, load-dependent behavior, platform-specific quirks) are out of scope — pair with runtime tests.
- Severity ratings are heuristic; for high-stakes changes, treat HIGH findings as a floor for human review, not a ceiling.
