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

## Catalog tests

Official exercise catalog must have:

- manifest validation and bundled asset-reference checks,
- JSON schema/shape validation,
- stable ID validation,
- duplicate ID detection,
- localized English/German name validation,
- equipment, movement-pattern, and muscle tag list validation,
- import idempotency test,
- version-aware import detection,
- snapshot-preservation tests for workout sets and workout group assignments,
- migration/import test with previous catalog fixture.

Catalog parser activation-weight validation belongs to a later catalog asset
schema slice; Slice 45 covers the pure analytics-domain activation weight model.

## Muscle activation tests

Slice 45 muscle activation tests live under
`test/src/features/analytics/domain/` and must stay pure Dart. They should cover
stable muscle ids, bounded activation weights, known and unavailable exercise
activation profiles, duplicate muscle-entry rejection, deterministic estimated
load aggregation, zero-load behavior, incomplete/bodyweight-style load
confidence, explicit unknown exercises, and preservation of existing
`WorkoutSet` history.

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
