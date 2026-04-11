# CCB-skills (Claude Code Basic Skills)

A collection of reusable Claude Code slash commands for common programming workflows.

Inspired by [Harness Engineering](https://openai.com/index/harness-engineering/) — treating the repo as the system of record, enforcing constraints mechanically, and turning engineering taste into repeatable tools.

## Skills

### By Stage

Skills are organized by development lifecycle stage. Each skill declares its stage in frontmatter for machine-readable discovery. Skills never hard-depend on each other, but many list `suggests_next` — a soft recommendation for what typically follows.

| Stage | Skills | Destructive |
|-------|--------|:-----------:|
| **Planning** | `/ccb-plan` | — |
| **Exploration** | `/ccb-explore` | — |
| **Execution** | `/ccb-refactor`, `/ccb-cleanup`, `/ccb-optimize`, `/ccb-doc`, `/ccb-test`, `/ccb-debug`, `/ccb-migrate` | ✓ |
| **Verification** | `/ccb-review`, `/ccb-security-audit` | — |
| **Deployment** | `/ccb-deploy-check`, `/ccb-pr` | — |

A typical flow: `explore → plan → refactor/test/etc → review → deploy-check → pr`. Each step is independent — pick what you need, skip what you don't.

### Full List

| Command | Description |
|---------|-------------|
| `/ccb-plan` | Design implementation plans before writing code |
| `/ccb-explore` | Map an unfamiliar codebase without modifying anything |
| `/ccb-refactor` | Restructure code without changing behavior |
| `/ccb-cleanup` | Code garbage collection — dead code, inconsistencies, smells |
| `/ccb-optimize` | Measure-first performance optimization |
| `/ccb-doc` | Generate documentation at code, module, or project level |
| `/ccb-test` | Generate tests matching existing project patterns |
| `/ccb-debug` | Systematic bug investigation and fix |
| `/ccb-migrate` | Framework/library migration planning and execution |
| `/ccb-review` | Code review with security, architecture, reliability, and quality checks |
| `/ccb-security-audit` | Focused security audit across auth, injection, secrets, network |
| `/ccb-deploy-check` | Pre-deployment readiness checklist |
| `/ccb-pr` | Create well-structured pull requests |

### Frontmatter Schema

Each skill begins with YAML frontmatter declaring its metadata:

```yaml
---
name: ccb-<name>
description: One-line summary
stage: planning | exploration | execution | verification | deployment
arguments: "what to pass as $ARGUMENTS"
reads: [source-code, git-diff, ...]    # inputs consumed
writes: [code-changes, report, ...]     # outputs produced
destructive: true | false               # modifies files?
suggests_next: [ccb-review, ...]        # soft navigation, not dependency
research: ["Author et al., Venue Year"] # optional academic grounding
---
```

This enables external tools (e.g. claude-monitor) to discover and analyze skill usage without parsing the full skill body.

### Known Limitations

Every skill ends with a `## Known Limitations` section listing its failure modes and out-of-scope cases. **Read it before applying a skill to a borderline case** — it tells you when the skill will be noisy, inaccurate, or ineffective.

The structure is grounded in *Externalization in LLM Agents* (Zhou et al., arXiv:2604.08224) §4.5, which identifies four boundary risks for externalized skills: semantic alignment, portability/staleness, unsafe composition, and context-dependent degradation. Documenting these per skill is how the project treats ClawBench's 33.3% reality check as a feature, not a bug.

## Quick Start

```bash
# Install all skills globally (available in every project)
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/

# Or on Windows
mkdir %USERPROFILE%\.claude\commands
copy commands\*.md %USERPROFILE%\.claude\commands\
```

Then in Claude Code: `/ccb-review src/auth.js`

## Templates

The `templates/` directory contains starter files for new projects:

- **CLAUDE.md** — Project context file for Claude Code
- **AGENTS.md** — Lightweight agent map (table of contents, not encyclopedia)

## Philosophy

From the OpenAI Harness Engineering article:

> "Give the agent a map, not a 1,000-page instruction manual."

Each skill is:
- **Focused** — does one thing well
- **Opinionated** — encodes best practices, not options
- **Process-oriented** — defines steps, not just outcomes
- **Self-contained** — no dependencies between skills

## See Also

- [Installation Guide](docs/installation.md)
