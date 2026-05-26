# Slice 37 — Optional sync design spike and metadata

## Goal

Prepare optional future sync metadata boundaries without enabling cloud sync and without using sync for exercise catalog updates.

## Read first

1. `AGENTS.md`
2. `docs/02-architecture/sync_cloud_backend_strategy.md`
3. `docs/02-architecture/data_persistence.md`
4. `docs/06-slices/slice_37_cloud_sync_design_spike_and_metadata.md`

## Non-goals

- Do not enable production sync.
- Do not add Firebase/Firestore.
- Do not introduce a cloud exercise database.
- Do not require accounts.

## TDD requirements

Write metadata/conflict policy tests only if any sync metadata code is introduced. A design-only slice may update docs without app code if agreed.

## Implementation requirements

- Keep sync optional and post-MVP.
- Separate user-data sync from catalog content patches.
- Document migration impact clearly.
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
docs(sync): define optional sync boundaries
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/02-architecture/sync_cloud_backend_strategy.md
3. docs/02-architecture/data_persistence.md
4. docs/06-slices/slice_37_cloud_sync_design_spike_and_metadata.md

Implement Slice 37: Optional sync design spike and metadata.

Goal:
Prepare optional future sync metadata boundaries without enabling cloud sync and without using sync for exercise catalog updates.

Non-goals:
- Do not enable production sync.
- Do not add Firebase/Firestore.
- Do not introduce a cloud exercise database.
- Do not require accounts.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write metadata/conflict policy tests only if any sync metadata code is introduced. A design-only slice may update docs without app code if agreed.

Implementation requirements:
- Keep sync optional and post-MVP.
- Separate user-data sync from catalog content patches.
- Document migration impact clearly.

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
`docs(sync): define optional sync boundaries`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```
