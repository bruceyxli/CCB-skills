# Pre-Deployment Check

Verify the project is ready for deployment. Do NOT deploy — only check.

## Context

$ARGUMENTS

## Methodology

Security checks follow OWASP Application Security Verification Standard (ASVS) Level 1
and are cross-referenced with CWE identifiers for traceability.

## Checklist

### 1. Code Quality
- [ ] No uncommitted changes (`git status` clean)
- [ ] All tests pass
- [ ] No lint errors
- [ ] No TypeScript/type errors (if applicable)
- [ ] Build succeeds

### 2. Security (OWASP ASVS-aligned)
- [ ] **Secrets (CWE-798):** No secrets in source code — grep for API keys, passwords, tokens, private keys
- [ ] **Config isolation:** `.env` / config files are in `.gitignore`; production secrets loaded from environment/vault
- [ ] **Dependencies (CWE-1395):** No critical vulnerabilities (`npm audit` / `pip audit` / equivalent)
- [ ] **Auth (CWE-287):** Authentication properly configured; all protected routes enforce auth (run consistency check)
- [ ] **CORS (CWE-942):** Set correctly for production — not wildcard `*`
- [ ] **TLS (CWE-319):** HTTPS enforced; `verify=False` / `rejectUnauthorized: false` not present
- [ ] **Headers:** Security headers configured (`Strict-Transport-Security`, `Content-Security-Policy`, `X-Content-Type-Options`, `X-Frame-Options`)
- [ ] **Debug mode:** Disabled in production config; no verbose error output to clients (CWE-209)
- [ ] **Logging:** No secrets or PII written to logs (CWE-532)

### 3. Configuration
- [ ] Environment variables documented
- [ ] Production config differs from development where needed
- [ ] Database migrations are up to date (if applicable)
- [ ] Feature flags set correctly

### 4. Dependencies
- [ ] Lock file is committed and up to date
- [ ] No dev dependencies in production bundle
- [ ] Node/Python/runtime version matches production

### 5. Documentation
- [ ] README has setup instructions
- [ ] API changes are documented
- [ ] Breaking changes are noted

### 6. Rollback Readiness
- [ ] Database migrations are reversible (if applicable)
- [ ] Previous version can be re-deployed without data loss
- [ ] Health check endpoint exists and works

## Output

```
## Deploy Readiness: ✓ READY / ✗ NOT READY

### Passing
- ✓ check description

### Failing (must fix)
- ✗ [CWE-XXX] check description
  → what to fix

### Warnings (non-blocking)
- ⚠ concern
  → recommended action

### Security Summary
- Auth consistency: X/Y endpoints protected
- Secrets scan: clean / N issues found
- Dependency audit: X critical, Y high, Z moderate
```
