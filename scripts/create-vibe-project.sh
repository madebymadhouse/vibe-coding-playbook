#!/usr/bin/env bash
# create-vibe-project.sh
# Sets up a new project directory with AI context files, git, and a clean .gitignore
# Usage: ./create-vibe-project.sh <project-name>

set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: $0 <project-name>"
  exit 1
fi

PROJECT_NAME="$1"
PROJECT_DIR="$(pwd)/$PROJECT_NAME"

if [ -d "$PROJECT_DIR" ]; then
  echo "Error: directory $PROJECT_DIR already exists"
  exit 1
fi

echo "Creating project: $PROJECT_NAME"

mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# --- .gitignore ---

cat > .gitignore << 'GITIGNORE'
# Dependencies
node_modules/
.pnp
.pnp.js

# Build output
dist/
build/
.next/
out/
target/
__pycache__/
*.pyc
*.pyo

# Environment and secrets
.env
.env.*
!.env.example
*.local
*.secret

# AI tool state
.claude/
.cursor/
.windsurf/

# OS
.DS_Store
Thumbs.db
*.swp
*.swo
.idea/
.vscode/settings.json

# Logs
*.log
npm-debug.log*

# Test coverage
coverage/
.nyc_output/

# Misc
.cache/
tmp/
temp/
GITIGNORE

# --- CLAUDE.md ---

cat > CLAUDE.md << CLAUDEMD
# $PROJECT_NAME

[What this project does -- 1-2 sentences]

Stack: [language, framework, key libraries]
Entry: [main file or start command]
Test: [how to run tests, e.g. "npm test"]

[How the project is structured -- 2-3 sentences]

Off-limits: [files or directories that should not be touched]
Conventions: [patterns to follow, e.g. "use X not Y"]
CLAUDEMD

# --- .env.example ---

cat > .env.example << 'ENVEXAMPLE'
# Copy to .env and fill in values
# Never commit .env

# DATABASE_URL=
# REDIS_URL=
# API_KEY=
ENVEXAMPLE

# --- README.md ---

cat > README.md << READMEMD
# $PROJECT_NAME

[What this does]

## Setup

\`\`\`bash
cp .env.example .env
# fill in .env values
[install command, e.g. npm install]
[start command, e.g. npm start]
\`\`\`

## Usage

[Most common usage example]
READMEMD

# --- git init ---

git init -q
git add .
git commit -q -m "init: project scaffold with context files"

echo ""
echo "Done. Project created at: $PROJECT_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit CLAUDE.md with your actual stack and structure"
echo "  2. Edit .env.example with your environment variables"
echo "  3. Run: claude  (to start a Claude Code session)"
echo ""
echo "Start your first Claude session with:"
echo "  'Read CLAUDE.md. We're starting a new project. Here's what we're building: ...'"
