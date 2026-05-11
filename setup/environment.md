# Environment Setup for AI-Assisted Development

Configuring your environment from day one changes how much the AI can help you. Most people skip this and pay for it later.

---

## The minimal setup that matters

**1. Context file at project root.** See [context-files.md](context-files.md). Do this before the first prompt.

**2. .gitignore that blocks secrets.** See [gitignore.md](gitignore.md). AI tools sometimes write secrets into code. Block them at the git level.

**3. A test command that works.** `npm test`, `pytest`, `cargo test` -- whatever runs your tests. Tell the AI what it is. The AI will run it to verify changes.

---

## WSL2 on Windows

If you're building on WSL2 (Linux on Windows), a few things matter:

**Path translation:** Windows paths (`C:\Users\...`) don't work in WSL. Use Linux paths (`/home/username/...`). Claude Code and Cursor are aware of this in most cases, but if you're passing paths in prompts, use Linux format.

**File watchers:** Some dev servers (Vite, Webpack) have trouble with file watchers across the WSL boundary. If hot reload is broken, check your tool's WSL-specific docs.

**Git config:** Set your git identity in WSL explicitly:
```bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

**Recommended: run everything in WSL.** Don't split Node.js in WSL and Cursor in Windows pointing at the same project. Pick one side.

---

## SSH keys and deploy keys

If your AI tool needs to push to GitHub or pull private repos:

**Personal repos:** add your SSH key to your GitHub account.

**Org repos:** use a deploy key per repo (read-only or read-write). Generate it:
```bash
ssh-keygen -t ed25519 -C "deploy-[project]" -f ~/.ssh/[project]_deploy -N ""
# Add the public key to GitHub: Settings > Deploy keys
```

**Org-level keys:** GitHub supports org-level SSH keys that propagate to all repos. Useful if you're managing many repos.

---

## Directory structure that helps

```
~/dev/
  [org-or-context]/
    [project-1]/
    [project-2]/
~/AGENTS.md          <- global context, AI reads this
~/CLAUDE.md          <- Claude Code session config
```

Keeping all projects under `~/dev/` means your AGENTS.md can reference them with predictable paths. It also makes session-brief scripts easier to write.

---

## What to gitignore for AI tools

See [gitignore.md](gitignore.md) for the full list. Short version: `.env`, `.claude/`, `*.local`, any file with credentials or API keys.

---

## Secrets management

**Never:** hardcode secrets in source files, even in comments, even "temporarily."

**Always:**
- `.env` file, gitignored
- In CI: use secrets manager (GitHub Secrets, Doppler, Vault)
- On VPS: environment variables set in Coolify/Dokku/etc., never in committed files

Tell your AI tool explicitly: "Do not write secrets, API keys, or credentials into any file. Use environment variables via process.env."

Put that in your CLAUDE.md. AI tools will still occasionally put a placeholder like `const API_KEY = "your-key-here"` in generated code. Review for this.
