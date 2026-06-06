# Test Strategy

## TDD priority

Write tests first for domain/application/data logic. For UI-heavy slices, write BLoC and widget tests before implementation where practical.

## Unit tests

Required for:

- value objects,
- analytics formulas,
- 1RM estimates,
- muscle-load calculations,
- imbalance detection,
- readiness scoring,
- recommendation rules,
- catalog import validation,
- migration logic.

## BLoC/Cubit tests

Required for:

- exercise catalog search/filter,
- workout group editing,
- set logging,
- analytics dashboard loading,
- recommendation screen states,
- quick session flow.

## Widget tests

Required for critical UI:

- add/edit set form,
- exercise detail timeline,
- workout group screen,
- onboarding profile steps,
- recommendation cards,
- analytics metric cards.

Slice 50b adds focused widget coverage for the first wired MVP UI integration:
Exercises page loading/empty/error/success/search states, Groups page
loading/empty/error/success/semantic summaries, Today quick-log enabled and
refresh behavior, the compact quick-log dialog save path through `SaveWorkoutSet`,
and route smoke tests that assert Groups and Exercises are no longer only
placeholders.

Slice 51 extends Analytics widget coverage for the muscle load dashboard:
loading, empty, balanced/on-track, under-target, over-emphasized,
partial/unknown activation, recovery-limited, English/German localization,
semantic labels, suggested actions, and medical/shaming wording guardrails.

Slice 57 extends Train/Groups widget coverage for the relabeled Train entry
point: loading, empty, error, split landing, deterministic category counts,
semantic category summaries, category drill-in, category-scoped search,
English/German localization, route smoke behavior, and visible navigation
labels. Category classification remains presentation/read-model behavior and
does not create domain coaching claims.

Slice 58 extends Exercise Detail coverage: Train and Exercises tap-through to
detail, loading/empty/error/success states, bounded history requests,
date-grouped set history, previous-comparable metric deltas, unavailable
previous-session copy, preselected Log Set behavior, refresh after save,
English/German localization, and semantic labels for Analytics, 1RM, Log Set,
and set rows.

Slice 59 extends exercise-level analytics chart coverage: Exercise Detail
Analytics and 1RM card navigation, chart loading/empty/error/one-point/
multi-point states, deterministic metric and range selector behavior, selected
point summaries with metric value and local date/time, estimated-1RM
unavailable copy, English/German localization, selector/chart/summary
semantics, and proof that the UI uses bounded timeline loading instead of
unbounded exercise history.

Slice 60 extends Exercise Detail post-logging coverage: after a successful Log
Set save, history still refreshes and a compact adaptive next-set signal can
appear. Tests cover bounded two-set adapter inputs, insufficient-history copy,
add-weight, add-rep, maintain, low-readiness backoff, dismiss behavior, no
blocking modal, English/German localization, and semantics.

Slice 61 adds pending focused coverage for lightweight workout-session state:
application tests for starting, refreshing, streaming, and completing a session;
quick-log widget tests for standalone logging and active-session attachment;
Train tests for no-active, start, active metrics, and completion summary; Today
and Exercise Detail tests for the shared active-session banner and existing
refresh/adaptive behavior. These tests still require generated localization
files and Flutter validation once SDK-cache access is available.

## Integration/E2E tests

Critical flow:

1. Launch app.
2. Complete minimal onboarding.
3. Create or use workout group.
4. Select exercise.
5. Log set.
6. See rest timer.
7. See set in timeline.
8. See analytics update.

Slice 29 adds the first compact integration-style logging harness under
`test/src/integration/`. It runs as a normal Flutter widget test so local and CI
validation do not require a connected device. The harness uses in-memory Drift,
the bundled official catalog asset, real logging/analytics use cases, fake rest
timer notifications, and existing Today/Analytics UI seams.

Run it directly with:

```bash
flutter test test/src/integration
```

## Large-history tests

Slice 31 adds deterministic large-seed coverage instead of timing
microbenchmarks. Performance-oriented tests should assert bounded page sizes,
stable ordering under timestamp ties, date/range limits, additive index
migrations, and aggregate results without depending on wall-clock timing.

