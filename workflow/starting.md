# Starting a Project with AI

The most common mistake: opening your AI tool and typing "build me a Discord bot." What you get back is a generic Discord bot. Not yours, not shaped to your needs.

Here's a better approach. It takes 15 extra minutes upfront and saves hours later.

---

## Step 1: Decompose before you prompt

Before you open Claude Code or Cursor, write down:

1. What does this thing do? (1-3 sentences, from the user's perspective)
2. What are the 5-7 discrete pieces it needs to work?
3. Which pieces are unknown (you're not sure how to build them)?
4. What constraints matter (must use Postgres, must run on Cloudflare Workers, must be free tier)?

This is not a full spec. It's 10 minutes with a text file.

**Example for chopsticks:**
```
What it does: Discord bot for a gaming server. Users earn coins by chatting, 
can buy upgrades, and have private voice rooms.

Pieces:
1. Discord.js event handling (messages, interactions, voice)
2. Economy: earn/spend/transfer coins (needs persistence)
3. Shop: items with effects, buy transaction
4. Voice room: per-user private VC, auto-create/destroy
5. Admin commands: give coins, reset user, view stats

Unknown: how Discord voice channel permissions work programmatically
Constraints: must run on a VPS (not serverless), Postgres for economy data
```

Now you have something specific to give the AI.

---

## Step 2: Write your context file first

Before the first code prompt, create `CLAUDE.md`. See [context-files.md](../setup/context-files.md) for the format.

At minimum: stack, entry point, test command, project structure (2 sentences), off-limits.

---

## Step 3: Architecture pass, not code

Your first prompt should produce structure, not code:

```
I'm building [project description from your decomposition].

Constraints: [list them]

Before writing any code, give me:
1. The file structure you'd use
2. The 3 biggest technical decisions and your recommendation for each
3. What you'd build first and why

Don't write code yet. Just the architecture.
```

Review the architecture response. Push back on anything wrong. This is much cheaper than reviewing wrong code.

---

## Step 4: Build in slices, not layers

Don't build "the database layer" then "the business logic" then "the API." Build a complete vertical slice: one feature, end to end, working.

For chopsticks: first pass was "a single command that gives coins and reads them back, with Postgres persistence." Not the full economy. Just one command that proved the database was wired up and commands were registered.

A working slice tells you whether your architecture assumptions were right. A working "database layer" tells you nothing until something uses it.

---

## Step 5: After each slice, verify

Before moving to the next slice:
```bash
npm test   # or your test command
git add .
git commit -m "feat: [slice description]"
```

Commit at each working state. Not as a discipline exercise -- because the AI will break things and `git diff` is how you find out what.

---

## What the first session actually looks like

```
Session 1:
- Write CLAUDE.md (10 min)
- Architecture pass prompt (get structure, push back on 2 things)
- Scaffold the file structure
- First vertical slice: [the simplest feature that proves the stack works]
- Tests for that slice
- Commit

Output: a working skeleton with one real feature. Tests pass.
Not 500 lines of boilerplate. Not a half-built feature. A working thing you can demo.
```

---

## When chopsticks went wrong

The first session on chopsticks produced the economy module in isolation: a full class with earn/spend/transfer/history, no Discord integration, no database migrations, no commands that called it.

Looked good. Was useless. You couldn't run it.

The second session had to wire it all together and found 3 interface mismatches. 45 minutes of fixes that wouldn't have been needed if the first session had built a full slice instead.

Lesson: always build to something runnable. The AI has a bias toward building full systems from the bottom up. Push back on this.
