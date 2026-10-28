# 11. New project checklist

Copy [`templates/project-checklist.md`](../templates/project-checklist.md) into your project repo and fill it in before day one.

```
Product / domain:                 ____________________
Market (locationCode / lang):     2840 / en   → ____________________
Brand aliases (Elmo):             ____________________
Competitors (domains, 8–15):      ____________________
Prompts (15–20, as questions):    ____________________
Keyword basket (file):            ____________________
Google Cloud project (own):       ____________________
GSC service account email:        ____________________
Account with property access:     ____________________
Password-manager vault / items:   ____________________
Agent profile:                    ____________________
Ports (all on 127.0.0.1):         Elmo 1515 · OpenSEO 3001 · postgres 5432
Schedule:                         Elmo 168h · tracker weekly
Balances at start:                DataForSEO $__ · OpenRouter $__
Baseline (date):                  GSC non-brand clicks __ · Elmo __/__ · top-100: __/__
```

## The one-day order

1. **Owner:** accounts ([Prerequisites](01-prerequisites.md)), vault, agent service-account token.
2. **Agent:** [Elmo](03-elmo.md) → ports → own prompts → one cycle → SQL → **"who gets cited" list**.
3. **Agent:** [OpenSEO](04-openseo.md) → owner first login → [MCP onboarding](05-openseo-mcp-agent.md) → rank baseline.
4. **Agent:** agent `mcp_servers` → owner says "restart" → `ss` check.
5. **Owner:** Search Console permissions for the service account; optionally the OAuth client ([GSC](06-google-search-console.md)).
6. **Agent:** [baseline](07-baseline-measurements.md) to a dated file; [budget](08-budget.md) into the plan.
7. [Link building](09-link-building.md) from the step-2 list, verifying link attributes and timelines.
