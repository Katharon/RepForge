# Changelog

## Unreleased

### Added

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
