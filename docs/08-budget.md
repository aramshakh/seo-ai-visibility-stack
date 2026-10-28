# 8. Budget: real numbers

| Item | Per week | Note |
|---|---|---|
| Elmo, 16 prompts, 4 surfaces, weekly | ~$1.06 | daily would be × 7 |
| OpenSEO tracker, 99 keywords × 2 devices, weekly | ~$1.18 | live baseline run was $3.93 once |
| OpenSEO agent / onboarding (OpenRouter) | as used, small | |
| **Total** | **~$2.50** | |

Check balances by API, not by feel:

```bash
# DataForSEO: .tasks[0].result[0].money.balance
curl -u "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" https://api.dataforseo.com/v3/appendix/user_data
```

```bash
# OpenRouter: total_credits - total_usage
curl -H "Authorization: Bearer $OPENROUTER_API_KEY" https://openrouter.ai/api/v1/credits
```

Remember that OpenRouter is **shared** between Elmo and OpenSEO. When it hits zero, both stop; when you top up, Elmo replays every missed run at once (see [Elmo](03-elmo.md)).

Next: [Link building](09-link-building.md)
