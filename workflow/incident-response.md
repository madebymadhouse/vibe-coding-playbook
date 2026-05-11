# When Something Breaks in Production

Fast triage guide. Which tool to reach for and in what order.

---

## First: know your tools' actual capabilities

| Tool | Can SSH | Can hit APIs | Can run commands | Best for |
|------|---------|--------------|-----------------|----------|
| Claude Code | Yes (via Bash) | Yes (MCP servers) | Yes | Diagnosing + fixing |
| Cursor Composer | No | No | No | Writing fix code only |
| Copilot Chat | No | No | No | Talking through the fix |
| Gemini CLI | Yes (via shell) | No direct MCP | Yes | Large log analysis |

**For production incidents: Claude Code is the right tool.** It can SSH into your VPS, hit the Coolify API, read logs, and apply fixes in one session. Copilot and Cursor can help you write fix code but can't reach the infra.

---

## Triage checklist (first 2 minutes)

```
1. Is the process running?          docker ps | grep <app>
2. Is the port bound correctly?     docker ps --format '{{.Names}}\t{{.Ports}}'
3. Is the network reachable?        curl -s --max-time 3 http://<host>:<port>/healthz
4. What do the logs say?            docker logs <container> --tail 50
5. Did anything deploy recently?    git log --oneline -5 (or Coolify deployment log)
```

Run these before asking any AI anything. The AI is much more useful when you paste actual output.

---

## Prompt for Claude Code when something is down

```
Something is down. Here's what I know:

Service: [name]
Expected: [what it should do / where it should be reachable]
Actual: [what's happening / error message]

Output from my initial checks:
[paste docker ps output]
[paste curl output]
[paste relevant log lines]

Don't guess. Diagnose from this data and tell me:
1. What's wrong
2. The exact fix
3. How to verify it's fixed
```

---

## Prompt for Copilot / Cursor when you need fix code

Copilot can't reach your infra but it can help write the fix once you know what's wrong:

```
I have a production issue. I've diagnosed it: [describe the root cause].

Here's the relevant code / config:
[paste the file or section]

Write the fix. Keep it minimal -- only change what's required to fix this specific issue.
```

---

## Common patterns

**Port not bound:** Container is running but port isn't mapped to the expected interface.
```bash
# Check actual bindings
docker ps --format '{{.Names}}\t{{.Ports}}'
# Fix: update Coolify custom_docker_run_options and redeploy
# For Tailscale: -p 100.73.12.59:<external-port>:<internal-port>
```

**App healthy, not reachable via Tailscale:**
```bash
# Is Tailscale up on VPS?
tailscale status
ip addr show tailscale0
# Is the container bound to the Tailscale IP specifically?
docker ps --format '{{.Ports}}' | grep <tailscale-ip>
```

**Coolify says healthy but it's not:**
Coolify's health check hits the container directly, not via your public interface. The app can be healthy to Coolify and unreachable to you if the port binding or network path is wrong.

**Container restarting repeatedly:**
```bash
docker logs <container> --tail 100
docker inspect <container> | grep -A5 RestartPolicy
# Usually: missing env var, failed migration, or port conflict
```

**After a bad deploy:**
```bash
# In Coolify: roll back to previous deployment (Deployments tab)
# Or: revert the commit and push -- Coolify auto-deploys
git revert HEAD
git push
```

---

## Setting up for faster recovery

Things that make the next incident faster to resolve:

1. **Runbook per service** in `docs/RUNBOOK.md` -- health check URL, restart command, log location, common failures. See [prompts/docs.md](../prompts/docs.md) for the runbook generation prompt.

2. **copilot-instructions.md** in `.github/` -- so any AI tool you open in the repo immediately knows the deployment target, stack, and access method.

3. **Health endpoint in every service** -- even a simple `GET /healthz` that returns 200. Makes `curl` triage instant.

4. **Claude Code with MCP servers configured** -- if you have Coolify MCP and SSH access wired up, Claude Code can diagnose and fix infra issues in a single session without you having to copy-paste docker commands.
