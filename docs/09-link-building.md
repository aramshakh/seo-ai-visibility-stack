# 9. Link building: the portable part

Your submission copy, backlink pool, review-site list and Reddit notes are product-specific; keep them in your own repo. What transfers between products is below.

## Directories: verified link attributes

(Checked by hand in a real deployment, September 2026. Re-verify: these change.)

| dofollow | nofollow / ugc | couldn't get listed |
|---|---|---|
| AlternativeTo, SpotSaaS | SaaSHub, Product Hunt (`ugc`), Trustpilot, Capterra (redirect) | G2, GetApp, TrustRadius, SourceForge, Crozdesk, SaaSWorthy, PeerSpot |

**A directory's value is not the link, it is citeability by assistants.** The "who gets cited" list from [Elmo](03-elmo.md) is your submission priority list.

## Timelines and traps

- **SaaSHub**: moderation up to 32 days.
- **SpotSaaS**: **45–60 days** (the landing page claims 2 weeks); fast-track costs $399.
- **Capterra**: 1–2 days, but you must **claim** the listing and check the paid tiers.
- **G2** blocks with "name taken" until Capterra has published (shared Gartner backend).
- **SaaSWorthy** free tier is a lead form asking for phone and funding. That is the owner's decision. Their disclaimer: "only SaaS".

## Reviews

2–3 per week, in the reviewer's own words, unpaid. Every platform runs anti-fraud.

## Reddit

Almost every large subreddit bans self-promotion by rule; some ban AI-generated content outright (r/DesignMyRoom, for instance). Paid Reddit Ads targeted by community are the way in; subreddit rules don't apply to ads.

## Email outreach

- Gmail API, the agent's token with the `gmail.send` scope (`~/.hermes/google_token.json`, type `authorized_user`). `Credentials.refresh(Request())` fixes an expired token.
- Ship scripts to the server as `base64 | ssh 'base64 -d > file'`. A quoted heredoc over SSH breaks.
- Pace: **one email every 1–3 days** from a young mailbox.
- Send **only on the owner's explicit go.**

## Checking a site's contact

`curl` the site's `/contact` from the server and grep for `mailto`. A hosted web fetcher may be blocked by policy on small domains. Check **what the site is about**: a garden-design blog made it into one of our pools.

Datacenter IPs get 403 from Reddit, G2 and Capterra. Browse those through the owner's browser.

Next: [Pitfalls](10-pitfalls.md)
