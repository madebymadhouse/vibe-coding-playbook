# Case Study: Chopsticks (Discord Bot)

Chopsticks is a self-hosted Discord bot with a coin economy, shop system, and dynamic voice rooms. Built over 3 sessions with Claude Code.

Repo: [madebymadhouse/chopsticks](https://github.com/madebymadhouse/chopsticks)

---

## What we built

- Coin economy: earn coins from activity, spend in shop
- Shop system: buyable items with persistent effects
- Dynamic voice rooms: users create private voice channels, auto-destroy when empty
- Admin commands: manage economy, view stats, reset users
- PostgreSQL persistence, Redis for rate limiting

---

## Session 1: What went wrong

**First prompt:**
```
Build me a Discord bot with an economy system using Discord.js and PostgreSQL.
```

**What we got:** A complete Economy class. Full earn/spend/transfer/history methods. Database schema. Clean code.

**What was wrong:** No Discord integration. No commands that called the Economy class. No way to run it. The AI built a beautiful isolated module with no entry points.

**How long to fix:** 45 minutes in session 2, because we had to retrofit the command structure and found 3 interface mismatches between what the Economy class expected and what Discord.js provides.

**Better first prompt:**
```
I'm building a Discord bot using Discord.js v14 and PostgreSQL.
Stack: Node.js 20, pg library (not an ORM), Discord.js v14.

First, before any code:
1. Show me the file structure you'd use
2. What does the main index.js do?
3. How do Discord slash commands get registered and handled?

Then build ONE slash command end to end: /coins [user] that returns their balance.
Use a real database query. No mocks.
```

This produces a working slice. Economy class comes in session 2 after we know the skeleton is right.

---

## Session 2: The architecture conversation that saved the project

We needed private voice rooms. User creates one, it's theirs, auto-destroys when empty.

**What the AI wanted to do:** Build a voice room "manager" class with a factory pattern, event system, and persistence layer.

**What it needed to be:** A Discord voice channel with permission overwrites. When the last person leaves, delete it.

The AI was building for extensibility we didn't need. Push:
```
We're not building a framework. We need one specific behavior:
- User runs /room
- Bot creates a voice channel, gives user owner permissions
- When the channel empties, bot deletes it
- That's it

No manager class. No factory. No event bus.
What's the minimal code that does exactly this, and nothing more?
```

The answer was 60 lines. The first answer would have been 400.

---

## The 2am break

Chopsticks was deployed and working. At 2am: voice rooms stopped auto-deleting.

Error in logs:
```
DiscordAPIError[50013]: Missing Permissions
    at SequentialHandler.runRequest
```

**The debugging prompt that worked:**
```
I have this error in production:
DiscordAPIError[50013]: Missing Permissions

It's happening when the bot tries to delete a voice channel.
The bot has MANAGE_CHANNELS permission in the server settings.

Here's the voiceStateUpdate handler:
[pasted the actual handler code]

Don't guess. Read the code and the error. What's the actual cause?
Tell me before you write any fix.
```

Claude's analysis: the bot was trying to delete channels in a category where it didn't have explicit permission -- server-level permissions weren't inheriting into that specific category.

Fix: add permission check before creating rooms, create them in a category where the bot has explicit MANAGE_CHANNELS.

Two lines changed. 45 minutes of debugging eliminated by using the right prompt.

**What didn't work:**
```
My bot can't delete voice channels. Help.
```

First response: "Make sure your bot has MANAGE_CHANNELS permission." Which it did. Useless.

The key: paste the actual error, paste the actual code, say "don't guess."

---

## What the AI got right

- Database schema for the economy: it correctly normalized transactions vs balances (separate tables) without being asked
- Discord.js event handler structure: it knew the v14 patterns without being told the version mattered
- Error handling for Discord API limits: it added rate limiting logic we wouldn't have written first pass

---

## What the AI got wrong

- Over-engineered the shop system: added a plugin architecture for item effects that we never used, had to strip it out
- Wrote raw SQL strings instead of parameterized queries in 3 places (SQL injection risk): caught in review
- Generated tests that mocked the database and tested nothing real: had to rewrite all tests to use a test database

---

## Lessons

1. **Build a working slice first.** Not a layer. A feature that runs.
2. **"Don't guess" in debugging prompts gets you root cause, not random fixes.**
3. **Review for SQL injection every time.** Claude gets it right most of the time. Not always.
4. **Push back on complexity.** The AI defaults to extensible. You want minimal.
5. **Tests that mock the database are not tests.** Delete them and write real ones.