## Purchase gateway tests

Slice 33 purchase tests must use fake `PurchaseGateway` implementations. They
should assert product loading, deterministic purchase events, cancellation,
failure, pending state, restore calls, and entitlement mapping without invoking
real app-store APIs, platform services, accounts, network, backend, receipts, or
files. Store/plugin code is covered indirectly through static analysis and kept
thin behind the gateway adapter.

## Purchase verification and cache tests

Slice 34 verification tests must use fake `PurchaseVerificationSource`
implementations. They should assert that provisional store events do not unlock
Premium, verified RepForge Premium results unlock only prepared future Premium
gates, expired/revoked/unavailable/stale/unverified states stay conservative,
local MVP gates remain free, and entitlement-cache entries are created only for
verified snapshots with bounded fresh/stale/expired behavior. Tests must not use
real store, server, network, account, receipt, token, Firebase, RevenueCat,
Supabase, or cloud calls.

## Auth boundary tests

Slice 35 auth tests must use fake `AuthGateway` implementations or the
`LocalOnlyAuthGateway`. They should assert local-only behavior, deterministic
authenticated/expired/unavailable/failed states, sign-out isolation from local
settings/workout data, no auth-based Premium unlock, and no auth requirement for
purchase verification. Tests must not invoke real auth providers, network,
platform services, backend calls, cloud services, files, or token handling.

## Firebase boundary tests

Slice 36 Firebase tests must use fake `FirebaseInitializationGateway`
implementations or the default unavailable no-op gateway. They should assert
disabled-by-default behavior, explicit capability flags, deterministic
initialized/unavailable/failed states, no Firebase requirement for local MVP
features, local rest-timer notification separation from remote push/FCM,
local-only auth defaults, and domain import purity. Tests must not invoke real
Firebase SDKs, Firebase config files, network, platform services, accounts,
remote push, Crashlytics, Remote Config, Firestore, sync, or analytics SDK
events.

## Sync metadata tests

Slice 37 sync tests cover only pure-Dart metadata and conflict-policy behavior.
They should assert local-only defaults, no local MVP dependency on sync
metadata, official catalog separation from user-data sync, deterministic
tombstones, deterministic version/conflict policy, no auth requirement for
local-only mode, Firebase-disabled behavior, and domain import purity.

Tests must not invoke real network, cloud, Firebase, Firestore, provider SDKs,
remote APIs, background jobs, accounts, upload/download flows, file IO, or a
production sync engine.

## Remote push boundary tests

Slice 38 Remote Push tests must use fake `RemotePushGateway` implementations or
the default unavailable gateway. They should assert disabled-by-default
behavior, deterministic registered/unavailable/permission-denied/
token-unavailable/failed states, no token request while disabled, no auth
requirement for local-only use, no sync activation, Firebase-unavailable
separation, and local rest-timer notification behavior.

Tests must not invoke real Firebase Messaging, FCM/APNS token APIs, platform
push services, network, backend registration, accounts, upload/download flows,
remote message handlers, or notification SDKs for Remote Push.

## Wearable and calorie boundary tests

Slice 53 is documentation-only, so it adds no test files. Future wearable or
calorie implementation slices must keep tests pure Dart until a production
provider adapter is explicitly scoped.

Required future coverage:

- default wearable status is disabled/unavailable/not requested,
- fake wearable gateways never upload data, require accounts, start sync, or
  call backend/Firebase/cloud services,
- missing duration or required formula inputs make calorie estimates
  unavailable,
- incomplete profile or heart-rate inputs produce low-confidence rough
  estimates rather than exact claims,
- deterministic formula output for valid fixture inputs,
- invalid or negative duration is rejected,
- invalid heart-rate samples are rejected,
- normalized wearable sample mapping is deterministic and strips provider
  payloads,
- disconnect/delete/export behavior is explicit before health data is persisted,
- domain imports no Flutter, Drift, platform, HealthKit, Health Connect, Google
  Fit, wearable SDK, backend, Firebase, or account dependencies.

