# Code Review Prompts

Prompts for reviewing AI-generated and human-written code.

---

## Security review

**Use when:** Any feature touching user input, auth, or external data.
**Works with:** Claude Code, all

```
Review this code for security issues:

[paste code]

Check specifically:
1. SQL injection: is user input ever passed directly to a query?
2. XSS: is user input ever rendered into HTML without sanitization?
3. Secrets: are any credentials, API keys, or tokens hardcoded?
4. Auth: are there operations that need auth checks but don't have them?
5. Error messages: do any errors expose internal state, stack traces, or sensitive data?

For each issue found: severity (critical/high/medium/low), the specific line, and the fix.
If nothing is found, say so and why you're confident.
```

---

## What breaks in production

**Use when:** Before shipping any new feature.
**Works with:** Claude Code, all

```
I'm about to ship this code:

[paste code or describe the feature]

Tell me the ways this breaks in production that won't show up in local testing:

1. Load: what fails when there are 1000 concurrent users instead of 1?
2. Network: what fails when an external call is slow or returns an error?
3. Bad input: what fails when a user sends unexpected data (empty, too long, wrong type, malicious)?
4. State: what fails if this runs twice (double-click, retry, race condition)?
5. Permissions: what fails if the user doesn't have the expected access?

For each: what fails, how, and what's the fix or mitigation?
```

---

## Performance review

**Use when:** Feature is working but you suspect it'll be slow at scale.
**Works with:** Claude Code, all

```
Review this code for performance issues:

[paste code]

Look for:
1. N+1 queries: database calls inside loops
2. Missing indexes: queries filtering on un-indexed columns
3. Unnecessary re-renders: (for frontend) state changes causing full re-renders
4. Memory leaks: objects or listeners that aren't cleaned up
5. Blocking operations: sync operations that should be async

For each issue: what it is, where it is, and the fix.
```

---

## Test coverage gaps

**Use when:** You have tests but want to know what's missing.
**Works with:** Claude Code, all

```
Here are my tests:
[paste test file]

Here is the code being tested:
[paste implementation]

What's not tested?

Look for:
1. Error paths and exception cases
2. Edge cases for inputs (empty, null, maximum, minimum)
3. Concurrent access scenarios
4. Integration points with external services
5. State that changes between calls

Give me the 3 most important missing test cases as actual test code, not descriptions.
```

---

## API contract review

**Use when:** You changed an API and need to verify callers aren't broken.
**Works with:** Claude Code, all

```
I changed this API/function:

Before:
[paste old signature/behavior]

After:
[paste new signature/behavior]

Here are the callers:
[paste caller code or file list]

Is this change backwards compatible?
If not: which callers break and what do they need to change?
```

---

## Self-review prompt

**Use when:** Right after Claude generates code, before you review it.
**Works with:** Claude Code

```
Before I review this: review it yourself.

Look for:
1. Assumptions you made that might be wrong
2. Edge cases you didn't handle
3. Anything you're not confident about
4. Places where the code could break that aren't obvious

Be specific and honest. If something is uncertain, flag it.
```

**Notes:** This surfaces AI uncertainty before you invest time in reviewing. If the AI flags something, check it first.
