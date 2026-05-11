# Setup Prompts

Prompts for starting a project right.

---

## Project decomposition

**Use when:** You have a vague goal and need to break it into buildable pieces before touching code.
**Works with:** Claude Code, Cursor Composer, ChatGPT, all

```
I want to build: [describe your goal in 1-2 sentences]

Before I write any code, help me decompose this into 5-8 discrete, buildable pieces.
For each piece:
1. What it does (1 sentence)
2. What it depends on (other pieces, libraries, external services)
3. What's unknown or risky about it

Then: what order should I build them in, and why?
```

**Notes:** The order is what matters. The AI will often suggest a more logical build order than you'd assume. Push back if the order doesn't feel right.

---

## Context file bootstrap

**Use when:** Starting a new project and need a `CLAUDE.md` quickly.
**Works with:** Claude Code

```
I'm starting a new project. Help me write a CLAUDE.md that gives you the right context for every future session.

Project name: [name]
What it does: [1-2 sentences]
Stack: [language, framework, key libraries]
Entry point: [main file or start command]
Test command: [how to run tests]

Write a CLAUDE.md that's concise (under 20 lines), factual, and gives you what you need without fluff.
```

**Example output:**
```markdown
# Kinetrak

Real-time body pose estimation. Browser only. No server.
Stack: Vanilla JS, MediaPipe Pose Landmarker (CDN), HTML5 Canvas
Entry: index.html
Test: n/a (visual verification)

Architecture: single-page, no build step. Camera access via getUserMedia.
Pose estimation via MediaPipe in main thread (workers not supported).
Canvas overlays video element, both same dimensions.

Off-limits: no server components, no data uploads, no frameworks.
```

---

## Architecture first pass

**Use when:** Before writing any code for a feature.
**Works with:** Claude Code, ChatGPT

```
I want to add [feature] to [project].

Before you write any code:
1. Which files will you touch?
2. What are the 2-3 biggest design decisions and your recommendation for each?
3. What are the ways this could go wrong?
4. What assumptions are you making about the existing code?

Wait for my confirmation before writing any implementation.
```

**Notes:** The "wait for confirmation" line is important. Without it, Claude Code will give you the architecture and then immediately start implementing it.

---

## Tech stack selection

**Use when:** Choosing between options before committing.
**Works with:** Claude Code, ChatGPT

```
I need to choose between [option A] and [option B] for [use case].

My constraints:
- [constraint 1, e.g. "must run on Cloudflare Workers"]
- [constraint 2, e.g. "team knows TypeScript, not Rust"]
- [constraint 3, e.g. "can't pay for managed services"]

For each option:
1. Why it fits my constraints
2. Why it doesn't
3. What I'd regret about it in 6 months

Don't recommend. Give me the honest tradeoffs and let me decide.
```

**Notes:** "Don't recommend" is key. The AI defaults to recommending. You want the honest comparison, not a confident pick.

---

## First working slice

**Use when:** After architecture is confirmed, to build the first runnable thing.
**Works with:** Claude Code

```
Let's build the first slice: [feature name].

This should be a complete vertical feature -- from [entry point, e.g. "user command"] to [output, e.g. "database write and response"].

Constraints:
- No abstractions beyond what this slice requires
- Must actually run (no mocked services unless specified)
- Test command: [your test command]

Build it. Then run the tests and tell me what passes.
```
