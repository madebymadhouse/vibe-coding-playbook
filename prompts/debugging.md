# Debugging Prompts

Prompts that actually help find and fix bugs.

---

## Stack trace analysis

**Use when:** You have an error with a stack trace and want root cause, not guesses.
**Works with:** Claude Code, all

```
I have this error:

[paste full error message and stack trace]

Here is the relevant code:
[paste the file or function it's pointing to]

Do not guess. Read the stack trace.
Tell me:
1. The exact line causing the error
2. Why it's causing it (not what the error says -- why it's happening)
3. The fix

If you're not sure about something, say so instead of guessing.
```

**Notes:** "Do not guess" and "if you're not sure, say so" together cut down on confident-but-wrong answers significantly.

---

## Rubber duck debugging

**Use when:** Something is broken and you can't figure out why. Forces you to explain the problem, which often reveals the answer.
**Works with:** All

```
I'm debugging [describe the problem]. Help me think through it.

Here's what I know:
- [what the code should do]
- [what it actually does]
- [what I've already tried]
- [what I ruled out]

Ask me questions until we find the cause. Don't suggest fixes yet.
```

**Notes:** The "ask me questions" instruction keeps the AI from jumping to solutions. Often the act of answering the questions reveals the bug.

---

## Five possible causes

**Use when:** You have a bug and don't know where to start.
**Works with:** All

```
I have a bug: [describe the behavior]

Here's the context:
[paste relevant code or describe the system]

Give me 5 possible causes, from most to least likely.
For each cause:
1. Why it might cause this behavior
2. How to test if it's the cause (a specific check or log, not just "look at the code")

Don't fix anything yet. Just the causes and how to test them.
```

**Example output quality:**
```
1. Race condition in async handler (most likely)
   Test: add console.log with timestamps before and after the await. 
   If the second log fires before the first, you have overlap.

2. Stale closure over event listener
   Test: log the value inside the closure vs outside. 
   If they differ, it's a stale reference.
...
```

---

## Environment vs code bug separator

**Use when:** Something works locally but not in production (or vice versa).
**Works with:** Claude Code, all

```
This works in [environment A] but breaks in [environment B].

In A: [describe what works]
In B: [describe what breaks, include error if any]

Things that differ between environments:
- [difference 1, e.g. "Node version: 20 vs 18"]
- [difference 2, e.g. "environment variables: .env vs CI secrets"]
- [difference 3]

Is this a code bug or an environment difference?
If it's environment: what specifically is causing it?
If it's code: what assumption am I making that's only true in one environment?
```

---

## Async/timing bug detector

**Use when:** Something fails intermittently or behaves differently on repeated runs.
**Works with:** Claude Code, all

```
I have an intermittent bug. Sometimes it works, sometimes it doesn't.

Here's the code:
[paste relevant async code]

Symptoms:
[describe when it fails and when it works]

Look for:
1. Race conditions (two async operations that can arrive in either order)
2. Missing awaits
3. Shared mutable state between async operations
4. Event listeners registered multiple times

Tell me what you find and which is most likely.
```

---

## "What changed recently"

**Use when:** Something broke and you don't know when or why.
**Works with:** Claude Code (can run git commands)

```
Something broke recently. I don't know when.

Run git log --oneline -20 and tell me which commits are most likely to have caused [describe the symptom].

For the 2-3 most suspicious commits, what should I check?
```

---

## Type error decomposer

**Use when:** TypeScript or Python type errors that are hard to read.
**Works with:** Claude Code, all

```
I have this type error and I can't parse it:

[paste the full type error]

Here's the relevant type definition:
[paste types]

Here's the code that's failing:
[paste code]

Explain what the error is actually saying in plain English.
Then tell me the minimal change that fixes it without widening the types unnecessarily.
```
