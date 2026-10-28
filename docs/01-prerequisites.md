# 1. Prerequisites: what only the project owner can do

The agent **does not register accounts and does not type passwords.** The owner creates; the agent fills in.

| Account | Where | What to store in the password manager |
|---|---|---|
| DataForSEO | app.dataforseo.com → API Access | `login`, `password` (for Elmo); `base64("login:password")` (for OpenSEO) |
| OpenRouter | openrouter.ai/settings/keys | API key |
| Google Cloud **project dedicated to this product** | console.cloud.google.com | nothing yet, but see [Search Console](06-google-search-console.md): never reuse another product's or an old project |
| Password-manager vault + service account for the agent | e.g. 1Password | agent token on the server (`~/.op_service_token` for 1Password); one vault per project |
| Work-domain Gmail | for outreach | the agent's OAuth token with the `gmail.send` scope, see [Link building](09-link-building.md) |

## Naming rule for secrets

Name every item **by project and by purpose**, never by "whose" it is.

Real example: an item called "Google Search Console — <Product A> Service Account" actually held the key for **Product B**. That cost half an hour of debugging a perfectly valid key against the wrong property.

Good: `<product> / GSC service account`, `<product> / DataForSEO API`, `<product> / OpenRouter`.

## Why a dedicated Google Cloud project

OAuth clients, enabled APIs, and consent-screen branding are all per project. Putting a new product's credentials into an older product's project means:

- the consent screen shows the wrong product name to whoever connects;
- the Search Console API may be enabled in one project and not the other, producing the silent 403 described in [Search Console](06-google-search-console.md);
- nobody can later tell which client belongs to which product.

Next: [Server hardening](02-server-hardening.md)
