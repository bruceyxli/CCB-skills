# CCB-skills

A collection of reusable Claude Code slash commands for common programming workflows.

Inspired by [Harness Engineering](https://openai.com/index/harness-engineering/) — treating the repo as the system of record, enforcing constraints mechanically, and turning engineering taste into repeatable tools.

## Skills

| Command | Description |
|---------|-------------|
| `/review` | Code review with security, architecture, reliability, and quality checks |
| `/plan` | Design implementation plans before writing code |
| `/security-audit` | Focused security audit across auth, injection, secrets, network |
| `/refactor` | Restructure code without changing behavior |
| `/test` | Generate tests matching existing project patterns |
| `/debug` | Systematic bug investigation and fix |
| `/cleanup` | Code garbage collection — dead code, inconsistencies, smells |
| `/optimize` | Measure-first performance optimization |
| `/explore` | Map an unfamiliar codebase without modifying anything |
| `/deploy-check` | Pre-deployment readiness checklist |
| `/doc` | Generate documentation at code, module, or project level |
| `/migrate` | Framework/library migration planning and execution |
| `/pr` | Create well-structured pull requests |

## Quick Start

```bash
# Install all skills globally (available in every project)
mkdir -p ~/.claude/commands
cp commands/*.md ~/.claude/commands/

# Or on Windows
mkdir %USERPROFILE%\.claude\commands
copy commands\*.md %USERPROFILE%\.claude\commands\
```

Then in Claude Code: `/review src/auth.js`

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
