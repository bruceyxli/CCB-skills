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
