# Create Pull Request

Prepare and create a well-structured pull request.

## Context

$ARGUMENTS

## Process

1. **Review changes** — Understand the full diff:
   - `git diff main...HEAD` (or appropriate base branch)
   - `git log --oneline main..HEAD`
   - Are all changes intentional? Any debug code left in?

2. **Self-review** — Before creating the PR:
   - [ ] No console.log / print debugging left in
   - [ ] No commented-out code
   - [ ] No TODO comments introduced without tracking
   - [ ] No unrelated changes mixed in
   - [ ] Tests pass
   - [ ] Lint passes

3. **Write PR description**:
   - **Title**: Short (<70 chars), imperative mood ("Add X", "Fix Y", not "Added X")
   - **Summary**: 1-3 bullet points of what changed and why
   - **Test plan**: How to verify the changes work

4. **Create the PR** using `gh pr create`

## PR Template

```
## Summary
- What changed and why

## Test Plan
- [ ] How to verify

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Rules
- One PR per logical change (don't mix features with refactors)
- If the diff is >500 lines, consider splitting into multiple PRs
- Link to issues if applicable
