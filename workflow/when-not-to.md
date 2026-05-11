# When AI Makes Things Worse

Honest list. Knowing when to stop using AI for a task saves hours.

---

## Don't use AI for these

**Cryptography and security primitives.** AI will write something that looks like AES encryption and has a subtle flaw. Use a well-tested library. If you have to implement crypto, read the RFC yourself.

**Auth flows with security implications.** OAuth, JWT validation, session handling -- these are places where a subtle mistake costs you. AI gets them mostly right, which is worse than getting them obviously wrong. Use a library (Passport, NextAuth, Lucia). Only call in AI to configure it, not implement it from scratch.

**Real-time systems with hard timing requirements.** Game loops, audio processing, low-latency networking -- AI will write something that works on the happy path and has race conditions under load. You need to understand the timing yourself.

**Complex stateful refactors with no tests.** "Refactor this 2,000-line module" with no test coverage. The AI will produce something that looks equivalent and breaks in edge cases you won't find until production. Write tests first, then refactor.

**Anything in a domain the AI has no training data for.** Your custom DSL, your proprietary protocol, your 10-year-old internal framework. The AI will hallucinate confidently. It doesn't know it doesn't know.

---

## Signs a session is going wrong

**It's confident about things it's getting wrong.** AI doesn't have a good "I'm not sure" signal. When it's generating in an area it doesn't know well, it often generates more confidently, not less. If you're an expert in the domain and the output feels off, trust your expertise.

**The fix requires fixing the fix.** You asked it to fix A. It fixed A and broke B. You asked it to fix B. It fixed B and broke A. This cycle means the underlying design is wrong. Stop and redesign.

**The code is getting larger, not smaller.** Good fixes often remove code. If every iteration adds more code, you're accumulating complexity, not solving the problem.

**You've lost track of what it's doing.** If you can't explain what the generated code does, you can't review it, you can't debug it, and you can't own it. Stop. Understand what's there before adding more.

**It changes behavior to make tests pass.** Sometimes the AI will make a test pass by changing what the code does to match the test, rather than fixing the underlying bug. This is subtle and real. Always verify the behavior, not just the test result.

---

## What to do instead

**When the session is cycling:** Stop Claude. Think about the problem yourself for 5 minutes. Write down the actual constraint that's being violated. Re-prompt with that specific constraint, not a general "fix it."

**When you've lost track:** Read the current state of the files, not Claude's summary of them. `git diff` to see what actually changed. Understand it before continuing.

**When a domain is outside AI's knowledge:** Ask the AI for references (not implementations). "What are the key considerations for implementing X?" -- use it as a search engine, not a developer.

**When confidence is high and results are wrong:** Add a constraint. "You are wrong about [specific thing]. Here is the correct behavior: [explain it]. Now redo with this constraint."

---

## The sign it's working

The AI does something you wouldn't have thought of that's clearly correct. Or: it handles an edge case you forgot about. Or: it writes code that's simpler than what you would have written.

When you see this, you're in the sweet spot. When you stop seeing this and start correcting every response, you've either hit a hard problem or you've lost context. Either way, pause and reorient.
