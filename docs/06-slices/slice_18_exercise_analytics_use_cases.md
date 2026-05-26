# Slice 18 — Exercise analytics use cases

## Goal

Implement application/domain analytics use cases for sets, repetitions, volume, kg/rep, previous comparable session delta, time-window delta, and estimated metric read models.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/analytics_formulas.md`
3. `docs/01-domain/domain_rules.md`
4. `docs/02-architecture/data_persistence.md`
5. `docs/06-slices/slice_18_exercise_analytics_use_cases.md`

## Non-goals

- Do not implement charts UI.
- Do not implement muscle activation analytics yet unless data already exists.
- Do not add remote analytics SDKs.

## TDD requirements

Write formula and use-case tests first, including empty histories, zero baselines, previous-session comparisons, and time-window comparisons.

## Implementation requirements

- Build read models usable by UI.
- Support date-range filtering.
- Make previous-session and time-window delta semantics explicit.
- Return confidence/empty states instead of throwing for missing data.
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
feat(analytics): add exercise analytics use cases
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/analytics_formulas.md
3. docs/01-domain/domain_rules.md
4. docs/02-architecture/data_persistence.md
5. docs/06-slices/slice_18_exercise_analytics_use_cases.md

Implement Slice 18: Exercise analytics use cases.

Goal:
Implement application/domain analytics use cases for sets, repetitions, volume, kg/rep, previous comparable session delta, time-window delta, and estimated metric read models.

Non-goals:
- Do not implement charts UI.
- Do not implement muscle activation analytics yet unless data already exists.
- Do not add remote analytics SDKs.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write formula and use-case tests first, including empty histories, zero baselines, previous-session comparisons, and time-window comparisons.

Implementation requirements:
- Build read models usable by UI.
- Support date-range filtering.
- Make previous-session and time-window delta semantics explicit.
- Return confidence/empty states instead of throwing for missing data.

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
`feat(analytics): add exercise analytics use cases`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
