# Documentation Prompts

Prompts for generating useful documentation from existing code.

---

## README from codebase

**Use when:** You have a working project with no README (or a bad one).
**Works with:** Claude Code

```
Read the codebase and write a README.md.

The README should:
1. Start with what this does (1-2 sentences, from a user's perspective)
2. Show how to get it running (setup + first command)
3. Show the most common usage (real command or code example)
4. List configuration options that matter (not all of them -- the important ones)
5. Link to anything else that needs explaining

Do not:
- Write motivational copy ("this is a powerful tool...")
- List every option in a massive table
- Explain things the code already makes obvious

Length: as short as possible while being complete.
```

---

## API documentation

**Use when:** You have functions or endpoints that need docs.
**Works with:** Claude Code, all

```
Write documentation for this API / these functions:

[paste function signatures and types, or endpoint definitions]

For each function/endpoint:
1. What it does (1 sentence)
2. Parameters: name, type, what it means, whether it's required
3. Return value: type and what it contains
4. Error cases: what it throws/returns on failure and why
5. One usage example

Don't explain implementation details. Document the interface.
```

---

## Runbook from ops context

**Use when:** You need incident response docs for something you're running.
**Works with:** Claude Code, all

```
Write a runbook for [service or system].

Context:
- What it does: [describe]
- Where it runs: [VPS, Coolify, K8s, etc.]
- How to access it: [SSH command, admin URL, etc.]
- What it depends on: [database, external APIs, etc.]

The runbook should cover:
1. Health check: how to verify it's working
2. Common failure modes and their symptoms
3. How to restart it
4. How to check logs
5. Escalation: what to do if the normal fixes don't work

Write it for someone who knows the tech but doesn't know this system.
```

---

## CHANGELOG from git log

**Use when:** You need a changelog for a release.
**Works with:** Claude Code (can run git commands)

```
Run git log --oneline [from_tag]..[to_tag] (or last 20 commits if no tags).

From the commit messages, write a CHANGELOG entry.

Format:
## [version or date]

### Added
- [new features]

### Changed
- [changes to existing behavior]

### Fixed
- [bug fixes]

Group commits by type. Skip "chore:", "refactor:", "wip:", and similar non-user-facing commits.
Write each entry from the user's perspective, not the developer's.
"Fixed crash when user has no avatar" not "Fix NPE in AvatarLoader".
```
