# Slice 29 — Integration/E2E workout logging flow

## Goal

Add integration tests for create exercise, log set, edit set, analytics visibility, and timer.

## Read first

1. `AGENTS.md`
2. `docs/04-quality/test_strategy.md`
3. `docs/04-quality/acceptance_criteria.md`
4. `docs/00-project/product_requirements.md`
5. `docs/06-slices/slice_29_integration_e2e_workout_logging_flow.md`

## Current assumptions

- Work from the current repository state.
- Keep changes limited to this slice.
- Keep documentation synchronized with implementation.
- Prefer the smallest production-quality increment over a broad prototype.

## Non-goals

- Do not implement later slices.
- Do not change unrelated architecture decisions.
- Do not add packages unless necessary for this slice.

## TDD requirements

Add/keep a minimal widget test and verify analysis catches errors.

If strict TDD is impractical because this is a repository/bootstrap slice, explain why and add the earliest possible smoke test.

## Implementation requirements

- Follow `AGENTS.md`.
- Keep layer boundaries from the architecture docs.
- Use explicit, readable names from the ubiquitous language.
- Handle loading, empty, error, and success states where this slice touches UI.
- Add fakes/mocks instead of using real platform services in unit tests.
- Update affected docs if implementation decisions differ from the initial plan.

## Acceptance criteria

- Slice goal is implemented.
- Tests required by this slice are added or updated.
- Formatting passes.
- Static analysis passes.
- All relevant tests pass.
- `docs/05-codex/slice_status.md` is updated.
- No unrelated future feature is introduced.

## Implementation note

Slice 29 was implemented as a deterministic integration-style widget harness in
`test/src/integration/workout_logging_flow_test.dart`. The harness imports the
bundled official catalog into an in-memory Drift database, searches and selects
Barbell Bench Press, logs and edits one set through the existing training-log
use cases, verifies persisted history/read-back, renders Today and Analytics
through their existing UI seams, and starts a fake rest timer without real local
notifications or a connected device.

The repository does not yet have a production workout execution screen, so no
large UI surface was added. The test-only logging surface is intentionally small
and exists only to exercise the current architectural seams end to end.

Run the slice-specific harness with:

```bash
flutter test test/src/integration
```

## Validation commands

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Add slice-specific commands if appropriate, such as:

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
test(e2e): cover core workout logging flow
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/04-quality/test_strategy.md
3. docs/04-quality/acceptance_criteria.md
4. docs/00-project/product_requirements.md
5. docs/06-slices/slice_29_integration_e2e_workout_logging_flow.md

Implement Slice 29: Integration/E2E workout logging flow.

Goal:
Add integration tests for create exercise, log set, edit set, analytics visibility, and timer.

Non-goals:
- Do not implement later slices.
- Do not change unrelated architecture decisions.
- Do not add packages unless necessary for this slice.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Add/keep a minimal widget test and verify analysis catches errors.

Implementation requirements:
- Make the smallest complete production-quality change for this slice.
- Keep naming aligned with the ubiquitous language and docs.
- Add loading/empty/error handling for UI touched by this slice.
- Use fakes/mocks for platform services in tests.

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
`test(e2e): cover core workout logging flow`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
