# Slice 11 — Exercise catalog feature

## Goal

Implement the exercise catalog UI/use cases for official bundled exercises and custom exercises, including search, filters, create/edit/archive custom exercises, hide/favorite official exercises, and source disambiguation.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/domain_map.md`
3. `docs/02-architecture/exercise_catalog_distribution.md`
4. `docs/03-design-ux/information_architecture.md`
5. `docs/02-architecture/state_management_bloc.md`
6. `docs/06-slices/slice_11_exercise_catalog_feature.md`

## Non-goals

- Do not use a remote/cloud exercise database.
- Do not implement recommendation engine yet.
- Do not implement social or wearable features.

## TDD requirements

Write use-case/BLoC/widget tests for listing, searching, filtering, creating a custom exercise, and hiding/favoriting an official exercise before implementation.

## Implementation requirements

- List official and custom exercises together with clear source handling.
- Search by name/alias.
- Filter by equipment, muscle, movement pattern, and favorites if data exists.
- Persist user overrides separately from official definitions.
- Keep official definitions immutable in UI.
- Follow `AGENTS.md`.
- Keep layer boundaries from the architecture docs.
- Handle loading, empty, error, and success states where UI is touched.
- Update affected docs if implementation decisions differ from the plan.

## Acceptance criteria

- Slice goal is implemented.
- Tests required by this slice are added or updated.
- Formatting passes.
- Static analysis passes.
- All relevant tests pass.
- `docs/05-codex/slice_status.md` is updated.
- No unrelated future feature is introduced.

## Validation commands

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Add slice-specific commands if appropriate:

```bash
flutter test integration_test
flutter build apk --debug
```

## Documentation updates

Update these if changed by implementation:

- `docs/05-codex/slice_status.md`
- Any architecture/domain/UX document made stale by this slice
- `CHANGELOG.md` only for user-visible or release-relevant changes

## Commit message

```text
feat(exercise-catalog): implement local exercise catalog
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/domain_map.md
3. docs/02-architecture/exercise_catalog_distribution.md
4. docs/03-design-ux/information_architecture.md
5. docs/02-architecture/state_management_bloc.md
6. docs/06-slices/slice_11_exercise_catalog_feature.md

Implement Slice 11: Exercise catalog feature.

Goal:
Implement the exercise catalog UI/use cases for official bundled exercises and custom exercises, including search, filters, create/edit/archive custom exercises, hide/favorite official exercises, and source disambiguation.

Non-goals:
- Do not use a remote/cloud exercise database.
- Do not implement recommendation engine yet.
- Do not implement social or wearable features.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write use-case/BLoC/widget tests for listing, searching, filtering, creating a custom exercise, and hiding/favoriting an official exercise before implementation.

Implementation requirements:
- List official and custom exercises together with clear source handling.
- Search by name/alias.
- Filter by equipment, muscle, movement pattern, and favorites if data exists.
- Persist user overrides separately from official definitions.
- Keep official definitions immutable in UI.

Validation commands:
```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```
Run stronger commands if applicable:
```bash
flutter test integration_test
flutter build apk --debug
```

Documentation:
- Update docs/05-codex/slice_status.md.
- Update any affected docs if implementation reveals a stale or wrong assumption.

Commit:
Create one git commit with this exact message:
`feat(exercise-catalog): implement local exercise catalog`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```

## v5 adjustment

Exercise catalog must support localized names, equipment requirements, movement patterns, and future load constraints. Start with a small validated base catalog.
