# Architectural and Product Decisions

## ADR-0001 — Use Flutter for Android/iOS first

Decision: Build the app in Flutter, targeting Android and iOS first. Desktop and web remain later targets.

Reason: Flutter provides a strong cross-platform UI toolkit and mature support for local storage, testing, and app-store delivery.

## ADR-0002 — Use feature-first Clean Architecture

Decision: Organize by features while preserving Clean Architecture boundaries.

Reason: A pure layered structure becomes noisy in Flutter apps. Feature-first keeps related files discoverable while dependency rules keep the architecture testable.

## ADR-0003 — Domain is pure Dart

Decision: Domain code must not import Flutter, Drift, Firebase, platform APIs, local notifications, payment APIs, or HTTP clients.

Reason: Workout formulas, recommendation rules, muscle-load calculations, and recovery policies must be fast unit-testable and independent of infrastructure.

## ADR-0004 — Use Drift/SQLite for local data

Decision: Use a local relational database through Drift for user data, official catalog imports, analytics queries, and migrations.

Reason: The app is local-first and query-heavy. Drift gives type-safe queries and migration tests.

## ADR-0005 — No cloud database for official exercise catalog

Decision: Official exercises, muscle metadata, equipment tags, movement patterns, and recommendation metadata are shipped as versioned bundled assets and updated through app releases/weekly patches.

Reason: The user does not want to pay for a cloud database just to add exercises. A versioned bundled catalog is simpler, cheaper, offline-capable, privacy-friendly, and sufficient for curated exercise definitions.

Consequences:

- The app needs a catalog manifest and importer.
- Official catalog records need stable IDs and semantic versions.
- User overrides must be stored separately from official definitions.
- New official exercises require an app release or static signed content patch.
- A future optional signed static JSON update channel may exist, but no mutable cloud database is required.

## ADR-0006 — Local notifications for rest timers

Decision: Rest timers use local notifications, not Firebase Cloud Messaging.

Reason: Rest timers are device-local events. FCM would add unnecessary account/backend complexity.

## ADR-0007 — Recommendation engine starts rules-based

Decision: The coaching/recommendation engine starts as deterministic rules and policies in the domain/application layer, not cloud AI.

Reason: Rules are testable, explainable, privacy-friendly, cheap, and enough for progressive overload, recovery, quick sessions, and imbalance prevention.

## ADR-0008 — Premium is post-MVP

Decision: Payments and entitlements are later slices after local value is proven.

Reason: The product must first become useful. When added, entitlements must be modeled properly and not as a random `isPremium` flag.

## ADR-0009 — Health and training claims remain careful

Decision: The app must present training recommendations as estimates and coaching signals, not medical certainty.

Reason: Soreness, recovery, calories, muscle activation, and injury risk are inherently approximate without lab-grade measurement.

## v5 decisions

### Localization foundation

The app must support localization from the beginning. It starts with the system locale and falls back to English if unsupported. English is the canonical fallback. German is included early.

### MVP boundary

The local MVP is tracker + groups + analytics only. Advanced coach behavior is designed into the domain but not implemented until later slices.

### Equipment-aware domain

Equipment availability and max load are modeled early. This prevents future recommendation logic from suggesting impossible loads such as a 100 kg bench press to a home-gym user whose barbell setup only supports 80 kg.

### Freemium monetization

The preferred model is freemium instead of a hard trial paywall. Free users keep the complete local tracker, groups, custom exercises, base catalog, and core analytics. Premium unlocks coach/recommendation/recovery/muscle-balance/wearable functionality.

### UI inspiration boundary

The old Setgraph app is a reference for product feel and information density, but the new app must have an original UI identity and must not copy screens one-to-one.


## ADR-009 Product Name: RepForge

Status: accepted for implementation baseline.

Decision: the product name is `RepForge` unless later store/trademark checks force a change.

Rationale: the name connects repetitions, forging progress, strength training, and long-term progression without copying the old Setgraph identity.

Consequences:

- Documentation, screenshots, app metadata drafts, and default app title should use RepForge.
- Package identifiers and bundle IDs should still be chosen carefully later.
- Final public launch requires store and trademark checks.

## ADR-010 Official Catalog Source: JSON Assets, Drift Runtime Import

Status: accepted.

Decision: official exercises are authored as versioned JSON assets. On first app start and after app updates, the app initializes Drift/SQLite and imports any new catalog versions into local tables.

