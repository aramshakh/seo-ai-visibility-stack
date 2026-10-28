# 6. Google Search Console: two different mechanisms

There are two ways into Search Console and they are **not interchangeable.**

## 6.1 Service account: for the agent, scheduled jobs, URL Inspection

Works for years, never expires. Store the JSON key in the password manager and on the server (`~/.config/gsc/<project>-service-account.json`).

Owner: Search Console → Settings → Users and permissions → add the service account's `client_email` with **Full** permission.

Check:

```python
svc.sites().list()   # must return sc-domain:<domain> with permissionLevel siteFullUser
```

**OpenSEO will not accept this key.** It only supports OAuth. Don't try.

## 6.2 OAuth: only for the GSC card inside OpenSEO

In Google Cloud, **in the product's own project** (see [Prerequisites](01-prerequisites.md)):

1. Enable the **Google Search Console API**.
2. Google Auth Platform → Branding (app name, support email, contact) → Audience **External** → Test users: add the Google account that will do the connecting.
3. Clients → **Web application** → redirect URI, **exactly**:
   `http://localhost:3001/api/gsc/oauth/callback`
   `localhost` (not `127.0.0.1`), `http`, no trailing slash.
4. Client ID + secret → password manager → agent writes them to `.env` as `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` → `docker compose up -d --force-recreate`.
5. Owner: Integrations → Connect with Google → sign in with an account **that has access to the property** → pick the property.

## Traps

- **"Connection expired" right after connecting** is not an expired token. It is a **403 from Google**, which OpenSEO swallows silently. Cause #1: the Search Console API is not enabled in the project that owns the OAuth client. Confirm in the `account` table: `refresh_token` present and `access_token_expires_at` in the future means the token is fine and the error is a 403.
- **"No properties"**: the account you signed in with has no access to the domain in Search Console. Add it under Users and permissions.
- **Testing mode**: the grant lives **~7 days** (sensitive scope). Either reconnect weekly or **Publish app** under Audience. The Publish button stays greyed out until Branding is fully filled in.
- Google may bounce the sign-in to a passkey / verification step. **The owner does this**, not the agent.
- When an agent drives Chrome, the **1Password inline menu blocks clicks on text fields** (`Cannot access a chrome-extension:// URL of different extension`). Workaround: fill fields by reference (`form_input`) instead of clicking; or the owner disables the inline menu on that site.
- With two Chrome instances connected, the agent may pick the wrong one. Always `switch_browser` explicitly and confirm which Google account the page shows before acting.

Next: [Baseline measurements](07-baseline-measurements.md)
