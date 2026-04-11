---
name: ccb-deploy-check
description: OWASP ASVS-aligned pre-deployment readiness checklist (read-only)
stage: deployment
arguments: "context or empty"
reads:
  - source-code
  - git-status
  - tests
  - config-files
  - dependencies
writes:
  - deploy-checklist
destructive: false
suggests_next:
  - ccb-pr
  - ccb-security-audit
research:
  - "OWASP Application Security Verification Standard (ASVS) Level 1"
---

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

## Examples

### Example: Pre-release check before cutting stable

**Scenario:** About to cut v1.6.0 stable from the beta branch.

**Invocation:** `/ccb-deploy-check`

**Output excerpt:**
```
## Deploy Readiness: ✗ NOT READY

### Failing (must fix)
- ✗ [CWE-798] Hardcoded API token in scripts/test-hook.js:12
  → move to env var, update .gitignore
- ✗ Dependencies: 1 high vulnerability (ws < 8.18.1, ReDoS)
  → npm update ws

### Passing
- ✓ git status clean
- ✓ all tests pass (14/14)
- ✓ no debug mode enabled in production config
- ✓ HTTPS certs valid (if --https used)
- ✓ PBKDF2 iterations = 100k (meets OWASP 2017, below 2023 recommendation)

### Warnings (non-blocking)
- ⚠ No health check endpoint — recommended for production monitoring
- ⚠ PBKDF2 iterations should be bumped to 210k per OWASP 2023

### Security Summary
- Auth consistency: 18/19 endpoints protected (see /api/debug)
- Secrets scan: 1 finding (scripts/test-hook.js)
- Dependency audit: 0 critical, 1 high, 2 moderate
```

## Known Limitations

- OWASP ASVS Level 1 is a minimum floor, not a ceiling. Critical applications (financial, healthcare, identity, infrastructure) need Level 2 or 3.
- Cannot verify production-only behaviors: load handling, race conditions under traffic, CDN caching edge cases, DNS-level failures, network partitions.
- Rollback verification assumes the deployment system supports it — the skill does not validate the rollback mechanism itself.
- "All tests pass" is only as strong as the test suite. A clean run on a thin suite is not a deployment signal.
- Environment-variable checklist assumes deployment config is in env vars. Secrets managers, Vault, or cloud-native configs need manual verification.
- Does not check observability readiness: alerting thresholds, dashboard coverage, on-call handoff. Add these to your runbook.
