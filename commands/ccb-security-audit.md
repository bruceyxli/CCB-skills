# Security Audit

Perform a focused security audit on the codebase or specified area.

## Scope

$ARGUMENTS

If no scope given, audit the entire project.

## Methodology

This audit follows a two-phase approach inspired by hybrid static-analysis + LLM reasoning
(Li et al., "IRIS", 2024). Phase 1 casts a wide net with fast pattern matching; Phase 2
applies deeper semantic analysis only to flagged regions, reducing noise and improving accuracy.

---

## Phase 1: Static Pre-Scan

Before deep analysis, run lightweight pattern-matching to identify candidate vulnerable regions.
Use `grep`/`rg` or equivalent to scan for the following patterns, then collect file:line results
as input for Phase 2.

### Dangerous function calls
- `eval(`, `exec(`, `spawn(`, `child_process`, `subprocess`, `os.system`, `Runtime.exec`
- `innerHTML`, `dangerouslySetInnerHTML`, `document.write`
- Raw SQL string concatenation: `"SELECT.*" +`, `f"SELECT`, `format("SELECT`

### Credential / secret patterns
- `password\s*=\s*["']`, `api_key\s*=\s*["']`, `secret\s*=\s*["']`, `token\s*=\s*["']`
- `BEGIN RSA PRIVATE KEY`, `BEGIN OPENSSH PRIVATE KEY`
- Base64-encoded strings > 40 chars in source (potential embedded secrets)

### Crypto anti-patterns
- `MD5`, `SHA1` used for password hashing (not HMAC)
- `Math.random` / `random.random` used for token generation
- `== ` or `!=` for secret/token comparison (timing-unsafe)

### Network / config patterns
- `0.0.0.0`, `CORS: *`, `Access-Control-Allow-Origin: *`
- `verify=False`, `rejectUnauthorized: false`, `NODE_TLS_REJECT_UNAUTHORIZED`
- Disabled CSRF tokens

Collect all matches with file paths and line numbers. These are the inputs to Phase 2.

---

## Phase 2: LLM Deep Analysis

For each flagged region from Phase 1, plus a broader semantic review of the codebase,
analyze the following areas. For every check, reason step-by-step about data flow —
trace where user input enters the system and follow it through to any sensitive operation,
regardless of variable naming (Steenhoek et al., ASE 2024).

### 1. Authentication & Authorization (CWE-287, CWE-862, CWE-863)

**Chain-of-thought prompt:** For each authentication mechanism found, answer:
1. Where are credentials received? (endpoint, function)
2. How are they validated? (comparison method, timing safety)
3. What happens on failure? (error message, rate limiting, lockout)
4. After auth succeeds, how is the session/token created and stored?
5. Are there any code paths that bypass this check?

Specific checks:
- Credentials stored with proper KDF (bcrypt/scrypt/argon2/PBKDF2), NOT plain SHA/MD5
- Token generation uses cryptographically secure randomness (`crypto.randomBytes`, `secrets.token_bytes`)
- Token comparison is timing-safe (`crypto.timingSafeEqual`, `hmac.compare_digest`)
- Session management: expiry, rotation on privilege change, server-side revocation
- Rate limiting on auth endpoints (CWE-307: Improper Restriction of Excessive Auth Attempts)

**Consistency analysis (LLift-style):** Find ALL API endpoints/route handlers. For each one,
determine whether authentication and authorization are checked. Flag any endpoint that does not
follow the majority pattern — a missing auth check on one route out of many is a common
real-world vulnerability.

### 2. Input Validation & Injection (CWE-89, CWE-78, CWE-79, CWE-22, CWE-94)

**Chain-of-thought prompt:** For each user input entry point found, answer:
1. Where does user input enter? (HTTP params, headers, body, file uploads, WebSocket messages)
2. Is it validated/sanitized before use? What validation is applied?
3. Trace the input forward: does it reach any sensitive sink? (SQL query, shell command, file path, HTML output, template engine, `eval`)
4. Are there any intermediate transformations that could bypass validation? (encoding, decoding, type coercion)

