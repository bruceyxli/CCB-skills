# Explore Codebase

Build a mental model of an unfamiliar codebase or area. Do NOT modify any files.

## Focus Area

$ARGUMENTS

If no focus given, explore the entire project.

## Process

1. **Entry points** — Find the main entry point(s):
   - package.json scripts, Makefile targets, main files
   - `main`, `index`, `app`, `server` files

2. **Architecture** — Map the high-level structure:
   - Directory layout and what each dir contains
   - Key modules and their responsibilities
   - Data flow: how does input become output?
   - Dependency graph between modules

3. **Patterns** — Identify conventions in use:
   - Framework and libraries
   - Code style (naming, formatting, structure)
   - Error handling patterns
   - Testing patterns and coverage
   - Configuration management

4. **State** — Where does state live?
   - Databases, caches, in-memory stores
   - Configuration files, environment variables
   - External services and APIs

5. **Key decisions** — Look for architectural choices:
   - README, ARCHITECTURE.md, ADRs, CLAUDE.md
   - Comments explaining "why" (not "what")
   - Unusual patterns that suggest past trade-offs

## Output Format

```
## Overview
One paragraph summary of what this project does and how.

## Architecture
- Directory structure with descriptions
- Key modules and their relationships (text diagram)

## Tech Stack
- Language, framework, key dependencies
- Build/test/deploy tooling

## Data Flow
How does a typical request/operation flow through the system?

## Key Files
- `path/file` — why it matters (entry point, core logic, config, etc.)

## Observations
- Patterns worth noting
- Potential concerns
- Questions for the maintainer
```
