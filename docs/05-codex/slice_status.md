# Slice Status

Status values:

- `planned`
- `in_progress`
- `ready-to-commit`
- `done`
- `blocked`
- `deferred`

All slices are planned until implemented and committed.

## Current status

- Slice 00: done repository governance and docs baseline.
- Slice 01: done Flutter project bootstrap.
- Slice 02: done analysis options, formatting, and test gates.
- Slice 03: done architecture skeleton and composition root.
- Slice 04: done design tokens and app theme.
- Slice 05: done navigation shell and route map.
- Slice 06: done training-log domain foundation.
- Slice 07: done analytics formula domain tests.
- Slice 08: done Drift local database foundation.
- Slice 09: done training-log repository implementation and mappers.
- Slice 10: done dependency injection wiring.
- Slice 11: done official exercise catalog foundation.
- Slice 12: done workout group assignment foundation.
- Slice 13–23: planned local tracking MVP with custom exercises, exercise timeline, set logging, analytics foundations, settings, onboarding.
- Slice 24–31: planned local hardening.
- Slice 32–38: planned post-MVP monetization/optional cloud boundaries.
- Slice 39–42: planned release pipeline and production checklist.
- Slice 43–54: planned advanced catalog, training intelligence, recovery, muscle balance, quick session, wearable design, and social design.
- Slice 55–56: planned legal/compliance/resilience and backward-compatibility hardening.

## Critical project decision

The official exercise catalog must not depend on a paid cloud database. Catalog updates are shipped as versioned app assets through app releases/patches and imported locally.

## Update rule

After every implemented slice, Codex must update this file with:

- date,
- slice number,
- status,
- commit hash,
- short implementation summary,
- validation commands run,
- follow-ups.

## v5 documentation status

Planning docs were updated with:

- multilingual/system-locale decision,
- MVP boundary: tracker + groups + analytics,
- small official catalog scope,
- equipment inventory and max-load modeling,
- Setgraph-inspired but original UI direction,
- freemium monetization strategy,
- training disclaimer/safety boundary,
- naming candidate list.

Slice 00 has completed documentation/governance implementation and is committed. Slice 01 has completed Flutter bootstrap implementation and is committed. Slice 02 has completed quality-gate implementation and is committed. Slice 03 has completed architecture skeleton implementation and is committed. Slice 04 has completed design-system implementation and is committed. Slice 05 has completed navigation-shell implementation and is committed. Slice 06 has completed training-log domain foundation implementation and is committed. Slice 07 has completed analytics formula domain implementation and is committed. Slice 08 has completed Drift local database foundation implementation and is committed. Slice 09 has completed training-log repository implementation and is committed. Slice 10 has completed dependency-injection wiring and is committed. Slice 11 has completed the official exercise catalog foundation and is committed. Slice 12 has completed the workout group assignment foundation and is committed.

## Slice log

