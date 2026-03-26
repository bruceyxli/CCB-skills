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
