# Legal and Compliance Baseline

## Status

This folder is an engineering and product baseline, not legal advice. Before public release, the privacy policy, terms, subscription wording, and store compliance declarations should be reviewed carefully and, if the app grows commercially, by a qualified legal professional.

## Current product position

RepForge MVP is designed to be local-first:

- No account required.
- No cloud database.
- No cloud sync.
- No remote analytics.
- No advertising SDK.
- No Firebase dependency.
- No remote diagnostics in MVP.
- Workout and profile data stay on the user's device unless the user explicitly exports/imports/backups later.

## Why compliance still matters

Local-first reduces risk, but it does not eliminate legal duties. The app can still handle sensitive data such as training history, weight, sex, age, injury notes, soreness/readiness, and later wearable data. App stores also require privacy disclosures even when data is not collected by the developer.

## Documents in this folder

- `gdpr_privacy_model.md` — privacy-by-design model and data-flow baseline.
- `privacy_policy_draft_de.md` — German draft privacy policy for a local-first MVP.
- `privacy_policy_draft_en.md` — English draft privacy policy for a local-first MVP.
- `terms_safety_disclaimer.md` — terms/disclaimer baseline using hedged language.
- `cookies_web_tracking.md` — mobile app vs. landing page cookies/tracking policy.
- `eu_regulatory_watchlist.md` — GDPR, AI Act, Data Act, CRA and related watchlist.
- `ai_act_position.md` — why MVP should avoid ML/LLM coach claims and stay transparent.
- `cyber_resilience_act_position.md` — cybersecurity product-governance baseline.
- `data_act_position.md` — connected-product and wearable-data considerations.
- `store_compliance.md` — App Store / Google Play compliance checklist.

## Release rule

No public production release without:

- privacy policy in German and English
- terms/safety disclaimer
- open-source license notices
- app store privacy/data safety declarations
- subscription terms if Premium is enabled
- security contact and vulnerability handling path
