#!/bin/bash
# Pre-commit hook: run linting on staged files
# Copy to .git/hooks/pre-commit and chmod +x

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# JavaScript/TypeScript
JS_FILES=$(echo "$STAGED_FILES" | grep -E '\.(js|ts|jsx|tsx)$')
if [ -n "$JS_FILES" ]; then
  if command -v npx >/dev/null 2>&1; then
    echo "Running ESLint on staged files..."
    echo "$JS_FILES" | xargs npx eslint --fix
    echo "$JS_FILES" | xargs git add
  fi
fi

# Python
PY_FILES=$(echo "$STAGED_FILES" | grep -E '\.py$')
if [ -n "$PY_FILES" ]; then
  if command -v ruff >/dev/null 2>&1; then
    echo "Running ruff on staged files..."
    echo "$PY_FILES" | xargs ruff check --fix
    echo "$PY_FILES" | xargs git add
  fi
fi
