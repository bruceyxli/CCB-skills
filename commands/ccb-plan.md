# Implementation Plan

Design an implementation plan before writing any code. Do NOT write code — only produce the plan.

## Task

$ARGUMENTS

## Process

1. **Understand the goal** — Restate the task in your own words. Identify ambiguities and assumptions.

2. **Explore the codebase** — Read relevant files to understand:
   - Current architecture and patterns in use
   - Existing abstractions that can be reused
   - Naming conventions and code style
   - Test patterns (if tests exist)

3. **Identify affected files** — List every file that needs to change, with a one-line summary of the change.

4. **Design the approach** — For each change:
   - What specifically changes and why
   - Any new files, functions, or types needed
   - Dependencies between changes (what must happen first)

5. **Consider trade-offs** — Call out:
   - Alternative approaches you considered and why you rejected them
   - Risks or edge cases
   - What this does NOT solve (explicit non-goals)

6. **Define the execution order** — Number the steps in dependency order. Group independent steps that can be parallelized.

## Output Format

```
## Summary
One paragraph overview.

## Files to Change
- `path/to/file.ts` — what changes
- `path/to/new-file.ts` — (new) why it's needed

## Approach
Step-by-step with rationale.

## Trade-offs
- Chose X over Y because...
- Risk: ...
- Non-goal: ...

## Execution Order
1. ...
2. ... (can parallel with 3)
3. ...
```

Wait for user confirmation before proceeding to implementation.
