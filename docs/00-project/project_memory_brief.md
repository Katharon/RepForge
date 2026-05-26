# Project Memory Brief

Use this file when starting a fresh ChatGPT or Codex context.

The user is rebuilding an old Setgraph-style workout tracking app in Flutter. The app name is `RepForge`. The old app screenshots show a dark workout tracker with fast set logging, exercise detail pages, rest timers, lock-screen local notifications, analytics, 1RM formulas, exercise history, workout programs/groups, exercise catalog, settings, membership, units, reminders, theme selection, and default rest time.

## Product direction

The app should become a local-first, privacy-conscious training tracker and practical coaching assistant. It must track everything relevant to strength training:

- Workout groups/training days such as `Leg Day`, `Push Day`, `Pull Day`, `Upper`, `Lower`, `Full Body`, or fully custom groups.
- Official bundled exercises and custom user exercises.
- Assignment of exercises to workout groups.
- Set entries with weight, repetitions, timestamp, labels, comments, and later RPE/RIR/readiness metadata.
- Analytics: sets, repetitions, volume, kg/rep, estimated 1RM, session density, trend lines, deltas to previous comparable session, deltas to selected time windows, and muscle-load summaries.
- Recovery/readiness: soreness/DOMS, perceived exertion, strength drops, time since last muscle stimulus, and deload suggestions.
- Recommendations: next exercise suggestions, alternatives, quick-session mode, volume adjustments, imbalance prevention, and focus-aware training guidance.


## Current fixed product decisions

- Product name: `RepForge`.
- MVP languages: English and German from the start. The app starts with the smartphone system locale when supported and falls back to English.
- MVP scope: local tracking, workout groups, custom exercises, small official catalog, and analytics.
- Free tier: tracking, workout groups, custom exercises, official base catalog, core analytics, local history, and local backup/export/import.
- Premium tier: coach, guidance, next-exercise recommendations, adaptive alternatives, muscle-balance insights, recovery/readiness, quick sessions, wearable-derived interpretation, and advanced reports.
- Ads: not part of the MVP. A clean, non-annoying free experience is preferred to build retention and habit before Premium conversion.
- Baseline cost strategy: no paid cloud database, no paid backend hosting, no paid analytics, no paid remote config, no RevenueCat at the beginning, and no recurring developer-controlled infrastructure cost in the MVP.
- Recommendation tone: use hedging. Say “may”, “could”, “appears”, “estimated”, “suggests”, “can be useful”; avoid absolute medical-style claims such as “you are not recovered” or “you must not train”.

## Important catalog decision

Do **not** use a paid cloud database for the official exercise catalog.

Official exercise definitions, muscle activation estimates, equipment requirements, movement patterns, body region tags, and recommendation metadata are shipped as versioned JSON assets inside the app and updated through app releases / weekly patches. The app imports bundled catalog versions into the local Drift/SQLite database. User-created exercises and user overrides stay local and must never be overwritten by catalog patches.

A future optional dynamic content channel may use signed static JSON from GitHub Releases/CDN/object storage, but it must not require a mutable cloud database. Cloud sync for user data is a separate post-MVP concern and must not leak into the local workout core.

## Architecture direction

Feature-first Clean Architecture adapted to Flutter:

- Domain: pure Dart entities, value objects, policies, formulas, training-science rules, recommendation rules.
- Application: use cases, ports, read models, orchestration.
- Data: Drift/SQLite, repositories, mappers, bundled catalog importers, local backup/import/export, platform services.
- Presentation: Flutter UI with BLoC/Cubit.
- Composition: constructor injection and a small composition root, likely with `get_it` plus BlocProvider wiring.

## Workflow

The workflow mirrors the user's NodeControl workflow: slice-based, Codex-friendly, documentation-driven, fresh-context-safe, and precise. Codex prompts should usually be English. Every prompt must name the exact files Codex should read. Codex must keep docs updated, work TDD-first, run validation commands, and commit each slice with a suitable Conventional Commit message.

## Product priorities

1. Correct local training log and data model.
2. Fast and pleasant logging UX.
3. Workout groups and exercise assignment.
4. Strong analytics and understandable progression feedback.
5. Official exercise catalog with local patch strategy.
6. Muscle activation, balance, fatigue, readiness, and recommendations.
7. Local backup/export/import.
8. App-store payments/entitlements only after the local MVP proves value.
9. Optional sync, wearables, and social features later.

## Engineering preference

Be academically precise but not overengineered. Use SOLID, Clean Code, tests, maintainability, and extensibility, but avoid abstractions that do not protect an actual product boundary. Do not build cloud/auth/payment/social/wearable infrastructure before the slices call for it.

