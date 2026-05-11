# .gitignore for AI-Assisted Projects

A standard .gitignore plus the AI-tool-specific additions most people miss.

---

## The additions most people miss

```gitignore
# AI tool state -- these contain session data, not code
.claude/
.cursor/
.windsurf/
.copilot/

# Local overrides and secrets
*.local
.env
.env.*
!.env.example

# Claude Code plan files (if you use /plan mode)
.claude/plans/
.claude/checkpoints/

# Cursor workspace
.cursorworkspace
```

---

## Full recommended .gitignore

Copy this for any new project. Adjust the language sections.

```gitignore
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
.copilot/

# OS
.DS_Store
Thumbs.db
*.swp
*.swo
.idea/
.vscode/

# Logs
*.log
npm-debug.log*
yarn-debug.log*
pnpm-debug.log*

# Test coverage
coverage/
.nyc_output/

# Runtime data
*.pid
*.seed
*.pid.lock

# Misc
.cache/
tmp/
temp/
```

---

## The .env.example pattern

Your `.env` is gitignored. But new contributors (or your future self) need to know what variables exist. The solution:

**`.env` (gitignored):**
```
DATABASE_URL=postgresql://localhost:5432/mydb
REDIS_URL=redis://localhost:6379
DISCORD_TOKEN=your-actual-token-here
```

**`.env.example` (committed):**
```
DATABASE_URL=
REDIS_URL=
DISCORD_TOKEN=
```

Commit `.env.example`. Never commit `.env`.

---

## After you add .gitignore

If you've already committed files that should be ignored:
```bash
git rm -r --cached .claude/
git rm --cached .env
git commit -m "remove tracked files that should be gitignored"
```

The `--cached` flag removes from git tracking without deleting the actual file.
