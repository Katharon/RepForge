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

## Golden/visual tests

Use for stable components after design tokens mature:

- metric card,
- recommendation card,
- muscle load card,
- set timeline row,
- rest timer banner.

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
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Add as applicable:

```bash
flutter test integration_test
flutter build apk --debug
flutter build appbundle --release
```