## v5 product decisions

- App name decision: `RepForge`. Store/trademark checks are still required before public launch.
- Multilingual support is required from the beginning. Start with system locale; fallback to English if unsupported. Initial locales: English and German.
- MVP scope is deliberately narrow: tracker + workout groups + analytics. Coach, recommendations, recovery, muscle balance, wearables, social, and payments come later.
- Initial official catalog should be small and high-quality, centered on fundamental compound movements and essential accessories.
- Equipment inventory is part of the domain model because future coaching must respect available equipment and maximum load, especially in home gyms.
- UI direction: inspired by the old Setgraph screenshots, not copied.
- Monetization direction: freemium. Core tracking/groups/base analytics remain free; coach/recommendations/muscle balance/recovery/wearables can become Premium.
- Training guidance must be carefully worded as non-medical estimates and educational recommendations.


## v6 product and business decisions

- Product name decision: `RepForge`.
- Localization decision: German and English must exist from the MVP. The app starts with the smartphone system language when supported; otherwise English is the fallback.
- Official catalog architecture: JSON assets are the canonical, version-controlled source of truth. Drift/SQLite is the local runtime database and is seeded/imported from the bundled JSON assets on first launch and after catalog updates. This is not an either/or decision.
- Cost strategy: avoid paid cloud databases, paid backend services, paid analytics, paid remote-config systems, paid sync infrastructure, and any recurring third-party service unless a future business decision explicitly accepts the cost.
- Firebase is not part of the MVP. Crash reporting and remote messaging remain optional later decisions, not baseline dependencies.
- Marketing strategy: App Store Optimization (ASO) is the primary mobile discovery concept. A simple static landing page and optional content/SEO pages may support web discovery later, but the app itself should not depend on a hosted backend.
- Monetization strategy: prefer freemium over forced lockout after a trial. Free tier includes tracking, workout groups, custom exercises, base official catalog, and useful base analytics. Premium includes coach, guidance, recommendations, adaptive alternatives, muscle-balance insights, recovery/readiness, quick sessions, wearables, and advanced reports.
- Ads strategy: do not include ads in MVP. Ads can reduce trust and training-flow quality. Reconsider only after real usage data shows whether ads would outperform premium conversion without damaging retention.
- Recommendation tone: use hedging. Prefer “may”, “could”, “appears”, “estimated”, “suggests”, “can be useful”. Avoid absolute or medical wording such as “you must”, “you are not recovered”, or “you are injured”.

## v8 compliance, resilience, and legal baseline

- RepForge remains local-first by default: workout data, profile values, equipment inventory, groups, analytics, and catalog imports are stored on-device unless the user explicitly exports/imports/syncs in a future feature.
- Local-first reduces operational cost and privacy risk, but it does not remove the need for privacy policy, safety disclaimer, store data declarations, dependency governance, and security-update planning.
- MVP should not include remote analytics, remote crash reporting, Firebase, ads, cloud sync, remote config, or any paid recurring service.
- Logging must be privacy-safe. Never log training payloads, body data, wearable data, notes, purchase tokens, or identifiers.
- Legal/compliance docs are part of the repo: see `docs/08-legal-compliance/`.
- GDPR stance: data minimization, privacy by design/default, local storage, delete/export, clear privacy policy, explicit opt-in before future diagnostics/sync/wearables.
- AI Act stance: MVP has no AI/ML/LLM coach. Future coach features should first be deterministic, transparent, explainable, manually overrideable, and hedged.
- Cyber Resilience Act stance: treat mobile app/software security-by-design, vulnerability handling, dependency governance, update policy, and support lifecycle as release-quality requirements.
- Data Act stance: low MVP relevance, monitor for wearables, connected gym equipment, cloud sync, APIs, and third-party data sharing.
- Cookies: not relevant to the mobile MVP unless a WebView or marketing website is introduced. Prefer static no-cookie/no-tracking web pages.


## v9 data evolution decision

RepForge must preserve user history across future catalog, schema, analytics, and UI changes. Official exercise IDs are stable and never reused. Released official exercises are deprecated rather than deleted. Logged set entries keep stable exercise references and display-name snapshots so old sessions remain readable after official catalog renames or patches. Drift migrations, catalog JSON schema versions, backup/export format versions, and optional future platform/sync contracts are the relevant versioning boundaries. Flutter/Dart does not need .NET-style API-version annotations for MVP; architectural stability comes from pure Domain models, Application ports, Infrastructure adapters, versioned persisted formats, and migration tests.
