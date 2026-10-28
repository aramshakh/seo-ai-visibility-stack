# 5. OpenSEO ↔ agent over MCP

## Endpoint

`http://127.0.0.1:3001/mcp`, Streamable HTTP. In `local_noauth` mode **no key is needed**: a request from loopback is treated as the local admin.

46 tools, including:

```
list_projects, create_project, update_project_context (addCompetitors, sections),
save_keywords, research_keywords, get_serp_results,
create_rank_tracker, add_rank_tracking_keywords, estimate_rank_tracker_cost, run_rank_tracker,
get_search_console_performance, inspect_urls, get_backlinks_overview, …
```

## Connecting the agent (Hermes example)

Add to `~/.hermes/config.yaml` **and** to the profile `~/.hermes/profiles/<profile>/config.yaml`:

```yaml
mcp_servers:
  openseo:
    url: "http://127.0.0.1:3001/mcp"
```

The gateway is a systemd user unit:

```bash
systemctl --user restart hermes-gateway.service
```

This interrupts the agent's Telegram and cron channels for a few seconds. **Ask the owner before restarting.**

Verify it picked the server up:

```bash
ss -tnp | grep :3001 | grep hermes          # a connection from the gateway pid
grep -c openseo ~/.hermes/cache/mcp_schema_cache.json
```

Any other MCP-capable agent works the same way: point it at the URL, no auth header.

## Project onboarding over MCP: call order

```
list_projects                                                     → projectId
save_keywords {projectId, keywords[]}                             # the whole measured basket, ≤100 per call
update_project_context {projectId, updates:[
    {addCompetitors:[{domain,name,notes}]},
    {section:"business_overview", content}, …]}
create_rank_tracker {projectId, domain, locationCode:2840, languageCode:"en",
    devices:"both", serpDepth:100, scheduleInterval:"manual"}
estimate_rank_tracker_cost {projectId, trackerId, additionalKeywordCount:N}   → costCredits
add_rank_tracking_keywords {projectId, trackerId, keywords[],
    maxEstimatedScheduledCheckCredits:<costCredits from estimate>}
run_rank_tracker {projectId, trackerId, maxCostCredits:<live costCredits>}    # first baseline is a live SERP pull, pricier than the queue
```

`locationCode: 2840` is the United States; look up your market's code in the DataForSEO locations list.

## Tracker cost

Create the tracker as `manual` and choose the schedule deliberately:

| Run | Cost |
|---|---|
| Live baseline, 99 keywords × 2 devices | **$3.93** |
| Weekly queued check, same basket | **$1.18** (≈ $4.70/month) |
| Daily | × 7 |

Exclude from the basket: competitors' navigational brand terms (you will never rank for them) and any runs where the location was not confirmed.

Next: [Google Search Console](06-google-search-console.md)
