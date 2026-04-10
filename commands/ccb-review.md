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