Tests must not request real health permissions, use HealthKit, Health Connect,
Google Fit, wearable SDKs, platform services, network, backend APIs, cloud
analytics, Firebase, sync engines, accounts, or paid runtime services.

## Social and friends boundary tests

Slice 54 is documentation-only, so it adds no test files. Future social
implementation slices must start with pure-Dart boundary tests and fake gateways
before adding backend adapters or UI.

Required future coverage:

- social disabled by default,
- local tracking, catalog access, analytics, settings, backup/export/import,
  readiness, recommendations, purchases, and entitlements do not require social
  or accounts,
- activity privacy defaults to private/local-only,
- user consent and first-share preview are required before any shareable summary
  leaves the device,
- `ShareableTrainingSummary` excludes exact sets/reps/loads, comments, notes,
  body metrics, readiness, soreness, injury/pain context, wearable/health data,
  backups, location, precise timestamps, purchase state, and raw local database
  records by default,
- selected-friends/friends-only/public visibility behavior is deterministic,
- revoke/delete/unshare, block, mute, and report state changes are explicit,
- fake social gateways never upload while disabled, require accounts for local
  features, activate sync, initialize Firebase/Firestore, request remote push
  tokens, or call backend services without explicit configuration,
- domain imports no Flutter, Drift, platform, Firebase, Firestore, backend,
  account-provider SDK, notification SDK, or sync-engine dependencies.

Tests must not invoke real social providers, network, Firebase, Firestore,
backend APIs, account providers, contact discovery, remote push services,
moderation services, upload/download flows, files, or paid runtime services.

## Golden/visual tests

Use for stable components after design tokens mature:

- metric card,
- recommendation card,
- muscle load card,
- set timeline row,
- rest timer banner.

Slice 28 establishes the initial small baseline with Flutter's built-in
`matchesGoldenFile` support under `test/goldens/`. Golden tests must use fixed
surface sizes, fixed locale/theme wrappers, deterministic fake data, and no
real database, platform services, timers, network, or cloud state. Keep the
suite intentionally small; update approved baselines with:

```bash
flutter test --update-goldens
```

Slice 56 updates only the Today success golden baseline after confirming the
diff reflects intentional readiness/dashboard UI content. Future golden updates
should stay similarly isolated: reproduce the diff, inspect the generated
master/test/diff images, update only the affected baseline, and keep failure
artifacts out of commits.

## Catalog tests

Official exercise catalog must have:

- offline repository validation through `dart run tool/validate_catalog.dart`,
- manifest validation and bundled asset-reference checks,
- JSON schema/shape validation,
- stable ID validation,
- duplicate ID detection,
- localized English/German name validation,
- optional localized alias/synonym validation when those fields are present,
- equipment, movement-pattern, and muscle tag list validation,
- known-value validation for enum-like catalog tags,
- duplicate per-exercise equipment, movement-pattern, and muscle values rejected,
- import idempotency test,
- version-aware import detection,
- snapshot-preservation tests for workout sets and workout group assignments,
- migration/import test with previous catalog fixture.

Slice 52 adds fixture tests for the catalog patch validator covering current
bundled success, manifest asset/version mismatch, unsupported schema versions,
blank/duplicate/misformatted IDs, missing English/German names, missing or
unknown equipment, unknown movement patterns, missing or unknown muscles,
duplicate tags/muscles, optional aliases, optional activation-weight ranges, and
stable-ID removal detection.

The current catalog asset schema still uses primary/secondary muscle metadata,
not first-class activation weights. The validator rejects invalid activation
weights when optional future activation fields are present; broader catalog
activation semantics belong to a later catalog asset schema slice.

## Backup and compatibility tests

Backup/import compatibility tests must prove that user-owned local data remains
exportable and importable without silently mutating unrelated data. Coverage
should include workout sets with stable exercise refs and snapshots, workout
groups and assignments, settings/profile and equipment constraints, onboarding
status, catalog import metadata, and readiness check-ins.

Backups should not include full bundled official catalog rows. Tests should
assert stable refs/snapshots are preserved instead of expecting a fresh import
to recreate official catalog content from backup JSON. Unsupported export or
schema versions, malformed payloads, duplicate ids, invalid set values, invalid
settings/equipment, and invalid readiness ratings must fail deterministically
before import.

