# Architecture Prompts

Prompts for system design and technical decisions.

---

## System design from requirements

**Use when:** Starting a new service or feature with unclear shape.
**Works with:** Claude Code, ChatGPT

```
I need to design [system/feature].

Requirements:
- [requirement 1]
- [requirement 2]
- [requirement 3]

Constraints:
- [hard constraint 1, e.g. "must be serverless"]
- [hard constraint 2, e.g. "can't use a database, only key-value store"]
- [scale constraint, e.g. "100 requests/second max"]

Give me:
1. The components and what each does
2. The data flow (what talks to what, in what order)
3. The 3 biggest design decisions and your reasoning
4. What could go wrong with this design at scale

Don't write code. Just the design.
```

---

## Simplest thing that works

**Use when:** The AI is proposing something too complex.
**Works with:** Claude Code, all

```
That's more complex than I need.

What's the simplest implementation that satisfies exactly these requirements:
[list only the actual requirements, not nice-to-haves]

No abstractions that aren't required. No extensibility for hypothetical future requirements.
If two approaches have the same outcome, pick the one with less code.
```

**Notes:** Use this when the AI's proposal has more moving parts than your use case justifies.

---

## Scaling bottleneck finder

**Use when:** Before shipping something that could get real traffic.
**Works with:** Claude Code, all

```
Here's my system design / the relevant code:
[paste architecture or code]

Current load: [describe current scale]
Expected load: [10x? 100x? describe the growth scenario]

Where does this break first?

Walk me through the bottlenecks in order:
1. What hits its limit first?
2. What's the fix or mitigation?
3. What does that buy you, and what breaks next?

I want to know what to fix now vs what can wait.
```

---

## Migration planning

**Use when:** Migrating from one technology, database schema, or architecture to another.
**Works with:** Claude Code, all

```
I need to migrate from [current state] to [target state].

Current state: [describe what exists]
Target state: [describe where you're going]
Constraints: [zero downtime? gradual rollout? data that can't be lost?]

Give me a migration plan:
1. What's the order of operations?
2. What can go wrong at each step?
3. What's the rollback plan if step N fails?
4. What do I need to test before, during, and after?

I don't need code yet. Just the plan.
```

---

## Service boundary decision

**Use when:** Deciding whether something should be one service or two.
**Works with:** Claude Code, ChatGPT

```
I have [describe the functionality]. I'm deciding whether to:

Option A: keep it as one service / module
Option B: split into [service 1] and [service 2]

Arguments for A: [your reasoning]
Arguments for B: [your reasoning]

Give me:
1. The principle that should guide this decision (not an opinion on my case)
2. Applied to my specific situation: which is right and why?
3. What would change your answer?
```

**Notes:** Asking for the principle first and then the application gets better reasoning than just "which should I pick."
