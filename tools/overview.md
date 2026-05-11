# Tool Overview: Honest Comparisons

Nobody tells you when to switch tools. This page does.

---

## The short version

| Tool | Best for | Worst for | Cost |
|------|----------|-----------|------|
| Claude Code | Multi-file changes, architecture, long context | Fast autocomplete | $20/mo (Pro) or API |
| Cursor | Inline edits, autocomplete, composer | Deep multi-file understanding | $20/mo |
| Windsurf | Flow sessions, inferring intent from context | Complex architecture decisions | $15/mo |
| GitHub Copilot | IDE autocomplete, boilerplate | Anything requiring full project context | $10/mo |
| Gemini CLI | Large context dumps, Google integrations | Tool use, execution, speed | Free tier / API |

---

## Claude Code

**Wins at:** understanding your whole project, making surgical changes across 10+ files, not breaking things it didn't touch, long refactors that require holding a lot of state.

**Loses at:** being fast. Claude Code is slow compared to autocomplete tools. It's not meant for "add a semicolon" -- it's meant for "rework how this service handles authentication."

**When to use it:**
- You're making a change that touches more than 3 files
- You need to understand why something is broken before fixing it
- You're doing a refactor that has to be correct (not just fast)
- You're working on architecture and want a second opinion that knows your codebase

**Setup that matters:** Write a `CLAUDE.md` at the root. See [setup/context-files.md](../setup/context-files.md). Without it, Claude knows nothing about your project. With a good one, it's a senior engineer who's read all your code.

**Gotcha:** Context limits. For very large sessions, Claude Code will start dropping early context. Use `/checkpoint` before long tasks and `/clear` when you switch focus areas.

---

## Cursor

**Wins at:** autocomplete that actually knows your codebase (not just the current file), Composer for focused multi-file edits, fast iteration.

**Loses at:** deep cross-file understanding. Composer is good but it's not Claude-level reasoning. If your change requires understanding 15 files and their interactions, Cursor will hallucinate.

**When to use it:**
- You know exactly what you want to change and where
- You're doing repetitive edits (rename, restructure, add similar patterns)
- You want autocomplete that doesn't embarrass itself

**Setup that matters:** `.cursorrules` file. See [setup/context-files.md](../setup/context-files.md). Cursor reads this before any composer task.

**Gotcha:** Cursor's Composer will confidently make changes that look right but aren't. Always review the diff before accepting, especially for logic changes.

---

## Windsurf

**Wins at:** staying in flow. Windsurf's Cascade mode watches what you're doing and anticipates the next step. Good at inferring intent from the context of your session.

**Loses at:** complex architecture decisions. Windsurf is better at "continue what I'm doing" than "here's a hard problem, figure it out."

**When to use it:**
- You're in a long coding session and want an AI that keeps up with your momentum
- You know the general direction and want the AI to fill in details

**Gotcha:** Windsurf can over-infer. It sometimes "helps" in directions you didn't intend. Pay attention when it surprises you.

---

## GitHub Copilot

**Wins at:** boilerplate in familiar territory. Writing a new Express endpoint that looks like your existing endpoints, it's fast and correct. Good in JetBrains and VS Code.

**Loses at:** anything requiring project context. Copilot sees the current file and maybe a few related ones. It has no idea about your architecture, your patterns, or why things are structured the way they are.

**When to use it:**
- You're in an IDE and want fast inline suggestions
- The pattern you're writing is straightforward and repetitive

**Gotcha:** Copilot will confidently write code that looks right and is logically wrong. It's good at form, bad at correctness for non-trivial problems.

---

## Gemini CLI

**Wins at:** context window. Gemini 1.5 Pro can take enormous context dumps -- your entire codebase, logs, error messages, all at once. Good for analysis of large bodies of text.

**Loses at:** tool use and execution speed. Gemini CLI is slower than Claude Code and less capable with code execution and multi-step tasks.

**When to use it:**
- You need to analyze a very large codebase that breaks Claude Code's context
- You're doing analysis or summarization, not execution
- You want a second opinion from a different model

**Gotcha:** Gemini's responses are often longer than they need to be. Budget your prompts accordingly.

---

## When to switch tools mid-project

**Switch to Claude Code when:**
- You have a bug you can't isolate and need deep reasoning
- You're about to make a large refactor
- Something is wrong and you don't know why

**Switch to Cursor when:**
- You know exactly what needs to change and where
- You want speed over depth

**Switch to raw ChatGPT/Claude.ai when:**
- You want to brainstorm without touching code
- You want to explain a problem to something that has no context, and see what it says

**Stop using AI and think yourself when:**
- You've made the same change 3 times with AI and it keeps breaking
- You're security-critical (cryptography, auth primitives, payment flows)
- The AI is confidently wrong and you can tell it's pattern-matching instead of reasoning
