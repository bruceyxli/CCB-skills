# Code Review

Perform a thorough code review of the specified files or recent changes.

## Scope

$ARGUMENTS

If no specific files are given, review all uncommitted changes (`git diff` + `git diff --cached`).

## Review Checklist

### Security
- [ ] Timing-safe comparisons for secrets/tokens (`crypto.timingSafeEqual`)
- [ ] No command injection (user input interpolated into shell commands)
- [ ] No SQL injection / NoSQL injection
- [ ] Input validation at all system boundaries (API endpoints, CLI args, env vars)
- [ ] Secrets not hardcoded or committed (check for API keys, passwords, tokens)
- [ ] Password hashing uses proper KDF (bcrypt/scrypt/argon2/PBKDF2), NOT plain SHA/MD5
- [ ] Rate limiting on authentication endpoints
- [ ] CORS configured appropriately

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

## Output Format

For each finding:
```
[SEVERITY] file:line — description
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
