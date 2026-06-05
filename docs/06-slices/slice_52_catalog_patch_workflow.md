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

## Implementation note

Slice 52 adds an offline repository command:

```bash
dart run tool/validate_catalog.dart
```

The command validates bundled official catalog patch content without network
access. It checks the manifest and catalog assets, supported schema versions,
manifest/catalog version consistency, stable snake_case exercise IDs, duplicate
IDs, English/German localized names, known equipment tags, known movement
patterns, known primary and secondary muscles, duplicate per-exercise
equipment/pattern/muscle values, localized aliases/synonyms if present, and
future-ready activation-weight fields if they appear.

The current bundled schema does not yet contain first-class activation weights.
Slice 52 therefore validates primary/secondary muscle metadata and rejects
out-of-range activation weights only when optional activation fields are added
to a fixture or future catalog asset. `tool/catalog_stable_ids_baseline.json`
pins the official IDs released in catalog version `2026.06.0`; future patches
may add IDs, but removed or renamed released IDs fail validation.

The local quality script and GitHub Actions quality job now run the validator.
This is tooling only: it does not add UI, runtime remote fetching, cloud
database behavior, Firebase, sync, account requirements, or paid runtime
services.

Weekly patch workflow:

1. Edit bundled JSON under `assets/catalog/`.
2. Bump `catalogVersion` when content changes.
3. Update `assets/catalog/catalog_manifest.json` if the current asset path,
   catalog version, schema version, or notes change.
4. Preserve all IDs listed in `tool/catalog_stable_ids_baseline.json`;
   deprecate in a later schema instead of deleting or renaming released IDs.
5. Run `dart run tool/validate_catalog.dart`.
6. Run catalog tests and the normal quality gate.
7. Review localization, aliases, equipment, movement patterns, and muscle
   metadata in the pull request.

Do not fetch catalog patches from cloud storage, auto-download unsigned content,
or add a remote exercise backend in this workflow.

## Validation commands

```bash
dart run tool/validate_catalog.dart
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