Rationale: JSON assets are diffable, reviewable, testable, translatable, easy to patch through app releases, and free to distribute as part of the app. Drift is optimized for local querying, filtering, analytics joins, and user-specific overrides. They solve different problems.

Consequences:

- JSON is the canonical source for official catalog content.
- Drift is the local runtime projection/cache and local user-data store.
- Catalog importers must be idempotent.
- Official catalog rows must be immutable from normal UI flows.
- User-created exercises and user overrides must be preserved across catalog updates.

## ADR-011 Zero-Recurring-Cost Baseline

Status: accepted.

Decision: the MVP must avoid paid cloud services, paid hosted databases, paid analytics, paid remote config, paid backend jobs, and any recurring infrastructure cost controlled by the developer.

Rationale: RepForge should maximize profit potential by keeping operating costs close to zero. Store developer accounts and store commissions are unavoidable distribution/monetization costs, but application architecture should not require monthly infrastructure bills.

Consequences:

- No cloud exercise catalog.
- No Firebase in MVP.
- No server-side sync, auth, receipt-validation, or analytics in MVP.
- Local-first remains a product and cost strategy, not only a technical preference.

## ADR-012 Ads Are Not Part of MVP

Status: accepted.

Decision: RepForge does not integrate ads in the MVP.

Rationale: the free tier should be pleasant enough to build habit, trust, and organic recommendations. Ads may generate revenue only at meaningful scale and can harm UX, perceived quality, and premium conversion.

Consequences:

- Do not add `google_mobile_ads` in MVP.
- Keep an explicit architecture seam so ads could be added later without polluting domain/application code.
- Re-evaluate ads only after retention, premium conversion, and active-user metrics exist.

## ADR-013 ASO/SEO Strategy

Status: accepted.

Decision: RepForge should be built and documented with App Store Optimization in mind. SEO is relevant mainly for a future static landing page, documentation/blog content, and public changelog pages.

Rationale: native mobile apps are discovered primarily through store search, screenshots, ratings, reviews, and product-page conversion. Web SEO can support brand discovery but does not replace store metadata optimization.

Consequences:

- English and German store metadata must be planned from the beginning.
- Screenshots should be productized and not treated as afterthoughts.
- The app should produce marketable moments: clear graphs, progress cards, personal records, and coach-style insights.


## ADR-0014 — Product name is RepForge

Decision: Use `RepForge` as the app name unless a future trademark/store-availability check forces a change.

Reason: The name communicates repetitions, progression, and forging strength without copying the old Setgraph identity.

## ADR-0015 — No ads in MVP

Decision: Do not include ads in the MVP.

Reason: Workout logging is interruption-sensitive. A clean free tier should build trust, habit, retention, and later Premium conversion. Ads may be reconsidered only after real retention/conversion data exists and must never affect the core logging flow.

## ADR-0016 — Use hedging for coaching language

Decision: Recommendation and recovery copy must use cautious non-medical wording.

Reason: RepForge can provide training suggestions and estimates, but it must not present itself as a medical diagnosis or absolute authority. Use language such as “may”, “could”, “appears”, “estimated”, “suggests”, and “can be useful”.

## v8 compliance and resilience decisions

- The MVP remains fully local-first and avoids remote analytics, crash reporting, ads, cloud sync, Firebase, remote config, cloud databases, and paid recurring service dependencies.
- Legal and compliance documents are release artifacts and live under `docs/08-legal-compliance/`.
- RepForge must provide clear privacy and safety wording in English and German before public release.
- All recommendations must use hedging and must avoid medical, diagnostic, therapeutic, or guaranteed-result claims.
- Logs and diagnostics must never include sensitive training, body, wearable, payment, or identifier payloads.
- GDPR/DSGVO, AI Act, Cyber Resilience Act, Data Act, app-store rules, and medical-device positioning are watchlist topics.


## Decision: Stable IDs and backward-compatible data evolution

RepForge must support long-lived user training histories. Official catalog entries use stable IDs that are never reused. Released official exercises are deprecated rather than deleted. Historical set entries must remain readable even if an exercise is renamed, corrected, localized differently, or superseded.

Versioning happens through Drift schema versions, catalog JSON `schemaVersion`/`catalogVersion`, export format versions, formula versions for stored derived metrics, and optional future sync/platform contracts. The MVP does not require .NET-style API version annotations in code.
