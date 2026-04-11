---
name: ccb-pr
description: Create well-structured pull request with self-review and PR template
stage: deployment
arguments: "context or empty (uses current branch)"
reads:
  - git-diff
  - git-history
writes:
  - pull-request
destructive: false
suggests_next: []
---

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

## Examples

### Example: Feature branch → master

**Scenario:** Feature branch is ready for review and merge.

**Invocation:** `/ccb-pr`

**Output excerpt:**
```
Self-review passed:
- ✓ No console.log / debug prints
- ✓ No commented-out code
- ✓ Tests pass (14/14)
- ✓ Lint clean

Creating PR...

PR #47 created: "Add remote approval timeout configuration"
URL: https://github.com/bruceyxli/claude-code-monitor/pull/47

## Summary
- Added `approvalTimeout` config (default 120s)
- Exposed via dashboard Settings → Safety
- hook-handler.js polls for the configured duration instead of hardcoded 2min

## Test Plan
- [ ] Set timeout to 5s, trigger a tool call, verify deny after 5s
- [ ] Set timeout to 300s, verify dashboard still works during long wait
- [ ] Verify config persists across restart
```

## Known Limitations

- Good PR descriptions need context from outside the code: linked issues, team decisions, user asks, design discussions. The skill writes the best description it can from the diff alone.
- Squash-vs-merge workflows affect how the PR body should be written (squash loses per-commit detail). The skill assumes a sensible workflow and doesn't auto-detect the target repo's policy.
- Cannot verify CI success in advance. Passing locally does not guarantee CI passes — especially when CI runs more strictly than local.
- Does not auto-link related issues unless provided explicitly. Issue-linking via PR body keywords (`Closes #123`) requires the user to supply the number.
- Does not check the target repo's PR template. If the repo has `.github/pull_request_template.md`, the skill may produce a body that duplicates or conflicts with it.
