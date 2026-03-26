# Debug

Systematically investigate and fix a bug.

## Problem

$ARGUMENTS

## Process

1. **Reproduce** — Understand the exact steps, inputs, and environment that trigger the bug. If you can't reproduce, gather more info before guessing.

2. **Isolate** — Narrow down the location:
   - Read error messages and stack traces carefully
   - Search for relevant code paths
   - Add targeted logging if needed (remove after fixing)
   - Check recent changes: `git log --oneline -20` and `git diff HEAD~5`

3. **Understand** — Before fixing, explain:
   - What is happening (the actual behavior)
   - What should happen (the expected behavior)
   - Why it's happening (root cause, not just symptoms)

4. **Fix** — Apply the minimal change that addresses the root cause:
   - Don't fix symptoms — fix causes
   - Don't refactor surrounding code
   - Don't add defensive code for unrelated scenarios

5. **Verify** — Confirm the fix:
   - The original bug no longer occurs
   - No regressions (run existing tests if available)
   - Edge cases of the same bug are also handled

## Anti-patterns
- Shotgun debugging (changing random things until it works)
- Fix-and-pray (making a change without understanding why it works)
- Over-fixing (adding excessive validation/error handling beyond the bug scope)
- Cargo cult fixes (copying patterns from Stack Overflow without understanding them)

## Output Format
```
## Root Cause
One sentence explaining why the bug occurs.

## Fix
Description of the change and why it's correct.

## Files Changed
- file:line — what changed
```
