# Slice 43 — Official exercise catalog assets and importer

## Goal

Expand and harden the existing Slice 11 official exercise catalog assets,
manifest validation, and idempotent local importer behavior.

## Read first

1. `AGENTS.md`
2. `docs/02-architecture/exercise_catalog_distribution.md`
3. `docs/02-architecture/data_persistence.md`
4. `docs/01-domain/domain_map.md`
5. `docs/06-slices/slice_43_official_catalog_assets_and_importer.md`

## Non-goals

- Do not add a cloud database.
- Do not implement full exercise management UI if Slice 11 already handles UI.
- Do not add recommendations yet.

## TDD requirements

Write catalog fixture validation/import tests first: duplicate IDs, invalid activation weights, idempotent import, version detection.

## Implementation requirements

- Create `assets/catalog` structure.
- Add manifest and initial small curated catalog fixture.
- Implement data-layer importer behind an application port.
- Preserve user overrides.
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

## Implementation notes

Slice 11 already introduced the first bundled official exercise catalog JSON,
parser validation, Drift import foundation, and repository/query API. Slice 43
therefore extends that foundation instead of rebuilding it.

Slice 43 adds:

- `assets/catalog/catalog_manifest.json` with the current bundled catalog asset
  path, catalog version, schema version, and content notes.
- Manifest parser validation for supported schema versions and local bundled
  catalog asset references.
- A version bump from `2026.05.0` to `2026.06.0` so existing local installs can
  detect and import the expanded bundled catalog.
- A small curated MVP catalog expansion from 6 to 15 official exercises,
  covering fundamental barbell movements plus essential dumbbell, cable,
  machine-station, and bodyweight accessories.
- Parser tests for malformed tag lists and manifest references.
- Importer/repository tests proving idempotency, version-aware import,
  deterministic bounded queries, and preservation of workout-set and workout
  group assignment snapshots.

This slice does not add cloud catalog fetching, Firebase, sync, an Exercise
backend, UI, recommendations, coaching, set stimulus, body visualization, or
weighted muscle activation analytics.

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
feat(catalog): expand bundled exercise catalog
```

## Ready-to-use Codex prompt

```text
You are working in the `RepForge` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/02-architecture/exercise_catalog_distribution.md
3. docs/02-architecture/data_persistence.md
4. docs/01-domain/domain_map.md
5. docs/06-slices/slice_43_official_catalog_assets_and_importer.md

Implement Slice 43: Official exercise catalog assets and importer.

Goal:
Expand and harden the existing bundled official exercise catalog assets,
manifest validation, and idempotent local importer behavior.

Non-goals:
- Do not add a cloud database.
- Do not implement full exercise management UI if Slice 11 already handles UI.
- Do not add recommendations yet.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write catalog fixture validation/import tests first: duplicate IDs, invalid activation weights, idempotent import, version detection.

Implementation requirements:
- Create `assets/catalog` structure.
- Add manifest and initial small curated catalog fixture.
- Implement data-layer importer behind an application port.
- Preserve user overrides.

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
`feat(catalog): expand bundled exercise catalog`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```

## v5 adjustment

Catalog JSON must include localized names and equipment requirements. Validate that the initial catalog focuses on fundamental movements and essential accessories.
