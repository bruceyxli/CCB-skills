---
name: ccb-migrate
description: Framework/library migration with assessment, planning, and incremental execution
stage: execution
arguments: "migration target (e.g. 'React 17 → 18', 'Express → Fastify')"
reads:
  - source-code
  - dependencies
  - migration-guide
writes:
  - code-changes
  - migration-plan
destructive: true
suggests_next:
  - ccb-test
  - ccb-review
  - ccb-deploy-check
---

# Migrate / Upgrade

Migrate code from one framework, library version, or pattern to another.

## Migration

$ARGUMENTS

## Process

1. **Assess scope** — Before changing anything:
   - What is being migrated (framework, library, pattern, language version)?
   - What files are affected? How many?
   - Are there breaking changes in the target version?
   - Read the migration guide / changelog if one exists

2. **Plan** — Create a step-by-step migration path:
   - Can it be done incrementally or must it be all-at-once?
   - Which changes are mechanical (search-and-replace) vs. require judgment?
   - What is the rollback strategy?

3. **Execute** — Apply changes in order:
   - Start with dependency updates
   - Fix breaking API changes
   - Update configuration
   - Update code patterns
   - Update tests

4. **Verify** — After each step:
   - Build still passes
   - Tests still pass
   - No deprecation warnings (or they're documented as known)

## Rules
- Make the minimal changes needed for the migration
- Do NOT refactor, improve, or modernize unrelated code
- If a breaking change has multiple fix options, choose the one closest to the existing pattern
- Keep a list of follow-up improvements to do AFTER the migration is stable

## Examples

### Example: Framework version bump

**Scenario:** Express 5 has been stable for a year, time to upgrade from Express 4.

**Invocation:** `/ccb-migrate Express 4 → Express 5`

**Output excerpt:**
```
## Assessment
- 12 route handlers use req.params directly — all compatible
- 3 places use deprecated req.param() — must migrate
- lib/routes.js error-handler signature changed (4 args, not 3)
- No middleware uses deprecated APIs

## Execution Order
1. Update package.json: express ^4.21 → ^5.0
2. Replace req.param() calls (3 instances)
3. Update error handler signatures
4. Run tests after each step — rollback if anything red
5. Re-run /ccb-deploy-check before release

## Follow-up (NOT done in this migration)
- Async error handling can be simplified in Express 5 (no more
  wrapping in try/catch) — file as a separate cleanup task
- Trust proxy behavior changed slightly — verify LAN setup still works
```

## Known Limitations

- Official migration guides are often incomplete or cover only canonical cases. Edge cases, custom patches, and idiomatic deviations require human judgment.
- Custom patches, forks, monkey-patches, and vendored copies of the target library are migration traps — the skill will flag them but cannot auto-resolve.
- Cannot migrate runtime state: database schemas, persisted configs, serialized on-disk formats need dedicated migration scripts outside this skill's scope.
- Multi-week incremental migrations exceed a single invocation — the skill can plan the increments but won't orchestrate them across many sessions.
- Version-mixing during incremental migration (e.g., React 17 and 18 files coexisting) creates transient bugs the skill cannot predict.
