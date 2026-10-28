# SEO + AI Visibility Stack

**A self-hosted playbook for tracking how a product ranks in Google *and* whether AI assistants (ChatGPT, Google AI Overview / AI Mode, Claude) mention it.** Built from a real deployment; ships with every pitfall we hit so you don't have to.

> **OpenSEO is so you get found. Elmo is so you get named.**
> AI visibility is **not** a separate, cheaper track: the assistants cite the same directories and content sites that give you backlinks. One track, two instruments.

Costs about **$2.50 per week** to run at weekly cadence for a ~100-keyword, ~16-prompt project. Fits on a 2 vCPU / 4 GB server next to an agent.

---

## What's in the stack

Four instruments. You open two of them; the other two you only pay.

| Tool | Role | You open it? | Cost |
|---|---|---|---|
| **[OpenSEO](https://github.com/every-app/open-seo)** (self-hosted) | Google positions for a keyword basket, competitors, Search Console inside, MCP server for an agent | yes | DataForSEO data |
| **[Elmo](https://www.npmjs.com/package/@elmohq/cli)** (self-hosted) | Does ChatGPT / Google AI Overview / AI Mode / Claude name your product? Who gets named instead? Who gets cited? | yes | DataForSEO + OpenRouter |
| **[DataForSEO](https://dataforseo.com)** | Data supplier for both: SERPs, volumes, ChatGPT / AI Overview scraping | no | pay-as-you-go, $50 minimum deposit |
| **[OpenRouter](https://openrouter.ai)** | Model access for Elmo (Claude) and for the OpenSEO agent | no | from $10 |

Plus: **Google Search Console** via a service account (for the agent) and via OAuth (for OpenSEO); an **agent** (we used Hermes) that talks to OpenSEO over MCP; **Gmail API** for outreach.

---

## Quick start: one day, in order

1. **Owner:** create the accounts in [Prerequisites](docs/01-prerequisites.md); set up a password-manager vault and a service-account token for the agent.
2. **Agent:** install [Elmo](docs/03-elmo.md) → lock ports to loopback → replace the generated prompts with your own → run one cycle → run the SQL → get the **"who gets cited" list**.
3. **Agent:** install [OpenSEO](docs/04-openseo.md) → owner does the first login → [MCP onboarding](docs/05-openseo-mcp-agent.md) → baseline rank snapshot.
4. **Agent:** add OpenSEO to the agent's `mcp_servers` → owner restarts the gateway → verify the connection.
5. **Owner:** grant the service account access in [Search Console](docs/06-google-search-console.md); optionally set up the OAuth client for OpenSEO's GSC card.
6. **Agent:** record the [baseline measurements](docs/07-baseline-measurements.md) in a dated file; put the [budget](docs/08-budget.md) in the plan.
7. [Link building](docs/09-link-building.md) from the list produced in step 2, verifying link attributes and moderation timelines.

Before you start, read the [Server hardening](docs/02-server-hardening.md) page. Docker publishing ports past your firewall is the first thing that will bite you.

---

## Documentation

| # | Page | What it covers |
|---|---|---|
| 1 | [Prerequisites](docs/01-prerequisites.md) | Accounts only the owner can create; naming rules for secrets |
| 2 | [Server hardening](docs/02-server-hardening.md) | Sizing, Docker vs. ufw, SSH tunnels |
| 3 | [Elmo](docs/03-elmo.md) | Install, `.env`, Postgres password trap, writing prompts (not keywords), cost per surface, SQL to read results |
| 4 | [OpenSEO](docs/04-openseo.md) | Install, `.env`, first login, editing the D1/SQLite database |
| 5 | [OpenSEO ↔ agent over MCP](docs/05-openseo-mcp-agent.md) | Endpoint, Hermes config, onboarding call order, rank tracker costs |
| 6 | [Google Search Console](docs/06-google-search-console.md) | Service account vs. OAuth, Google Cloud setup, "Connection expired" decoded |
| 7 | [Baseline measurements](docs/07-baseline-measurements.md) | What to capture on day one and how |
| 8 | [Budget](docs/08-budget.md) | Real weekly numbers and how to check balances by API |
| 9 | [Link building](docs/09-link-building.md) | Directory link attributes, moderation timelines, reviews, Reddit, email outreach |
| 10 | [Pitfalls](docs/10-pitfalls.md) | The consolidated list of 15 traps |
| 11 | [New project checklist](docs/11-new-project-checklist.md) | Fill-in sheet for the next product |

### Templates

- [`templates/elmo.env.example`](templates/elmo.env.example): Elmo environment with the cost-safe defaults.
- [`templates/openseo.env.example`](templates/openseo.env.example): OpenSEO environment for local-only operation.
- [`templates/elmo-queries.sql`](templates/elmo-queries.sql): the three queries to run after the first cycle.
- [`templates/project-checklist.md`](templates/project-checklist.md): blank per-project sheet.

---

## Who this is for

An agent or a person standing up the same stack for a different product. The pages say **what** to do and **where it breaks**. Every concrete value (keyword counts, dollar figures, prompt counts) comes from one real deployment and is there as a worked example, not a requirement. Fill in the [checklist](docs/11-new-project-checklist.md) for your own project.

## Contributing

Corrections and new pitfalls are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE). OpenSEO, Elmo, DataForSEO, OpenRouter, Google and Hermes are the property of their respective owners; this repository documents how to use them together and is not affiliated with any of them.
