# Slice 12 — Workout groups and exercise assignment foundation

## Goal

Implement user-defined workout groups such as Push Day, Pull Day, Leg Day, and allow assigning ordered official/custom exercises to each group.

## Read first

1. `AGENTS.md`
2. `docs/00-project/product_requirements.md`
3. `docs/01-domain/domain_map.md`
4. `docs/03-design-ux/information_architecture.md`
5. `docs/06-slices/slice_12_workout_program_list_and_edit_foundation.md`

## Non-goals

- Do not implement recommendation ordering yet.
- Do not implement advanced analytics yet.
- Do not rename existing domain concepts outside this slice unless required.

## TDD requirements

Write domain/use-case/BLoC tests for create group, rename group, reorder group, add exercise, remove exercise, and archive group before implementation.

## Implementation requirements

- Use the product term Workout Group for user-facing grouping.
- Allow exercises from official catalog and custom exercises.
- Preserve historical sets if an exercise is removed from a group.
- Support basic ordering.
- Prepare UI for later recommended order without implementing recommendation logic.
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
feat(training-log): add workout groups and exercise assignment
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/00-project/product_requirements.md
3. docs/01-domain/domain_map.md
4. docs/03-design-ux/information_architecture.md
5. docs/06-slices/slice_12_workout_program_list_and_edit_foundation.md

Implement Slice 12: Workout groups and exercise assignment foundation.

Goal:
Implement user-defined workout groups such as Push Day, Pull Day, Leg Day, and allow assigning ordered official/custom exercises to each group.

Non-goals:
- Do not implement recommendation ordering yet.
- Do not implement advanced analytics yet.
- Do not rename existing domain concepts outside this slice unless required.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write domain/use-case/BLoC tests for create group, rename group, reorder group, add exercise, remove exercise, and archive group before implementation.

Implementation requirements:
- Use the product term Workout Group for user-facing grouping.
- Allow exercises from official catalog and custom exercises.
- Preserve historical sets if an exercise is removed from a group.
- Support basic ordering.
- Prepare UI for later recommended order without implementing recommendation logic.

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
`feat(training-log): add workout groups and exercise assignment`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
