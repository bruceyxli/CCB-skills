# AGENTS.md Template

<!--
  Keep this file under 100 lines. It's a table of contents, not an encyclopedia.
  Point to deeper docs rather than inlining everything.
  See: https://openai.com/index/harness-engineering/
-->

## Project Map

| Directory | Purpose |
|-----------|---------|
| `src/` | Application source code |
| `src/lib/` | Core business logic |
| `src/api/` | API routes and handlers |
| `tests/` | Test files |
| `docs/` | Architecture and design docs |
| `scripts/` | Build and deploy scripts |

## Architecture

See [docs/architecture.md](docs/architecture.md) for the full architecture diagram.

**Key constraint**: Dependencies flow one direction: `UI → Service → Repository → Types`. No reverse dependencies.

## Conventions

- **Naming**: camelCase for variables/functions, PascalCase for types/classes
- **Error handling**: See [docs/error-handling.md](docs/error-handling.md)
- **Testing**: See [docs/testing.md](docs/testing.md)

## Active Work

- See [docs/plans/](docs/plans/) for current execution plans
- See [docs/design/](docs/design/) for design documents

## Quality Rules

These are mechanically enforced. Do not bypass them:

1. No files over 300 lines (split into modules)
2. No functions over 50 lines (extract helpers)
3. No `any` types (use `unknown` + type guards)
4. No silent `catch {}` blocks (log or propagate)
5. No unused imports or variables
