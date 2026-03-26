# Generate Documentation

Create or update documentation for the specified code.

## Target

$ARGUMENTS

## Principles

- Documentation should explain **why**, not **what** (code already shows what)
- Write for the next developer who will maintain this code
- Keep it close to the code it documents
- Prefer inline comments for complex logic, README for setup/architecture

## What to Document

### Code-level (inline)
- Complex algorithms: explain the approach and why it was chosen
- Non-obvious side effects
- Workarounds with references to the issue they work around
- Performance-critical sections: why this approach was needed
- DO NOT add trivial comments (`// increment counter` above `counter++`)

### Module-level (file header or JSDoc/docstring)
- Purpose: what problem does this module solve
- Usage: how to use the primary exports
- Dependencies: what does it expect from the environment

### Project-level (README)
- What the project does (one paragraph)
- How to set up and run
- How to deploy
- Architecture overview (if complex)
- Configuration options

## Output

Generate the documentation in the appropriate location. For README updates, show the diff. For inline docs, add them directly to the source files.
