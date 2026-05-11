#!/usr/bin/env bash
# project-health.sh
# Quick health check for AI-assisted projects
# Run from project root or pass a path: ./project-health.sh [path]
# Exit code: 0 if all checks pass, 1 if any fail

set -euo pipefail

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

PASS=0
FAIL=0
WARN=0

pass() { echo "  PASS  $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL  $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  WARN  $1"; WARN=$((WARN + 1)); }

echo "Project health: $(basename "$(pwd)")"
echo "Path: $(pwd)"
echo "---"

# 1. CLAUDE.md exists and is non-trivial
echo "Context files:"
if [ -f "CLAUDE.md" ]; then
  LINES=$(wc -l < CLAUDE.md)
  if [ "$LINES" -lt 5 ]; then
    warn "CLAUDE.md exists but is very short ($LINES lines) -- probably not filled in"
  else
    pass "CLAUDE.md exists ($LINES lines)"
  fi
else
  fail "CLAUDE.md missing -- AI has no project context"
fi

if [ -f ".cursorrules" ]; then
  pass ".cursorrules exists"
fi

# 2. .gitignore blocks secrets and AI state
echo ""
echo "Security:"
if [ -f ".gitignore" ]; then
  if grep -q "\.env" .gitignore 2>/dev/null; then
    pass ".gitignore blocks .env files"
  else
    fail ".gitignore does not block .env -- secrets may be committed"
  fi
  if grep -q "\.claude" .gitignore 2>/dev/null; then
    pass ".gitignore blocks .claude/ directory"
  else
    warn ".claude/ not in .gitignore -- AI session state may be tracked"
  fi
else
  fail ".gitignore missing"
fi

# 3. No .env committed to git
if git rev-parse --git-dir > /dev/null 2>&1; then
  if git ls-files --error-unmatch .env > /dev/null 2>&1; then
    fail ".env is tracked by git -- remove it: git rm --cached .env"
  else
    pass ".env is not committed to git"
  fi

  # 4. Check for secrets-looking strings in staged/committed files
  SECRET_PATTERNS="(api_key|apikey|api-key|secret|password|token|private_key)\s*=\s*['\"][^'\"]{8,}"
  if git diff --cached --unified=0 2>/dev/null | grep -iE "$SECRET_PATTERNS" > /dev/null 2>&1; then
    fail "Staged changes may contain secrets -- review before committing"
  else
    pass "No obvious secrets in staged changes"
  fi
fi

# 5. README exists
echo ""
echo "Documentation:"
if [ -f "README.md" ]; then
  LINES=$(wc -l < README.md)
  if [ "$LINES" -lt 5 ]; then
    warn "README.md exists but very short -- probably a placeholder"
  else
    pass "README.md exists ($LINES lines)"
  fi
else
  warn "README.md missing"
fi

# 6. Context file freshness (days since last update)
if [ -f "CLAUDE.md" ] && git rev-parse --git-dir > /dev/null 2>&1; then
  LAST_MODIFIED=$(git log -1 --format="%ar" -- CLAUDE.md 2>/dev/null || echo "never")
  if [ "$LAST_MODIFIED" = "never" ]; then
    warn "CLAUDE.md has never been committed"
  else
    pass "CLAUDE.md last updated: $LAST_MODIFIED"
  fi
fi

# 7. Uncommitted changes
echo ""
echo "Git state:"
if git rev-parse --git-dir > /dev/null 2>&1; then
  DIRTY=$(git status --porcelain 2>/dev/null | wc -l)
  if [ "$DIRTY" -gt 10 ]; then
    warn "$DIRTY uncommitted changes -- consider committing before a long AI session"
  elif [ "$DIRTY" -gt 0 ]; then
    pass "$DIRTY uncommitted changes"
  else
    pass "Working tree clean"
  fi

  LAST_COMMIT=$(git log -1 --format="%ar" 2>/dev/null || echo "no commits")
  pass "Last commit: $LAST_COMMIT"
else
  warn "Not a git repository"
fi

# --- Summary ---
echo ""
echo "---"
echo "Results: $PASS passed, $WARN warnings, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  echo "Status: UNHEALTHY -- fix the failed checks before a long AI session"
  exit 1
elif [ "$WARN" -gt 0 ]; then
  echo "Status: OK with warnings"
  exit 0
else
  echo "Status: HEALTHY"
  exit 0
fi
