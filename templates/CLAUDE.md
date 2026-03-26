# CLAUDE.md Template

## Project Overview
<!-- One paragraph: what does this project do? -->

## Tech Stack
<!-- Language, framework, key dependencies -->

## Architecture
<!-- Brief description of directory structure and data flow -->
```
src/
  components/  — UI components
  lib/         — Business logic
  api/         — API routes
```

## Development

```bash
# Install
npm install

# Run dev server
npm run dev

# Run tests
npm test

# Build
npm run build
```

## Code Conventions
<!-- Patterns the agent should follow -->
- Use TypeScript strict mode
- Prefer named exports over default exports
- Error handling: throw at boundaries, return Result types internally
- Tests: colocate with source files as `*.test.ts`

## Key Decisions
<!-- Non-obvious architectural choices and WHY -->
- We use X instead of Y because...
- Module Z is structured this way because...

## Do NOT
<!-- Things the agent should avoid -->
- Do not modify files in `generated/` — they are auto-generated
- Do not add new dependencies without discussing first
- Do not use `any` type