| Date | Slice | Status | Commit | Summary | Validation | Follow-ups |
| --- | --- | --- | --- | --- | --- | --- |
| 2026-05-26 | 00 — Repository governance and docs baseline | done | this commit | Normalized root governance files, GitHub templates, and Codex slice instructions for the RepForge v9 baseline. | `git status --short`; `find . -maxdepth 3 -type f \| sort`; required `test -f` checks; RepForge/guardrail `rg` checks. `markdownlint` skipped because it is not installed. | None. |
| 2026-05-27 | 01 — Flutter project bootstrap | done | this commit | Bootstrapped Android/iOS Flutter app at repository root with package `repforge`, localized RepForge placeholder shell, English/German ARB files, and widget smoke tests. | `git status --short`; `flutter --version`; `flutter doctor -v`; `flutter pub get`; `flutter gen-l10n`; `dart format --set-exit-if-changed lib test`; `flutter analyze`; `flutter test`; `find . -maxdepth 3 -type f \| sort`; requested `rg` checks. | None. |
| 2026-05-27 | 02 — Analysis options, formatting, test gates | done | this commit | Tightened practical Flutter analyzer settings, documented validation commands, added `scripts/check.sh`, and added a minimal GitHub Actions quality workflow. | `git status --short`; `flutter --version`; `flutter pub get`; `flutter gen-l10n`; `dart format --output=none --set-exit-if-changed .`; `flutter analyze`; `flutter test`; `scripts/check.sh`; `find . -maxdepth 3 -type f \| sort`; requested `rg` checks. | None. |
| 2026-05-27 | 03 — Architecture skeleton and composition root | done | aa1870e | Moved the localized placeholder app into `lib/src/app`, added a minimal explicit composition root, documented `core`/`features` extension points, and updated widget smoke tests. | `git status --short`; `flutter pub get`; `flutter gen-l10n`; `dart format --output=none --set-exit-if-changed .`; `flutter analyze`; `flutter test`; `find lib test -maxdepth 5 -type f \| sort`; requested `rg` guardrail checks; `scripts/check.sh`. Flutter/Dart commands required SDK-cache escalation after sandbox read-only failures. | None. |
| 2026-05-27 | 04 — Design tokens and app theme | done | 0e72d36 | Added dark-first Material 3 theme tokens, metric colors, numeric typography helpers, the feature-neutral `AppCard`, and applied the RepForge theme to the localized placeholder app. | `git status --short`; `git rev-parse --short HEAD`; `flutter pub get`; `flutter gen-l10n`; `dart format --output=none --set-exit-if-changed .`; `flutter analyze`; `flutter test`; `find lib test -maxdepth 6 -type f \| sort`; requested `rg` guardrail checks; `scripts/check.sh`. | None. |
| 2026-05-27 | 05 — Navigation shell and route map | done | 9b9d23e | Added a minimal `go_router` route map, localized mobile navigation shell, placeholder destinations for Today, Groups, Exercises, Analytics, and Settings, and widget tests for routes/locales/taps. | `git status --short`; `git rev-parse --short HEAD`; `flutter pub get`; `flutter gen-l10n`; `dart format --output=none --set-exit-if-changed .`; `flutter analyze`; `flutter test`; `find lib test -maxdepth 6 -type f \| sort`; requested `rg` guardrail checks; `scripts/check.sh`. | None. |
| 2026-05-27 | 06 — Domain foundation for training log | done | 16f7501 | Added pure-Dart training-log domain value objects, stable IDs, exercise references with snapshots, the `WorkoutSet` entity, and the domain-only `WorkoutSetRepository` contract. | `git status --short`; `git rev-parse --short HEAD`; `flutter pub get`; `flutter gen-l10n`; `dart format --output=none --set-exit-if-changed .`; `flutter analyze`; `flutter test`; `find lib test -maxdepth 8 -type f \| sort`; requested training-log and dependency guardrail `rg` checks; `scripts/check.sh`. | None. |
| 2026-05-27 | 07 — Analytics formula domain tests | done | 7bd2809 | Added pure-Dart analytics formula identity, Epley estimated 1RM, workout-set summary aggregation, and period comparison helpers with focused domain tests. | `git status --short`; `git rev-parse --short HEAD`; `flutter pub get`; `flutter gen-l10n`; `dart format --output=none --set-exit-if-changed .`; `flutter analyze`; `flutter test`; `find lib test -maxdepth 8 -type f \| sort`; requested analytics/training-log and no-cloud guardrail `rg` checks; `scripts/check.sh`. | None. |
| 2026-05-27 | 08 — Drift local database foundation | done | da83acc | Added Drift/SQLite dependencies, schema version 1, generated Drift database code, and the historical `workout_sets` table with stable exercise reference snapshots and in-memory schema tests. | `git status --short`; `git rev-parse --short HEAD`; `flutter pub get`; `flutter gen-l10n`; `dart run build_runner build --delete-conflicting-outputs`; `dart format --output=none --set-exit-if-changed .`; `flutter analyze`; `flutter test`; `find lib test -maxdepth 9 -type f \| sort`; requested Drift/domain/no-cloud guardrail `rg` checks; `scripts/check.sh`. | Harden `FormulaIdentity` and `EstimatedOneRepMax` validation outside assert-only checks in a later analytics/domain mini-slice. |
| 2026-05-27 | 09 — Repository implementations and mappers | done | 19fb9db | Added `WorkoutSetMapper` and `DriftWorkoutSetRepository` for stable-ID upserts, deterministic exercise/session queries, snapshot-preserving row mapping, and invalid custom catalog snapshot detection. | `git status --short`; `git rev-parse --short HEAD`; `flutter pub get`; `flutter gen-l10n`; `dart run build_runner build --delete-conflicting-outputs`; `dart format --output=none --set-exit-if-changed .`; `flutter analyze`; `flutter test`; `find lib test -maxdepth 9 -type f \| sort`; requested repository/mapper, domain purity, UI leakage, and no-cloud guardrail `rg` checks; `scripts/check.sh`. | Harden `FormulaIdentity` and `EstimatedOneRepMax` validation outside assert-only checks in a later analytics/domain mini-slice. |
| 2026-05-27 | 10 — Dependency injection wiring | done | 2f25df4 | Wired the explicit composition root to create the local Drift database through a factory, expose the `WorkoutSetRepository` contract backed by `DriftWorkoutSetRepository`, and close owned resources idempotently from `AppDependencies`/`RepForgeApp`. | `flutter pub get` passed after SDK-cache escalation; `HOME=/tmp PUB_CACHE=/home/luki/.pub-cache /home/luki/flutter/bin/cache/dart-sdk/bin/dart run build_runner build --delete-conflicting-outputs`; `HOME=/tmp /home/luki/flutter/bin/cache/dart-sdk/bin/dart format --output=none --set-exit-if-changed .`; `HOME=/tmp /home/luki/flutter/bin/cache/dart-sdk/bin/dart analyze`; `git diff --check`; requested `find`/`rg` guardrails. | Keep hardening `FormulaIdentity` and `EstimatedOneRepMax` validation outside assert-only checks for a later analytics/domain mini-slice. |
| 2026-05-27 | 11 — Exercise catalog feature | done | acf802a | Added the versioned bundled official exercise catalog asset, pure-Dart catalog models/query contract, parser validation, Drift schema v2 catalog tables, idempotent official import, and pagination-ready Drift query repository without composition wiring or app-start import behavior. | `git status --short`; `git rev-parse --short HEAD`; `flutter pub get`; `flutter gen-l10n`; `dart run build_runner build --delete-conflicting-outputs`; `dart format --output=none --set-exit-if-changed .`; `flutter analyze`; `flutter test`; requested `find`/`rg` guardrails; `scripts/check.sh`. | Wire catalog dependencies and app-start import in a later slice when the app needs the catalog at runtime. Keep hardening `FormulaIdentity` and `EstimatedOneRepMax` validation outside assert-only checks for a later analytics/domain mini-slice. |
| 2026-05-27 | 12 — Workout groups and exercise assignment foundation | done | this commit | Added pure-Dart workout group and assignment domain contracts, Drift schema v3 group tables, mapper/repository persistence, deterministic paginated group and assignment queries, nullable UTC archive timestamp round-trip, and invalid custom assignment catalog-snapshot validation. | `git status --short`; `git rev-parse --short HEAD`; `flutter pub get`; `flutter gen-l10n`; `dart run build_runner build --delete-conflicting-outputs`; `dart format --output=none --set-exit-if-changed .`; `flutter analyze`; `flutter test`; requested `find`/`rg` guardrails; `scripts/check.sh`. | Wire workout group repository into composition in a later UI/application slice. Keep hardening `FormulaIdentity` and `EstimatedOneRepMax` validation outside assert-only checks for a later analytics/domain mini-slice. |
