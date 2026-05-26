# Slice 52 — Catalog patch workflow and validation tooling

## Goal

Add repository tooling and CI checks for weekly bundled exercise catalog patches.

## Read first

1. `AGENTS.md`
2. `docs/02-architecture/exercise_catalog_distribution.md`
3. `docs/04-quality/test_strategy.md`
4. `docs/04-quality/ci_cd.md`
5. `docs/06-slices/slice_52_catalog_patch_workflow.md`

## Non-goals

- Do not add cloud database.
- Do not auto-download unsigned content.
- Do not change app release pipeline beyond necessary checks.

## TDD requirements

Write validation tests/scripts for catalog schema, stable IDs, aliases, and activation ranges before implementation.

## Implementation requirements

- Add developer command for catalog validation.
- Document weekly patch process.
- Add CI gate if practical.
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
chore(catalog): add catalog patch validation workflow
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/02-architecture/exercise_catalog_distribution.md
3. docs/04-quality/test_strategy.md
4. docs/04-quality/ci_cd.md
5. docs/06-slices/slice_52_catalog_patch_workflow.md

Implement Slice 52: Catalog patch workflow and validation tooling.

Goal:
Add repository tooling and CI checks for weekly bundled exercise catalog patches.

Non-goals:
- Do not add cloud database.
- Do not auto-download unsigned content.
- Do not change app release pipeline beyond necessary checks.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write validation tests/scripts for catalog schema, stable IDs, aliases, and activation ranges before implementation.

Implementation requirements:
- Add developer command for catalog validation.
- Document weekly patch process.
- Add CI gate if practical.

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
`chore(catalog): add catalog patch validation workflow`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
