# Keeping Context Across Sessions

The biggest invisible cost in AI-assisted development: re-explaining what you were doing.

You open a new Claude Code session. The AI knows nothing. You spend 10 minutes re-establishing context before you can write a line of code. Multiply that by 3 sessions a day and you're losing 30 minutes daily to re-bootstrapping.

Here's how to eliminate most of it.

---

## The checkpoint pattern

Before closing a long session, run `/checkpoint` (in Claude Code) or write this manually:

```markdown
## Session state [date]

What was being worked on:
[specific task and the file/function you were in]

What changed:
- [file] -- [what and why]
- [file] -- [what and why]

What broke:
[anything unexpected you hit]

Next:
1. [most important next thing]
2. [second thing]

Context a fresh agent needs:
[1-2 sentences of non-obvious context -- why a decision was made, what was tried and failed]
```

Save this as `~/.claude/checkpoints/latest.md`. New session reads it first.

---

## CLAUDE.md as living doc

Update `CLAUDE.md` when your project's architecture changes. If you added a new service, changed a convention, or discovered something off-limits -- add it.

A stale `CLAUDE.md` is worse than no `CLAUDE.md`. Claude will follow outdated rules.

Review it every few sessions. Should take 2 minutes.

---

## Signs context is decaying

- The AI makes changes inconsistent with earlier decisions in the same session
- It asks you things you already told it
- It introduces a pattern you explicitly told it not to use
- The suggestions start to feel "generic" -- like it forgot your project

When this happens: `/clear`, re-state the essentials, continue. Don't try to fix it by repeating yourself in the same context window.

---

## Cross-session handoff prompts

Starting a new session:
```
Read CLAUDE.md. Then read ~/.claude/checkpoints/latest.md if it exists.
Tell me what we were working on and what the next step is.
Don't add anything beyond what's in those files. Just confirm you have context.
```

This forces the AI to read your state before doing anything.

---

## Across tools (Claude Code to Cursor to Gemini)

If you switch tools mid-project, the context doesn't transfer automatically.

Minimal handoff:
1. Make sure `CLAUDE.md` (or equivalent) is up to date
2. Write a checkpoint file with current state
3. In the new tool's first message: "Read [context file] and [checkpoint file]. Tell me what we were working on."

For Cursor: paste the checkpoint content directly into the Composer context box. Cursor doesn't have a checkpoints system.

For Gemini CLI: point it at the checkpoint file: `cat ~/.claude/checkpoints/latest.md | gemini`.

---

## Recovering from context loss

If a session crashed, context blew up, or you lost track:

```
Something went wrong with our context. Let's reset.

Here's the current state of the relevant files:
[paste file contents or key sections]

Here's what I was trying to do:
[describe the goal]

Don't guess about what happened before. Work from what's here.
```

Starting clean from file state is always better than trying to reconstruct a corrupted context.
