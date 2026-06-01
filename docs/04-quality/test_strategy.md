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

- JSON schema/shape validation,
- stable ID validation,
- duplicate alias detection,
- activation weights within valid range,
- import idempotency test,
- migration/import test with previous catalog fixture.

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

Add as applicable:

```bash
flutter test integration_test
flutter build apk --debug
flutter build appbundle --release
```
