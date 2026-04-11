---
name: ccb-doc
description: Generate documentation at code, module, or project level (why not what)
stage: execution
arguments: "target code or module"
reads:
  - source-code
writes:
  - documentation
destructive: true
suggests_next:
  - ccb-review
---

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

## Examples

### Example: Explain a complex module

**Scenario:** `lib/anomaly.js` has 6 detectors and new contributors don't know when each fires.

**Invocation:** `/ccb-doc lib/anomaly.js — explain the 6 detectors and when each fires`

**Output excerpt:**
````
Added module-level JSDoc to lib/anomaly.js:

/**
 * Six anomaly detectors fed by a cost-weighted 5h rolling window.
 * Each runs on every Stop event; false positives are throttled
 * to ≤ 1 alert per detector per hour.
 *
 * - detectBurnRateSpike: > 3σ above 5h average cost/min
 * - detectCacheMissBurst: cache read ratio drops below 30%
 *   for ≥ 10 consecutive events (catches the pre-1.6.0 cache bug)
 * ...
 */

Also added inline comments on the two non-obvious thresholds
(hardcoded at lib/anomaly.js:12-14) — explains why they're
tuned to Sonnet pricing.
````

## Known Limitations

- Documenting "why" requires context beyond the code: commit messages, linked issues, design docs, or the original author. Without these, docs default to restating "what".
- Auto-generated docs for actively-changing code create maintenance debt. Prefer documenting stable modules; flag volatile areas as "see code".
- Cannot verify accuracy of external dependency documentation — outbound links may break and versions may drift.
- Inline comments in fast-moving code decay rapidly. Prefer README/ARCHITECTURE docs for stable high-level facts, inline only for non-obvious local logic.
- Cannot infer intended invariants that aren't already encoded in tests or types.
