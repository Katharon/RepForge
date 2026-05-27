# Changelog

## Unreleased

### Added

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
