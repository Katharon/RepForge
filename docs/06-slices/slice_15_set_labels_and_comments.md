# Slice 15 — Set labels and comments

## Goal

Implement labels such as None/Failure and comments across domain, data, and UI.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/domain_rules.md`
3. `docs/00-project/screenshot_inventory.md`
4. `docs/06-slices/slice_15_set_labels_and_comments.md`

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

Write BLoC/use-case/widget tests for the main interaction first.

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
feat(training-log): add set labels and comments
```

## Implementation note

Slice 15 implemented a compact foundation only:

- Added `WorkoutSetLabel` as a pure-Dart enum with stable storage values:
  `none`, `warmup`, `failure`, `personalRecord`, `dropSet`, and `pain`.
- Added `WorkoutSet.label` with default `none` semantics while preserving the
  existing optional `SetComment` behavior.
- Extended `WorkoutSetForm` and the Slice 14 save/update use cases to carry
  label input, with blank label input mapping to `none`.
- Bumped Drift to schema version 4 and additively added nullable
  `workout_sets.set_label`; existing rows with null or empty labels map to
  `none`, while unsupported non-empty labels fail deterministically through
  training-log validation.
- Updated repository/mapper tests so labels round-trip through save/find,
  update, history, timeline, and legacy-row reads.

Labels are intentionally a single small marker for MVP. They may later inform
analytics, coach guidance, stimulus, and muscle-load calculations, but this
slice does not implement those features.

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/domain_rules.md
3. docs/00-project/screenshot_inventory.md
4. docs/06-slices/slice_15_set_labels_and_comments.md

Implement Slice 15: Set labels and comments.

Goal:
Implement labels such as None/Failure and comments across domain, data, and UI.

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
Write BLoC/use-case/widget tests for the main interaction first.

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
`feat(training-log): add set labels and comments`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
