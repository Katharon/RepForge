# Changelog

## Unreleased

### Added

- Added Slice 37 optional sync metadata boundary with pure-Dart entity,
  version, state, tombstone, and conflict-policy types, plus tests proving
  local-only defaults, official catalog separation, optional auth/Firebase
  behavior, and deterministic conflict handling without a sync engine, remote
  API, upload/download transport, Firestore, account requirement, UI, or Drift
  schema changes.
- Added Slice 36 optional Firebase integration boundary with pure-Dart
  capability/configuration/status models, a fakeable initialization gateway,
  default disabled/unavailable composition-root wiring, and tests proving local
  MVP features, auth defaults, and local rest-timer notifications do not require
  Firebase, FCM, Firebase Auth, Crashlytics, Remote Config, Firestore, sync, or
  analytics SDK events.
- Added Slice 35 optional authentication boundary with pure-Dart auth session,
  identity, provider, failure, and gateway models, local-only default wiring,
  fake auth tests, and sign-out/status use cases without login UI, auth SDKs,
  backend, cloud sync, account requirement, or auth-based Premium unlock.
- Added Slice 34 purchase verification boundary with pure-Dart verification
  requests/results/source ports, conservative entitlement-cache policy, fake
  verification tests, and default unavailable verification wiring without a
  backend, account system, paywall UI, Firebase, RevenueCat, Supabase, ads,
  sync, or raw receipt/token handling.
- Added Slice 33 app-store purchase gateway integration with pure-Dart purchase
  models and ports, fake purchase-gateway tests, provisional mapping from store
  events into the entitlement snapshot model, and a thin official
  `in_app_purchase` adapter without backend, account, paywall UI, Firebase,
  RevenueCat, ads, sync, or trusted receipt verification.
- Added Slice 32 entitlement domain and premium gates with pure-Dart entitlement
  snapshots, source-separated states, explicit gate decisions, default local/free
  policy wiring, and focused tests proving existing local MVP features remain
  free while optional future Premium gates stay locked or unavailable without
  trusted entitlement evidence.
- Added Slice 31 performance and large-history hardening with additive
  workout-set query indexes, deterministic large-seed pagination tests, bounded
  Today daily aggregation, and capped exercise analytics history scans.
- Added Slice 30 security and privacy hardening with local-backup privacy
  warnings, field-only log-safe backup validation exceptions, backup JSON
  redaction helpers for diagnostics, and lock-screen-safe rest-timer
  notification content sanitization.
- Added Slice 29 integration-style workout logging flow coverage with a
  deterministic widget harness for catalog search/selection, set logging,
  editing, persisted history read-back, Today dashboard reaction, Analytics
  reaction, and fake rest-timer scheduling without devices, notifications, or
  remote services.
- Added Slice 28 golden-test baseline with deterministic snapshots for the
  core app card, Today success dashboard, Analytics success dashboard, Settings
  defaults screen, and Onboarding welcome screen using Flutter's built-in
  golden support.
- Added Slice 27 accessibility and responsive layout hardening with semantic
  labels for navigation, metrics, charts, settings, onboarding controls, and
  rest-timer summaries; increased text-scale widget coverage; minimum touch
  target checks; and a small responsive sliver-list helper for current screens.
- Added Slice 26 local search/filter/sort/archive foundations with bounded
  workout-set history search, set-label filtering, deterministic history sort,
  workout-group search/sort, archived-group exclusion by default, explicit
  archived inclusion, and safe group archive behavior without schema or remote
  features.
- Added Slice 25 persistence hardening with current Drift schema validation,
  a non-empty schema v1 migration-test fixture, broader database constraint
  coverage, deterministic integrity findings, report-only safe repair for
  legacy blank set labels, and archive/delete/import policy tests.
- Added Slice 24 local backup foundation with versioned JSON export,
  deterministic validation, additive/upsert import, composition-root wiring,
  catalog-import metadata preservation, and no cloud or platform file picker.
- Added Slice 23 onboarding foundation with a skippable local setup flow,
  onboarding status persistence, profile/focus/time/equipment settings save,
  bundled starter group templates, and optional starter workout group creation.
- Added Slice 22 Settings and user profile foundation with pure-Dart settings
  domain values, load/save/reset use cases, Drift schema v5 persistence,
  structured equipment inventory, localized Settings tab controls, and focused
  domain/repository/use-case/widget tests.
- Added Slice 21 Today dashboard with a fakeable local loader, loading/empty/
  error/success UI states, daily set and volume cards, last logged set summary,
  rest timer status, quick-action placeholder, and a small analytics hint.
- Added Slice 20 estimated 1RM feature with a focused Analytics value card,
  Epley formula identity display, unavailable handling, zero-load estimate
  coverage, and deterministic 1RM chart/selection tests without new chart
  packages or formula persistence.
- Added Slice 19 analytics UI foundation with a fakeable exercise analytics
  loader, metric and range selectors, localized loading/empty/error/success
  states, compact summary metric cards, and simple local chart-card
  visualization without adding a chart package or remote analytics.
