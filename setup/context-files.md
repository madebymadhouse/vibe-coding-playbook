# Context Files: What Goes Where

Every AI tool reads from some configuration file to understand your project. Here's what each one is, what goes in it, and what doesn't.

---

## CLAUDE.md (Claude Code)

Read at the start of every session. This is Claude's briefing. Keep it short and dense.

**What goes in it:**
- Stack (language, framework, key packages, versions that matter)
- Entry points
- Conventions the AI should follow
- Off-limits files/directories
- How to run tests
- Short glossary for domain-specific terms

**What doesn't:**
- Architecture diagrams
- Long explanations of how things work
- TODO lists
- Context that changes frequently

**Template:**
```markdown
# [Project name]

Stack: [language, framework, key deps]
Entry: [main file or command]
Test: [how to run tests]

[2-3 sentences on how the project is structured, in plain English]

Off-limits: [dirs or files that should not be touched]
Conventions: [patterns the AI should match]
```

**Real example (chopsticks):**
```markdown
# Chopsticks - Discord Bot

Stack: Node.js 20, Discord.js v14, PostgreSQL 15, Redis 7
Entry: src/index.js
Test: npm test (must pass before any commit)

Commands live in src/commands/ - one file per command, exports a default object 
with name, description, and execute(interaction). Economy in src/economy/. 
Voice room logic in src/voice/.

Off-limits: src/legacy/ -- deprecated event handlers, do not modify
Conventions: use db.query() not raw pg, all economy mutations go through Economy class
```

---

## .cursorrules (Cursor)

Cursor's equivalent of CLAUDE.md. Read before every Composer session.

**What goes in it:**
- Same as CLAUDE.md, but Cursor also reads it for autocomplete context
- Code style rules (Cursor enforces these more literally than Claude)
- File naming conventions
- Which patterns to follow vs avoid

**Template:**
```
# Project rules for [name]

Stack: [lang, framework]
Test command: [command]

## Coding style
- [style rule 1]
- [style rule 2]

## Project structure
[1-2 sentences]

## Do not touch
- [path]
```

---

## AGENTS.md (global, multi-tool)

A global file at `~/AGENTS.md` (or project-level if you have multiple AI tools working on the same project). More detailed than CLAUDE.md, covers the workspace, not just one project.

**What goes in it:**
- All active projects with their repos and purpose
- Which AI agents/tools are configured and what they do
- Infrastructure notes (VPS, deployment targets)
- Guardrails and behavioral rules that apply across all agents

**Who reads it:** Claude Code, Gemini CLI, any custom orchestration. Not typically used by Cursor.

---

## GEMINI.md (Gemini CLI)

Gemini CLI reads from this if you put it at `~/GEMINI.md` or project root.

Keep it as a redirect:
```markdown
# Context

Primary context: read ~/AGENTS.md and ~/.claude/checkpoints/latest.md for session state.
```

---

## .github/copilot-instructions.md (GitHub Copilot)

Copilot reads this automatically per repo. Put it in `.github/` at the repo root.

**What goes in it:**
- Brief project description
- Key conventions
- Pointer to your main context file if relevant

**Template:**
```markdown
# Copilot instructions for [project]

[1-2 sentence project description]

Key conventions:
- [convention 1]
- [convention 2]

Stack: [lang, framework, key deps]
```

---

## The hierarchy

If you're using multiple tools on the same project:
```
~/AGENTS.md              <- workspace-wide truth, agent manifest
~/CLAUDE.md              <- Claude Code session rules
~/.claude/checkpoints/   <- session handoff state
[project]/CLAUDE.md      <- project-specific context for Claude
[project]/.cursorrules   <- project-specific rules for Cursor
[project]/.github/copilot-instructions.md  <- Copilot
```

Don't duplicate. CLAUDE.md should point to AGENTS.md, not repeat it. .cursorrules can be brief if Cursor sees your CLAUDE.md anyway.
