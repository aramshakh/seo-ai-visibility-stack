# 3. Elmo: self-hosted AI-mention tracking

Elmo answers three questions per prompt and per AI surface: **is our brand mentioned, who is mentioned instead, and which URLs are cited.**

## Install

```bash
npm i -g @elmohq/cli && elmo init --dir /root/elmo-local
# renders /root/elmo-local/elmo.yaml and .env
```

## `.env`: the required part

```dotenv
DATAFORSEO_LOGIN=…
DATAFORSEO_PASSWORD=…
OPENROUTER_API_KEY=…
SCRAPE_TARGETS=chatgpt:dataforseo:online,google-ai-mode:dataforseo:online,google-ai-overview:dataforseo:online,claude:openrouter:anthropic/claude-sonnet-5:online
DEFAULT_DELAY_HOURS=168      # once a week; the default is 24, which is 7× the cost
APP_URL=http://localhost:1515
```

A full example is in [`templates/elmo.env.example`](../templates/elmo.env.example).

Supported surfaces: `chatgpt, claude, gemini, perplexity, copilot, grok, deepseek, google-ai-mode, google-ai-overview`.

**AI Overview ≠ AI Mode.** Overview is the summary shown above regular results to everyone; Mode is a separate tab a user has to pick. Overview matters more.

## `elmo.yaml`: two manual edits

1. `ports:` on both `postgres` and `web` → `127.0.0.1:5432:5432` and `127.0.0.1:1515:3000`.
2. **The file is rendered by the CLI** (header says "Rendered by Elmo CLI"). Any `elmo …` command **rewrites it** and the ports snap back to `0.0.0.0`. After every CLI command, re-check `ports:`. Keep a backup copy.

## Pitfall #2: Postgres rejects a password that is identical everywhere

Symptom: `28P01 password authentication failed`, yet the password in `.env`, in compose, and in the container's environment is the same.

Cause: `POSTGRES_PASSWORD` is applied **only when the data volume is first created.** If the volume was created earlier with a different password, the env var is ignored forever.

Fix without deleting the volume:

```bash
docker exec elmo-postgres-1 psql -U postgres -d elmo -c "ALTER USER postgres PASSWORD '<password from .env>';"
docker restart elmo-web-1 elmo-worker-1
```

The local socket inside the container is `trust`, so the first command runs without a password.

## Onboarding in the UI: what it gets wrong

First visit to `localhost:1515` creates the admin user. **The owner does this**; it is an account.

The onboarding wizard then **auto-generates ~28 prompts.** Two problems:

- They are phrased as search keywords (`ff&e specification software`), not as questions a person asks an assistant.
- **Four of them contain the brand name** (`<brand>.ai vs …`). Those guarantee a "mention" and **inflate the metric.** In our deployment, all 7 of 7 recorded mentions came from these; honest prompts scored 0.

Do this immediately:

```sql
-- disable self-referencing prompts (don't delete: runs are linked to them)
update prompts set enabled=false where brand_id='<brand>' and value ilike '%<brand-name>%';
```

Then load your own prompts (next section) and add missing competitors:

```sql
insert into competitors (brand_id, name, domains) values ('<brand>', '<Competitor>', '{competitor.com}');
```

## 3.1 How to write prompts (they are not keywords)

- **A prompt is a question a human asks an assistant**, not a Google keyword. Not `ai room design`, but "What AI app can redesign my living room?"
- Prompts have no search volume. Keywords tell you the **topic**; you write the wording like a person would.
- Exactly **one** control prompt that names the brand ("What is <X>?") as a baseline. Every other prompt is brand-free.
- 15–20 prompts is enough. Groups:
  - **category** ("best tools for …")
  - **brand-intent patterns** (`is <X> free`, `<X> review`, `<X> pricing`)
  - **"our job"**, a bet on how people describe the task when no keyword data exists
  - **control** (the one branded prompt)
  - **probe** (an adjacent question you expect to lose, to see who wins it)

Note: consumer-side `<X> alternative` prompts were dead in our data; `is X free / X review / X pricing` were alive.

## Price and cycle

| Surface | Per request |
|---|---|
| ChatGPT / AI Mode / AI Overview via DataForSEO | **$0.0041** |
| Claude via OpenRouter with `:online` | **$0.054** (81% of spend for 25% of coverage) |

16 prompts × 4 surfaces ≈ **$1.06 per cycle.** At `DEFAULT_DELAY_HOURS=24` that is $7.40/week; at 168 it is $1.06/week.

Two behaviours that look like bugs and aren't:

- After topping up an empty OpenRouter balance, Elmo **catches up all failed runs at once**: a one-time spike of 3–4× normal spend.
- A new OpenRouter account is limited to **20 requests/min** on `claude-sonnet-5`; some runs fail with 429 and retry on their own.

## What to read after the first cycle

```sql
-- mentions per surface
select model, count(*), sum(brand_mentioned::int) from prompt_runs group by 1;

-- who gets named instead of you
select c, count(*) from prompt_runs, unnest(competitors_mentioned) c group by 1 order by 2 desc;

-- who gets cited (which sites the assistants read)
select split_part(replace(url,'https://',''),'/',1) d, count(*) from citations group by 1 order by 2 desc limit 15;
```

Also in [`templates/elmo-queries.sql`](../templates/elmo-queries.sql).

**The third query is the most valuable output of the whole stack.** It is the list of sites you need to be on (directories, listicles). It is also where we found a competitor that had not appeared in any prior research.

Next: [OpenSEO](04-openseo.md)
