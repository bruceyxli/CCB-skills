---
name: ccb-test
description: Generate tests using mutation testing and property-based principles
stage: execution
arguments: "target code or module"
reads:
  - source-code
  - existing-tests
writes:
  - test-files
destructive: true
suggests_next:
  - ccb-review
research:
  - "Papadakis et al., Mutation Testing Advances, Advances in Computers 2019"
  - "MacIver et al., Hypothesis: Property-Based Testing, JOSS 2019"
---

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

## Examples

### Example 1: Pure-logic unit tests

**Scenario:** `lib/config.js` is schema-driven and easy to test in isolation.

**Invocation:** `/ccb-test lib/config.js — cover schema validation and default-value fallback`

**Output excerpt:**
```
Wrote 14 tests in lib/config.test.js using node:test:
- ✓ accepts valid schema-conformant config
- ✓ rejects unknown top-level keys
- ✓ falls back to default when a field is missing
- ✓ rejects type mismatches (string where number expected)
- ✓ mutation killer: flipping the "required" check would be
  caught by "rejects unknown top-level keys"

## Coverage Notes
- All 4 public exports tested
- Known gap: filesystem error paths in loadConfig — those are
  system boundaries and need integration tests, not units
```

### Example 2: Mutation check on existing tests

**Scenario:** Suspect existing anomaly tests aren't catching off-by-one bugs.

**Invocation:** `/ccb-test audit lib/anomaly.test.js — what mutations would slip through?`

**Output excerpt:**
```
## Mutation Simulation
- Flipping `>= threshold` to `> threshold` in detectBurnRateSpike
  → NOT CAUGHT by existing tests (no boundary test at exactly threshold)
  → suggested new test: assertDoesNotFire(threshold)
                        assertFires(threshold + 0.01)

- Removing the 10-event debounce in detectCacheMissBurst
  → NOT CAUGHT (tests only check steady-state, not transients)
  → suggested: add test that fires 9 events and asserts no alert
```

## Known Limitations

- Mutation-sensitive analysis here is a mental simulation, not real mutation testing. Tools like Stryker (JS), mutmut (Python), or Pitest (Java) provide ground truth.
- Property-based tests are most effective on pure functions. Stateful code (databases, file I/O, global mutable state) is hard to express as invariants.
- Greenfield projects with no existing tests force the skill to guess a framework — it will ask for confirmation rather than pick one silently.
- Does not write integration/E2E tests by default. Those need explicit scope, fixtures, and often dedicated infrastructure this skill doesn't manage.
- Cannot test non-deterministic behavior (timing, concurrency, external APIs) without mocks, which the skill avoids by default.
