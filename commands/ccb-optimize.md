---
name: ccb-optimize
description: Measure-first performance optimization for identified bottlenecks
stage: execution
arguments: "target component or known symptom"
reads:
  - source-code
  - profiling-data
  - benchmark-results
writes:
  - code-changes
  - optimization-report
destructive: true
suggests_next:
  - ccb-review
  - ccb-test
---

# Performance Optimization

Identify and fix performance bottlenecks.

## Target

$ARGUMENTS

## Process

1. **Measure first** — Never optimize without data. Check:
   - Existing profiling/monitoring output
   - Benchmark results
   - User-reported symptoms (slow load, high memory, etc.)

2. **Identify bottlenecks** — Look for:
   - O(n²) or worse algorithms in hot paths
   - Unnecessary re-renders (React) or re-computations
   - N+1 queries (database)
   - Synchronous I/O blocking event loop
   - Large bundle sizes / unoptimized assets
   - Memory leaks (unbounded caches, event listeners not cleaned up)
   - Excessive network requests (missing batching, caching)

3. **Prioritize** — Fix the biggest bottleneck first. 80/20 rule.

4. **Optimize** — Apply the minimal change:
   - Prefer algorithmic improvements over micro-optimizations
   - Add caching only where measurements justify it
   - Use built-in/standard solutions before custom ones
   - Document WHY the optimization exists (future readers need context)

5. **Verify** — Measure again after the change. If no measurable improvement, revert.

## Anti-patterns
- Premature optimization without measurement
- Micro-optimizations that sacrifice readability
- Adding complexity for theoretical performance gains
- Caching everything (cache invalidation is hard)
- Optimizing cold paths that run once

## Output
```
## Findings
1. [IMPACT: high/medium/low] Description — location
   Current: X (measured)
   After fix: Y (expected)

## Changes Made
- file:line — what changed and why
```

## Examples

### Example: Dashboard slowness at scale

**Scenario:** Dashboard lags when 50+ concurrent sessions are open.

**Invocation:** `/ccb-optimize dashboard render is slow with 50+ sessions`

**Output excerpt:**
```
## Findings
1. [IMPACT: high] public/index.html:renderSessions — O(n²) full re-render
   on every event, no memoization
   Current: 420ms per event at n=50 (measured via performance.now)
   After fix: ~45ms per event (expected, using row-level diffing)

2. [IMPACT: medium] WebSocket payload sends full session map per update
   Current: 58KB per broadcast at n=50
   After fix: ~2KB (delta-based update)

## Changes Made
- public/index.html — memoize session rows by last-modified timestamp
- lib/routes.js — broadcast deltas instead of full snapshots
```

## Known Limitations

- "Measure first" requires profiling infrastructure or the ability to add it. Optimizing on vibes is explicitly out of scope for this skill.
- N+1 query detection assumes ORM awareness — raw SQL hot paths must be identified manually.
- Micro-optimizations are wasted effort if the real bottleneck is a dependency, database, CDN, or network path. Check attribution before blaming user code.
- Algorithmic complexity has theoretical floors (comparison sort is Ω(n log n), etc.) — no amount of optimization crosses them.
- Benchmarks are sensitive to hardware, warm-up, and background load. Measured improvements <10% are often within noise.
