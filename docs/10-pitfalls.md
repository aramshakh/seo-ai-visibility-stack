# 10. Pitfalls: the consolidated list

1. **Docker publishes ports around ufw.** Bind everything to `127.0.0.1` and check from outside. → [Server](02-server-hardening.md)
2. **`elmo.yaml` is rewritten by the CLI**; ports snap back to `0.0.0.0`. → [Elmo](03-elmo.md)
3. **`POSTGRES_PASSWORD` applies only on first volume init.** Use `ALTER USER`. → [Elmo](03-elmo.md)
4. **Elmo onboarding generates self-referencing prompts** that inflate the mention metric. Disable them. → [Elmo](03-elmo.md)
5. **`DEFAULT_DELAY_HOURS` defaults to 24**: 7× the budget. Set 168. → [Elmo](03-elmo.md)
6. **OpenRouter is shared** by Elmo and OpenSEO; when it's empty both stop; after a top-up there's a one-time spend spike. → [Budget](08-budget.md)
7. **OpenSEO `local_noauth`** must never be reachable from the internet. → [OpenSEO](04-openseo.md)
8. **OpenSEO doesn't accept a service account**; its OAuth grant in Testing mode lasts 7 days. → [GSC](06-google-search-console.md)
9. **"Connection expired" = 403** (API not enabled / no property access); the error is swallowed. → [GSC](06-google-search-console.md)
10. **Redirect URI**: `localhost`, `http`, no trailing slash. → [GSC](06-google-search-console.md)
11. **Don't put new credentials in another product's Google Cloud project**; name secrets by project. → [Prerequisites](01-prerequisites.md)
12. **1Password inline menu blocks agent clicks in Chrome.** → [GSC](06-google-search-console.md)
13. **Two connected Chromes**: the agent picks the wrong one. Always `switch_browser` and verify the account. → [GSC](06-google-search-console.md)
14. **Prompts ≠ keywords.** Consumer `X alternative` is dead; `is X free / X review / X pricing` are alive. → [Elmo](03-elmo.md)
15. **Datacenter fetchers get 403** from Reddit, G2, Capterra. Use the owner's browser. → [Link building](09-link-building.md)

Next: [New project checklist](11-new-project-checklist.md)
