# Explore Codebase

Build a mental model of an unfamiliar codebase or area. Do NOT modify any files.

## Focus Area

$ARGUMENTS

If no focus given, explore the entire project.

## Methodology

Exploration follows a structured architecture recovery approach informed by program
comprehension research (Storey, "Theories, tools, and research methods in program
comprehension", Software Visualization 2005) — moving from high-level structure to
focused details, building understanding layer by layer.

## Process

1. **Entry points** — Find the main entry point(s):
   - package.json scripts, Makefile targets, main files
   - `main`, `index`, `app`, `server` files
   - CLI entry points, lambda handlers, API route registrations

2. **Architecture** — Map the high-level structure:
   - Directory layout and what each dir contains
   - Key modules and their responsibilities
   - Data flow: trace a typical request/operation end-to-end from input to output
   - Dependency graph between modules (which modules import which)
   - Identify architectural pattern: MVC, layered, microservices, event-driven, etc.

3. **Boundaries and interfaces** — Identify system boundaries:
   - External APIs consumed (HTTP clients, SDK calls)
   - External APIs exposed (REST endpoints, GraphQL, gRPC)
   - Database schemas and access patterns
   - Message queues, event buses, pub/sub
   - File system interactions

4. **Patterns** — Identify conventions in use:
   - Framework and libraries
   - Code style (naming, formatting, structure)
   - Error handling patterns (throw, Result type, error codes, callbacks)
   - Testing patterns and coverage
   - Configuration management (env vars, config files, feature flags)

5. **State** — Where does state live?
   - Databases, caches, in-memory stores
   - Session/auth state management
   - Configuration files, environment variables
   - External services and APIs

6. **Security posture** — Quick assessment:
   - How is authentication implemented?
   - Where is input validation performed?
   - Are there obvious security anti-patterns? (don't do a full audit — just flag red flags)

7. **Key decisions** — Look for architectural choices:
   - README, ARCHITECTURE.md, ADRs, CLAUDE.md
   - Comments explaining "why" (not "what")
   - Unusual patterns that suggest past trade-offs

## Output Format

```
## Overview
One paragraph summary of what this project does and how.

## Architecture
- Directory structure with descriptions
- Key modules and their relationships (text diagram or adjacency list)
- Architectural pattern identified

## Tech Stack
- Language, framework, key dependencies
- Build/test/deploy tooling

## Data Flow
How does a typical request/operation flow through the system?
[input] → [module A] → [module B] → [database/external service] → [output]

## System Boundaries
- External APIs: [list with purpose]
- Database: [type, key tables/collections]
- Other services: [list]

## Key Files
- `path/file` — why it matters (entry point, core logic, config, etc.)

## Security Quick Look
- Auth: [how it works]
- Input validation: [where it happens]
- Red flags: [any obvious concerns]

## Observations
- Patterns worth noting
- Potential concerns (tech debt, missing tests, unclear ownership)
- Questions for the maintainer
```