## Muscle activation tests

Slice 45 muscle activation tests live under
`test/src/features/analytics/domain/` and must stay pure Dart. They should cover
stable muscle ids, bounded activation weights, known and unavailable exercise
activation profiles, duplicate muscle-entry rejection, deterministic estimated
load aggregation, zero-load behavior, incomplete/bodyweight-style load
confidence, explicit unknown exercises, and preservation of existing
`WorkoutSet` history.

## Muscle balance tests

Slice 46 muscle balance tests live under
`test/src/features/analytics/domain/` and must stay pure Dart. They should cover
empty and insufficient histories, balanced full-body history, push-heavy signals,
pull-neglect signals, leg-neglect signals, focus-aware upper/lower target ranges,
unknown activation evidence, movement-pattern gaps, non-diagnostic API wording,
and preservation of supplied `MuscleLoadEstimate` inputs.

## Readiness check-in tests

Slice 47 readiness tests live under `test/src/features/recovery/` and must keep
domain/application logic pure Dart. They should cover bounded soreness,
sleep-quality, energy, stress, and motivation validation; deterministic scoring
and readiness level mapping; high-soreness behavior; explicit empty state;
non-diagnostic/non-blocking API wording; Drift save/load/latest ordering; date
filtering; backup export/import; and preservation of workout sets, catalog
rows, groups, and profile data when readiness check-ins are saved.

## Recommendation engine tests

Slice 48 recommendation tests live under `test/src/features/recommendations/`
and must keep domain/application logic pure Dart. They should cover empty and
partial input quality, deterministic ordering and tie-breaking, equipment
filtering, max-load adjustment, focus-aware scoring, muscle-balance priorities,
readiness/soreness down-ranking, alternatives, substitution/exclusion
recomputation, advisory/non-blocking behavior, sex/gender-neutral behavior, and
domain import guardrails.

## Quick session tests

Slice 49 quick-session tests live under
`test/src/features/recommendations/` and must keep domain/application logic pure
Dart. They should cover 15/25/35-minute plan sizes, unavailable inputs, limited
equipment, max-load adjustment propagation, high-soreness/readiness behavior,
muscle-balance priorities, balanced fallback, covered/skipped muscles and
movement patterns, stable tie-breaking, advisory/non-replacement semantics, and
domain import guardrails.

## Adaptive set suggestion tests

Slice 50 adaptive-set tests live under
`test/src/features/recommendations/` and must keep domain/application logic pure
Dart. They should cover no-history starter guidance, good-readiness progression,
max-load and increment handling, low-readiness backoff, very-high-soreness
suppression, strength-down backoff, baseline matching and small dips,
alternative surfacing, user override/advisory semantics, missing-RPE behavior,
deterministic reason codes, non-medical/non-forcing API wording, and domain
import guardrails.

## Profile and equipment tests

Slice 44 profile tests must cover pure-Dart value object validation, explicit
unknown/skipped profile states, focus and goal representation, recovery
sensitivity, coaching strictness, structured equipment inventory, max-load and
increment constraints, local save/load roundtrips, additive migration behavior,
and preservation of workout sets, catalog rows, and workout groups when settings
are saved.

Tests must not encode sex/gender stereotypes or require Premium, auth, Firebase,
cloud sync, backend services, account state, wearables, calorie estimation, or a
recommendation engine for local profile use.

## Validation commands

```bash
flutter pub get
flutter gen-l10n
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

The same local quality gate is available through:

```bash
scripts/check.sh
```

## CI execution

Slice 39 CI runs generated-code checks before formatting, analysis, and tests.
The workflow executes localization generation, Drift/source generation,
`git diff --exit-code -- lib test`, `flutter test`, and
`flutter test test/src/integration`. Golden tests are included in the normal
test suite and should be updated only through a deliberate local
`flutter test --update-goldens` run.

Add as applicable:

```bash
flutter test integration_test
flutter build apk --debug
flutter build appbundle --release
```
