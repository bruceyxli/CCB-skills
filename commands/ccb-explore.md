---
name: ccb-explore
description: Map an unfamiliar codebase through structured architecture recovery (read-only)
stage: exploration
arguments: "focus area or empty (defaults to entire project)"
reads:
  - source-code
  - git-history
  - project-docs
writes:
  - architecture-report
destructive: false
suggests_next:
  - ccb-plan
  - ccb-review
research:
  - "Storey, Theories/tools/methods in program comprehension, Software Visualization 2005"
---

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

## Examples

### Example 1: Full onboarding

**Scenario:** First day on a new codebase — need a mental model before touching anything.

**Invocation:** `/ccb-explore`

**Output excerpt:**
```
## Overview
Express + WebSocket real-time dashboard for monitoring Claude Code
sessions. Single-file frontend, in-memory state, no database.

## Data Flow
Claude Code event → hook-handler.js → POST /hook
  → lib/routes.js → lib/store.js update
  → WebSocket broadcast → public/index.html re-render

## Key Files
- server.js — Express + WebSocket entry point
- lib/store.js — all session state (façade module)
- hook-handler.js — bridge between Claude Code hooks and server
```

### Example 2: Focused on auth

**Scenario:** About to modify authentication — want to know all auth-related code first.

**Invocation:** `/ccb-explore lib/auth.js and anything it touches`

**Output excerpt:**
```
## Key Files
- lib/auth.js — requireToken middleware, PBKDF2 password hashing
- lib/routes.js:42-68 — login endpoint calls verifyPassword
- lib/store.js:120-135 — apiToken generation (uuid v4)
- public/index.html:987 — token persisted in localStorage

## Red Flags
- WebSocket token is query-parameter-based → appears in server
  access logs if logging is enabled (currently disabled by default)
```

## Known Limitations

- Architecture recovery is most reliable below ~50k LOC; summaries become lossy on larger codebases and may miss important modules.
- Cannot recover design intent ("why this way?") without ADRs, commit messages with rationale, or README/ARCHITECTURE docs.
- Dynamic dispatch, dependency injection frameworks, and metaprogramming (decorators, macros, reflection) obscure the real call graph.
- Security Quick Look is a red-flag scan only — not a substitute for `/ccb-security-audit`.
- Read-only by design: will not run the code, so runtime-only behaviors (init order, lazy loading, feature flags) are inferred, not verified.
