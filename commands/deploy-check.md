# Pre-Deployment Check

Verify the project is ready for deployment. Do NOT deploy — only check.

## Context

$ARGUMENTS

## Checklist

### 1. Code Quality
- [ ] No uncommitted changes (`git status` clean)
- [ ] All tests pass
- [ ] No lint errors
- [ ] No TypeScript/type errors (if applicable)
- [ ] Build succeeds

### 2. Security
- [ ] No secrets in source code (grep for API keys, passwords, tokens)
- [ ] `.env` / config files are in `.gitignore`
- [ ] Dependencies have no critical vulnerabilities (`npm audit` / equivalent)
- [ ] Authentication is properly configured
- [ ] CORS is set correctly for production

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

## Output

```
## Deploy Readiness: ✓ READY / ✗ NOT READY

### Passing
- ✓ check description

### Failing
- ✗ check description
  → what to fix

### Warnings
- ⚠ non-blocking concern
```
