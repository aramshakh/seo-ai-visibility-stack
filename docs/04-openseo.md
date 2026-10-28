# 4. OpenSEO: self-hosted rank tracking

## Install

```bash
git clone https://github.com/every-app/open-seo /root/open-seo
mkdir /root/open-seo-local && cp /root/open-seo/compose.yaml /root/open-seo/.env.example /root/open-seo-local/
```

`.env` (full example in [`templates/openseo.env.example`](../templates/openseo.env.example)):

```dotenv
DATAFORSEO_API_KEY=<base64 "login:password">
OPENROUTER_API_KEY=…            # onboarding chat and the SAM agent; shared balance with Elmo: when it runs out, both stop
OPENROUTER_MODEL=anthropic/claude-sonnet-4
BETTER_AUTH_SECRET=<openssl rand -base64 48>   # ≥32 chars; required for the GSC integration
AUTH_MODE=local_noauth           # no authentication at all: NEVER expose this to the internet
PORT=3001
```

```bash
docker compose -f compose.yaml --env-file .env up -d
curl -s http://127.0.0.1:3001/api/health    # allow up to 90 s
```

OpenSEO's compose already binds to `127.0.0.1:`. It was the only one of the three tools that did this out of the box; still verify as described in [Server hardening](02-server-hardening.md).

## First login and project

The first login creates the user and the organisation. **The owner does this** (open `localhost:3001` through the tunnel). A project named "Default" appears automatically. Everything after that goes through [MCP](05-openseo-mcp-agent.md); no clicking required.

One thing MCP cannot do: **rename the project and set its domain.** That is UI-only. Not critical: the rank tracker sets the domain itself.

## The database: D1 (SQLite inside the volume)

```
/app/.wrangler/state/v3/d1/miniflare-D1DatabaseObject/<hash>.sqlite
```

Reading: `docker cp` the file out and open it with `sqlite3` or Python.

**Writing: only with the container stopped.** `compose stop` → `docker cp` out → edit → `docker cp` back → `compose start`.

This is how you change the tracker schedule, because MCP has no `update` tool for it: table `rank_tracking_configs`, column `schedule_interval`, and `next_check_at` in ISO format (`2026-09-10T06:30:00.000Z`).

Next: [OpenSEO ↔ agent over MCP](05-openseo-mcp-agent.md)
