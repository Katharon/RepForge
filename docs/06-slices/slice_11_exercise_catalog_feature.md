# Slice 11 — Exercise catalog feature

## Goal

Implement the first small, local-first official exercise catalog foundation:
versioned bundled JSON asset, pure-Dart catalog domain/query types,
deterministic parser validation, additive Drift persistence, idempotent
official-catalog import, and pagination-ready repository queries.

## Implemented scope

- Added `assets/catalog/official_exercises_v1.json` with catalog version
  `2026.05.0`, schema version `1`, English/German exercise names, equipment
  tags, movement patterns, and basic muscle metadata.
- Added pure-Dart catalog domain types for official exercises, catalog version,
  equipment tags, muscle groups, movement patterns, paginated queries, and
  repository contract.
- Added a data-layer parser that accepts JSON string/decoded input and rejects
  invalid catalog shape before import.
- Added Drift schema version `2` with official-only catalog tables and
  `catalog_imports`.
- Added an idempotent importer and Drift repository with explicit
  `limit`/`offset` query APIs plus search/equipment/muscle filtering.
- Added parser, import, non-destructive workout-set, and query tests.

## Non-goals

- No UI, BLoC/Cubit, navigation, app-start import behavior, or composition-root
  wiring.
- No custom exercise creation/editing/archive flows.
- No user overrides, hide/favorite behavior, workout groups, set logging UI, or
  analytics UI.
- No recommendation/coach logic.
- No remote fetching, backend, cloud database, Firebase, ads, payments, sync, or
  paid runtime service.

## Implementation notes

The Slice 11 prompt intentionally narrowed the older broad catalog-feature plan.
Composition wiring and app-start catalog import are deferred to a later slice so
this slice remains a reviewable catalog foundation only.

Catalog queries use explicit offset pagination for the small official catalog.
Future large workout-set history lists should prefer cursor/keyset paging over
`performedAt` plus stable ID rather than large offset paging.

Official catalog imports write only official catalog tables and do not mutate
`workout_sets`; logged set snapshots remain the source of historical display
truth.

## Validation commands

```bash
git status --short
git rev-parse --short HEAD
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
scripts/check.sh
```

Additional Slice 11 guardrails check catalog identifiers, pagination terms,
cloud/backend dependency bans, and domain purity.

## Commit message

```text
feat(catalog): add official exercise catalog foundation
```
