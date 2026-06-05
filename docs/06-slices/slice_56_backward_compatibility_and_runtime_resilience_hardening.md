# Slice 56 - Backward Compatibility and Runtime Resilience Hardening

## Goal

Harden RepForge's backward compatibility and runtime resilience before the next
stability milestone. Keep the work focused on local data import/export, Drift
migration expectations, generated assets, app startup/catalog resilience, and
known recurring test failures.

This is a hardening slice, not a product feature slice. It must not add cloud
services, backend runtime, sync activation, Firebase/Firestore runtime, social
runtime, health/wearable permissions, ads, payment changes, recommendation
features, analytics features, workout UI features, or broad UI redesigns.

## Implementation Summary

- Normalized Slice 55 status to the committed hash `c34ae51`.
- Added backup-domain coverage for readiness check-in JSON parsing and
  deterministic readiness rating validation errors.
- Added Drift backup repository coverage proving readiness check-ins export and
  import with stable ids, preserved instants, and bounded values.
- Clarified the archive/delete policy test for backup import: readiness,
  workout-set stable refs, display-name snapshots, and workout groups are
  preserved, while full official catalog rows are not exported into a fresh
  database.
- Updated the Today success golden baseline for the already-introduced
  readiness/dashboard content after verifying the diff was intentional and
  isolated.

No runtime feature, schema migration, dependency, permission, backend, Firebase,
sync, social, wearable/health, ads, or payment behavior changed in this slice.

## Compatibility Notes

- Drift remains at schema version 9. No schema migration was required.
- `readiness_checkins` remains additive user-owned local data and is included in
  local backups through the optional `readinessCheckIns` array.
- Older backups without `readinessCheckIns` still import as an empty readiness
  list.
- Unsupported backup `exportVersion` or `schemaVersion` values continue to be
  rejected deterministically before import.
- Official catalog rows remain bundled/imported runtime data and are not
  exported as full backup content. Backups preserve user-owned stable exercise
  refs and display-name/catalog-version snapshots for logged sets and group
  assignments.
- Catalog import behavior remains idempotent and version-aware through bundled
  assets and local import metadata.

## Known Failure Follow-up Resolution

- `test/src/shared/data/local/archive_delete_policy_test.dart`: fixed by
  clarifying the official-catalog backup policy and pinning readiness export
  before import.
- `test/goldens/repforge_golden_test.dart`: fixed by updating only
  `goldens/today_success.png` after confirming the diff reflected intentional
  Today readiness/dashboard UI additions, not an unintended layout regression.

## Validation

Run and report:

```bash
git status --short
git rev-parse --short HEAD
git log --oneline -8
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart run tool/validate_catalog.dart
git diff --check
git diff --exit-code -- lib test || true
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test test/src/shared/data/local
flutter test test/src/features/recovery
flutter test test/src/features/settings
flutter test test/src/features/exercise_catalog
flutter test test/src/features/training_log
flutter test test/src/features/today
flutter test test/goldens || true
flutter test test/src/integration
scripts/check.sh
flutter build apk --debug
```

## Follow-ups

- Keep future Drift migrations additive and covered by migration tests.
- Keep backup/import tests aligned with the local-first policy: user-owned data
  and stable snapshots are exportable, but bundled official catalog rows are not
  exported as a full catalog dump.
- Public release remains blocked on the existing owner/legal/store/trademark
  follow-ups documented in Slice 55 and release-management docs.
