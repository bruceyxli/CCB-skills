# Generate Tests

Write tests for the specified code.

## Target

$ARGUMENTS

## Methodology

Test generation follows a structured coverage strategy informed by mutation testing
principles (Papadakis et al., "Mutation Testing Advances", Advances in Computers 2019)
and property-based testing (MacIver et al., "Hypothesis: A New Approach to Property-Based
Testing", JOSS 2019). The goal is tests that catch real bugs, not just tests that pass.

## Process

1. **Read the code** — Understand inputs, outputs, side effects, and edge cases.
2. **Check existing tests** — Look for test files, test framework, patterns already in use. Match the existing style.
3. **Identify test framework** — Detect from package.json/pyproject.toml/Cargo.toml/etc. If none exists, suggest one and confirm with user before installing.
4. **Analyze mutation-sensitive paths** — Before writing tests, identify:
   - Boundary conditions (off-by-one in loops, `<` vs `<=`, `>` vs `>=`)
   - Boolean conditions that could be flipped (`&&` vs `||`, `!` negation)
   - Return value paths — what happens if a different branch is taken?
   - Null/undefined checks — what if the check is removed?
   These are the places where real bugs hide; tests must cover them.
5. **Write tests** covering the categories below.

### Test Categories

- **Happy path** — Normal inputs produce expected outputs
- **Boundary values** — Test at exact boundaries, one above, one below. For collections: empty, single element, at capacity. For numbers: 0, -1, MAX_INT, MIN_INT
- **Error cases** — Invalid inputs, missing required fields, type mismatches
- **Mutation killers** — For each critical condition in the code, write a test that would FAIL if that condition were flipped/removed. Ask: "If I changed this `<` to `<=`, would any test catch it?"
- **Integration** — Components work together correctly (if applicable)
- **Property-based** (when appropriate) — Instead of specific input/output pairs, test invariants that must hold for ALL inputs:
  - `sort(x).length == x.length` (length preservation)
  - `decode(encode(x)) == x` (round-trip)
  - `f(x) >= 0` for all valid x (range constraints)
  - Use the framework's property-testing support if available (Hypothesis, fast-check, proptest)

### Test Quality Rules
- Each test tests ONE thing (single assertion per behavior)
- Test names describe the behavior, not the implementation: `"returns empty array when no items match filter"` not `"test filter function"`
- No test interdependence — each test sets up its own state
- No mocking unless absolutely necessary (prefer real implementations for unit-testable code)
- Mock only at system boundaries (network, filesystem, database)
- **Mutation test check:** After writing tests, mentally simulate removing or flipping one condition in the source code — would your tests catch it? If not, add a test that would

## Output

Write the test file(s) and run them. Report results:
```
✓ X passed
✗ Y failed (with details)

## Coverage Notes
- Critical branches covered: [list]
- Mutation-sensitive conditions tested: [list]
- Known gaps: [conditions not tested and why]
```

If any test fails, fix the test or flag the bug in the source code.
