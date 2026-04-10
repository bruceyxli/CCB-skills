# Debug

Systematically investigate and fix a bug.

## Problem

$ARGUMENTS

## Methodology

This process follows hypothesis-driven debugging informed by automated fault localization
research (Wong et al., "A Survey on Software Fault Localization", IEEE TSE 2016) and
LLM-assisted root cause analysis (Kang et al., "Explainable Automated Debugging", 2024).

## Process

1. **Reproduce** — Understand the exact steps, inputs, and environment that trigger the bug.
   If you can't reproduce, gather more info before guessing.

2. **Formulate hypotheses** — Based on the error and code structure, generate ranked hypotheses:
   - Read error messages and stack traces carefully — parse the FULL trace, not just the top frame
   - For each hypothesis, state: (a) what you think is wrong, (b) what evidence would confirm or refute it
   - Rank hypotheses by likelihood based on: proximity to the error site, recent changes, and complexity

3. **Isolate via spectrum analysis** — Narrow down the location:
   - **Trace the data flow** from input to crash site — what values does the data take at each step?
   - Check recent changes: `git log --oneline -20` and `git diff HEAD~5` — bugs often live in recent diffs
   - Use `git bisect` for regression bugs when the breaking commit is unclear
   - Add targeted logging at hypothesis-critical points (remove after fixing)

4. **Confirm root cause** — Before fixing, explain:
   - What is happening (the actual behavior)
   - What should happen (the expected behavior)
   - Why it's happening (root cause, not just symptoms)
   - Why your top hypothesis is correct (what evidence confirmed it)

5. **Fix** — Apply the minimal change that addresses the root cause:
   - Don't fix symptoms — fix causes
   - Don't refactor surrounding code
   - Don't add defensive code for unrelated scenarios
   - If the bug was caused by a missing check, use consistency analysis: does the same check exist elsewhere in the codebase? If so, follow that pattern exactly

6. **Verify** — Confirm the fix:
   - The original bug no longer occurs
   - No regressions (run existing tests if available)
   - Edge cases of the same bug are also handled
   - The root cause cannot recur through a similar code path

## Anti-patterns
- Shotgun debugging (changing random things until it works)
- Fix-and-pray (making a change without understanding why it works)
- Over-fixing (adding excessive validation/error handling beyond the bug scope)
- Cargo cult fixes (copying patterns from Stack Overflow without understanding them)
- Stack-trace tunnel vision (only reading the top frame — the real cause is often deeper)

## Output Format
```
## Hypotheses (ranked)
1. [Most likely] Description — evidence for/against
2. [Less likely] Description — evidence for/against

## Root Cause
One sentence explaining why the bug occurs.
Confirmed by: [what evidence proved this hypothesis]

## Fix
Description of the change and why it's correct.

## Files Changed
- file:line — what changed

## Regression Risk
What could this fix break? How was that verified?
```
