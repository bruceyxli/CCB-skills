# Security Audit

Perform a focused security audit on the codebase or specified area.

## Scope

$ARGUMENTS

If no scope given, audit the entire project.

## Audit Areas

### 1. Authentication & Authorization
- How are credentials stored? (must be hashed with proper KDF)
- Token generation: is it cryptographically random?
- Token comparison: timing-safe?
- Session management: expiry, rotation, revocation
- Rate limiting on auth endpoints

### 2. Input Validation & Injection
- All user inputs validated at system boundaries
- SQL/NoSQL injection vectors
- Command injection (child_process, exec, spawn with user data)
- Path traversal (user input in file paths)
- XSS (if web frontend exists)
- Template injection

### 3. Secrets Management
- No hardcoded secrets in source code
- `.env` / config files in `.gitignore`
- Secrets not logged or exposed in error messages
- API keys scoped to minimum required permissions

### 4. Network & Transport
- HTTPS/TLS configured
- CORS policy appropriate
- WebSocket authentication
- No sensitive data in URLs/query strings

### 5. Dependencies
- Check for known vulnerabilities: `npm audit` / `pip audit` / equivalent
- Pinned versions (lock files committed)
- No unnecessary dependencies

### 6. Error Handling
- Errors don't leak stack traces or internal state to clients
- No silent catch blocks that swallow security-relevant errors

## Output

For each finding:
```
[CRITICAL|HIGH|MEDIUM|LOW] Category — Description
  Location: file:line
  Impact: what could go wrong
  Fix: specific remediation
```

End with an executive summary and prioritized fix list.
