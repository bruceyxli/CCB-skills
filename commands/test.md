# Generate Tests

Write tests for the specified code.

## Target

$ARGUMENTS

## Process

1. **Read the code** — Understand inputs, outputs, side effects, and edge cases.
2. **Check existing tests** — Look for test files, test framework, patterns already in use. Match the existing style.
3. **Identify test framework** — Detect from package.json/pyproject.toml/Cargo.toml/etc. If none exists, suggest one and confirm with user before installing.
4. **Write tests** covering:

### Test Categories
- **Happy path** — Normal inputs produce expected outputs
- **Edge cases** — Empty inputs, null/undefined, boundary values, max/min
- **Error cases** — Invalid inputs, missing required fields, type mismatches
- **Integration** — Components work together correctly (if applicable)

### Test Quality Rules
- Each test tests ONE thing (single assertion per behavior)
- Test names describe the behavior, not the implementation: `"returns empty array when no items match filter"` not `"test filter function"`
- No test interdependence — each test sets up its own state
- No mocking unless absolutely necessary (prefer real implementations for unit-testable code)
- Mock only at system boundaries (network, filesystem, database)

## Output

Write the test file(s) and run them. Report results:
```
✓ X passed
✗ Y failed (with details)
```

If any test fails, fix the test or flag the bug in the source code.
