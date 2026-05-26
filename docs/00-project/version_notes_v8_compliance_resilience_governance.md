# Version Notes v8 — Compliance, Resilience, Logging, and Legal Baseline

## Purpose

This version adds a compliance and resilience baseline for RepForge before implementation starts. The product remains local-first and zero recurring infrastructure cost by default, but local-first does not mean compliance-free. The app still handles sensitive personal training data on the user's device and will eventually be distributed through app stores.

## Fixed decisions added in v8

- RepForge remains a local-first app. Workout logs, body profile data, equipment inventory, groups, analytics, and catalog imports are stored locally on the user's device by default.
- No cloud backend, cloud database, cloud analytics, remote config, advertising SDK, or Firebase dependency is part of the MVP.
- Official catalog data is shipped as versioned JSON assets and imported into local Drift/SQLite. The catalog is not fetched from a paid mutable cloud database.
- Privacy by design and data minimization are product requirements, not later polish.
- Logging must be safe by default: no weight, age, sex, notes, workout entries, device identifiers, payment identifiers, or health/wearable payloads in logs unless explicitly sanitized and needed for local troubleshooting.
- Diagnostics/crash reporting are not part of MVP. If added later, they must be opt-in or strictly privacy-reviewed, configurable, and documented.
- Legal documents are needed before store release: privacy policy, terms/EULA, safety disclaimer, subscription terms, restore-purchase wording, open-source notices, and store data-safety declarations.
- Cookies are not relevant to the mobile MVP unless a WebView or marketing website is added. A later static landing page needs a no-cookie/no-tracking default if possible.
- AI Act exposure is low for MVP because there is no ML/LLM coach. Future coach features should initially be deterministic/rule-based, transparent, and heavily hedged.
- Cyber Resilience Act is a watchlist item because commercial mobile apps/software are likely relevant products with digital elements. Security-by-design, dependency governance, vulnerability handling, update policy, and support lifecycle must be documented.
- Data Act is low for the local MVP, but becomes relevant to monitor if RepForge integrates connected products, wearables, or exposes/receives user-generated device data.

## Practical interpretation

The compliance strategy is deliberately simple:

1. Do not collect what the product does not need.
2. Keep data local unless the user deliberately exports, backs up, syncs, or imports from wearables.
3. Keep the free core useful and private.
4. Add paid infrastructure only when there is proven revenue justification.
5. Treat legal/compliance documents as release artifacts, not as implementation afterthoughts.

## New documentation files

- `docs/02-architecture/resilience_governance.md`
- `docs/02-architecture/logging_diagnostics_policy.md`
- `docs/08-legal-compliance/README.md`
- `docs/08-legal-compliance/gdpr_privacy_model.md`
- `docs/08-legal-compliance/privacy_policy_draft_de.md`
- `docs/08-legal-compliance/privacy_policy_draft_en.md`
- `docs/08-legal-compliance/terms_safety_disclaimer.md`
- `docs/08-legal-compliance/cookies_web_tracking.md`
- `docs/08-legal-compliance/eu_regulatory_watchlist.md`
- `docs/08-legal-compliance/ai_act_position.md`
- `docs/08-legal-compliance/cyber_resilience_act_position.md`
- `docs/08-legal-compliance/data_act_position.md`
- `docs/08-legal-compliance/store_compliance.md`
- `docs/04-quality/compliance_release_checklist.md`
- `docs/04-quality/security_update_policy.md`
- `docs/06-slices/slice_55_legal_compliance_resilience_baseline.md`