Specific checks:
- **SQL/NoSQL injection (CWE-89):** Are queries parameterized? Trace any string concatenation into query construction
- **Command injection (CWE-78):** User data passed to shell execution functions? Check for proper escaping or use of argument arrays
- **Path traversal (CWE-22):** User input in file paths? Check for `../` normalization and chroot/jail
- **XSS (CWE-79):** User data rendered in HTML without escaping? Check for raw output in templates
- **Template injection (CWE-94):** User input passed to template engine `render` or `compile` functions?
- **Deserialization (CWE-502):** Untrusted data passed to `pickle.loads`, `yaml.load`, `JSON.parse` with reviver, `unserialize`?

### 3. Secrets Management (CWE-798, CWE-532)

**Chain-of-thought prompt:** For each secret/credential found in Phase 1 scan:
1. Is this a real secret or a placeholder/example?
2. If real: is it loaded from environment/vault at runtime, or hardcoded in source?
3. Could this secret appear in logs, error messages, or API responses?
4. Is the `.gitignore` correctly excluding secret-bearing files?

Specific checks:
- No hardcoded secrets in source code (CWE-798)
- `.env` / config files in `.gitignore`
- Secrets not logged or exposed in error messages (CWE-532)
- API keys scoped to minimum required permissions
- No secrets in URL query strings (they end up in server logs and browser history)

### 4. Network & Transport (CWE-319, CWE-942, CWE-295)

Specific checks:
- HTTPS/TLS enforced, not optional (CWE-319)
- TLS certificate verification not disabled (CWE-295)
- CORS policy restricts origins appropriately, not wildcard `*` (CWE-942)
- WebSocket connections authenticated
- No sensitive data in URLs/query strings
- Security headers present: `Strict-Transport-Security`, `Content-Security-Policy`, `X-Content-Type-Options`

### 5. Dependencies (CWE-1395)

Specific checks:
- Run `npm audit` / `pip audit` / `cargo audit` / equivalent and report findings
- Lock files committed (package-lock.json, poetry.lock, Cargo.lock)
- Pinned versions — no floating `*` or `latest`
- No unnecessary dependencies (attack surface reduction)
- Check for known-vulnerable transitive dependencies

### 6. Error Handling & Information Disclosure (CWE-209, CWE-390)

Specific checks:
- Errors don't leak stack traces, internal paths, or database schema to clients (CWE-209)
- No silent catch blocks that swallow security-relevant errors (CWE-390)
- Debug mode / verbose logging disabled in production config
- Custom error pages for 4xx/5xx (no framework defaults exposing internals)

---

## Output

### Per-finding format
For each finding, provide:
```
[CRITICAL|HIGH|MEDIUM|LOW] CWE-XXX: Category — Description
  Location: file:line
  Data flow: [input source] → [transformation] → [sensitive sink]
  Impact: what an attacker could achieve
  Fix: specific remediation with code example
  Confidence: HIGH|MEDIUM|LOW (based on whether data-flow was fully traced)
```

### Consistency report
After individual findings, report any inconsistencies found via consistency analysis:
```
CONSISTENCY: [description of pattern and violation]
  Majority pattern: [what most of the codebase does] (N/M locations)
  Violations: file:line, file:line
  Risk: a missing check here likely means [impact]
```

### Executive summary
End with:
1. Total findings by severity
2. Top 3 highest-risk issues requiring immediate attention
3. Consistency violations (these are often the most impactful real-world bugs)
4. Confidence assessment: which findings are certain vs. which need manual verification

---

## References

Methodology informed by:
- Li et al., "IRIS: Combining Static Analysis and LLMs for Vulnerability Detection" (2024) — two-phase hybrid approach
- Zhang et al., "Prompt-Enhanced Software Vulnerability Detection Using ChatGPT" (ICSE 2024) — CWE context + CoT prompting
- Li et al., "LLift: Detecting Bugs Using LLMs by Analyzing Coding Practices" (USENIX Security 2024) — consistency analysis
- Steenhoek et al., "Do Language Models Learn Semantics of Code?" (ASE 2024) — data-flow reasoning over surface pattern matching
- Deng et al., "PentestGPT" (USENIX Security 2024) — modular task decomposition for security analysis
