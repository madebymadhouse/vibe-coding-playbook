# Claude Code: Setup and Real Usage

## Setup (5 minutes)

Install:
```bash
npm install -g @anthropic/claude-code
# then
claude
```

The one thing that actually matters before you start: write a `CLAUDE.md` at your project root. See [setup/context-files.md](../setup/context-files.md).

Without `CLAUDE.md`, Claude knows nothing about your project and will make reasonable but wrong assumptions. With a good `CLAUDE.md`, it knows your stack, your patterns, what's off-limits.

---

## What to put in CLAUDE.md

**Good:**
```markdown
# Project: Chopsticks Discord Bot

Stack: Node.js, Discord.js v14, PostgreSQL, Redis
Entry: src/index.js
DB migrations: src/db/migrations/ (run with `npm run migrate`)

Architecture: each Discord command is a file in src/commands/. 
Economy system in src/economy/. Voice rooms in src/voice/.

Do not touch: src/legacy/ (deprecated, kept for reference only)
Test: npm test (jest, must pass before committing)
```

**Bad:**
```markdown
This is a Discord bot project built with modern web technologies.
It uses a database and has commands.
```

The bad version tells Claude nothing it couldn't guess. The good version saves 10 minutes of re-explaining per session.

---

## Commands that matter

| Command | When to use |
|---------|-------------|
| `/clear` | Switch focus areas. Clears context so Claude starts fresh for the next task. |
| `/checkpoint` | Before any complex multi-step task. Writes the current state so a fresh session can resume. |
| `Escape` | Stop Claude mid-response. Useful when it's going in the wrong direction. |

---

## Context limits: what actually happens

Claude Code has a context window. In long sessions, it starts dropping early context. Signs:
- Claude "forgets" something you established early in the session
- It starts making changes inconsistent with earlier decisions
- It asks you things you already told it

Fix: `/clear` between tasks. Use `CLAUDE.md` for things Claude needs to always know (it's re-read every session).

For session handoff (closing Claude Code and coming back later): run `/checkpoint` first. This writes a summary of what you were doing. Next session reads it automatically.

---

## Prompting patterns that work

**For bugs:**
```
I have an error: [paste full error + stack trace]
Here's the file it's coming from: [paste relevant code]
Don't guess. Read the stack trace and tell me the actual cause.
```

**For refactors:**
```
I want to [describe the change].
Before you code anything, tell me:
1. Which files you'll touch
2. What could go wrong
3. What you won't touch
Then wait for me to confirm.
```

**For new features:**
```
Feature: [describe it]
Constraints: [what it can't do, what it must use, performance requirements]
Start with the simplest possible implementation that satisfies the constraints.
No abstractions that aren't needed yet.
```

---

## Gotchas

**It will over-engineer.** You ask for a feature and it builds a framework. Be explicit: "Simplest implementation only. No abstraction layers unless required."

**It will clean up adjacent code.** You ask it to fix function A, it also refactors B and C. Tell it upfront: "Touch only the code required for this change."

**It will hallucinate file names.** Especially in large projects. Always verify that the files it references actually exist.

**It will write tests that pass without testing anything.** Review generated tests as carefully as generated code. A test that mocks everything is testing nothing.