- Added Slice 18 exercise analytics use cases with bounded WorkoutSet timeline
  reads, per-exercise overview metrics, estimated 1RM read models, previous
  comparable session deltas, time-window deltas, and deterministic analytics
  validation hardening without charts or remote analytics.
- Added Slice 17 local rest-timer notification scheduling with a fakeable
  notification gateway, coordinator-driven schedule/cancel behavior,
  `flutter_local_notifications` Android/iOS adapter, and no remote push.
- Added Slice 16 rest timer foundation with pure-Dart duration validation,
  injectable time provider, running/finished/cancelled snapshots, deterministic
  controller state, and countdown display state without local notifications.
- Added Slice 15 set-label foundation for workout sets, including the compact
  `none`/`warmup`/`failure`/`personalRecord`/`dropSet`/`pain` marker set,
  form/application handoff, Drift schema v4 persistence, and mapper validation
  while preserving existing optional comments.
- Added Slice 14 add/edit/delete workout-set foundation with pure-Dart
  application use cases, compact form input parsing, and targeted Drift delete
  support.
- Added Slice 13 exercise set timeline paging with pure-Dart cursor/page query
  types and Drift keyset paging over `performedAt` plus stable workout-set ID.
- Added the Slice 12 workout group assignment foundation, including pure-Dart
  group/assignment domain contracts, Drift schema v3 group tables,
  mapper/repository persistence, and pagination-ready group/assignment queries.
- Added the Slice 11 official exercise catalog foundation, including a bundled
  versioned JSON catalog asset, pure-Dart catalog models/query contracts,
  parser validation, Drift schema v2 catalog tables, idempotent official import,
  and pagination-ready catalog queries.
- Added explicit dependency-injection wiring for Slice 10, including a local
  Drift database factory, composition-root `WorkoutSetRepository` construction,
  and idempotent dependency close semantics.
- Added the training-log Drift repository and mapper layer for Slice 09,
  including stable-ID upserts, deterministic history/session queries, and
  persisted-data validation for custom exercise catalog snapshots.
- Added the Drift/SQLite local database foundation for Slice 08, including
  schema version 1, a historical workout-set table, generated Drift code, and
  in-memory schema tests.
- Added the pure-Dart analytics formula foundation for Slice 07, including
  formula identity metadata, Epley estimated 1RM, workout-set summaries, and
  period comparison helpers.
- Added the pure-Dart training-log domain foundation for Slice 06, including
  stable IDs, exercise references with snapshots, logged-set value objects,
  `WorkoutSet`, and repository contracts.
- Added a minimal localized navigation shell and stable route map for Today,
  Groups, Exercises, Analytics, and Settings for Slice 05.
- Added the dark-first RepForge Material 3 theme foundation, design tokens, and
  base `AppCard` component for Slice 04.
- Added a minimal `lib/src` architecture skeleton and explicit app composition
  root for Slice 03.
- Added Flutter quality gates for formatting, localization generation, analysis, and tests.
- Added a local validation script and minimal GitHub Actions quality workflow.
- Bootstrapped the RepForge Flutter app for Android and iOS.
- Added English/German Flutter localization foundation and widget smoke tests.
- Established Slice 00 repository governance baseline for RepForge.
- Added required root governance files and GitHub issue/PR templates.

### Changed

- Aligned root and Codex documentation with the v9 local-first, no-cloud, no-ads, zero-recurring-cost MVP decisions.
- Clarified that the official exercise catalog is not backed by a paid cloud database.
- Added bundled versioned catalog asset strategy for weekly exercise patches.
- Expanded domain model around workout groups, custom exercises, official exercises, muscle activation, recovery, readiness, recommendations, quick sessions, and imbalance prevention.
- Added advanced training-intelligence slices 43–54.
- Updated ChatGPT project instructions and Codex workflow for the no-cloud-catalog decision.

## v5 planning update

- Added localization/i18n decision.
- Added naming candidate list.
- Clarified MVP boundary.
- Added equipment inventory/max-load requirements.
- Clarified freemium monetization strategy.
- Added non-medical disclaimer/safety boundary.


## v7 — Final Concept Check

- Set `RepForge` as the selected app name subject to trademark/store checks.
- Consolidated MVP localization, free/Premium split, no-ads MVP decision, zero-recurring-cost strategy, JSON-to-Drift catalog import, and hedged coaching language.
- Added `docs/00-project/version_notes_v7_final_concept_check.md`.

## v8 — Compliance, resilience, and legal baseline

- Added legal/compliance baseline documentation.
- Added GDPR/privacy model, privacy policy drafts, safety disclaimer, cookie/tracking policy, AI Act/Data Act/CRA positions, and store compliance checklist.
- Added resilience governance and logging/diagnostics policies.
- Added Slice 55 for legal compliance and resilience baseline.
- Updated project memory and ChatGPT project instructions with local-first, no-cloud, no-remote-SDK MVP stance.
