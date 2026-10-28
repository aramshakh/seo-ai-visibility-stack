# 7. Baseline measurements: what to capture on day one

| Instrument | What | How |
|---|---|---|
| GSC (service account) | clicks / impressions / position for 28 days, **non-branded separately**, top pages | `searchanalytics.query` with filter `query not contains <brand>` |
| Elmo | mentions / runs per surface; who is named; who is cited | the SQL in [Elmo](03-elmo.md) |
| OpenSEO | positions for the basket, desktop + mobile | `run_rank_tracker` → `rank_snapshots` |
| GA4 | organic → install → activation | gate for month 3; clicks are not revenue |

Write everything to a **dated file** and commit it. This is the number you measure against.

For reference, a real starting baseline: 0 non-branded clicks, 0 of 154 prompt runs with a mention, 94 of 98 keywords outside the top 100. That is **normal for a launch**, and it is exactly why you need the baseline written down.

Next: [Budget](08-budget.md)
