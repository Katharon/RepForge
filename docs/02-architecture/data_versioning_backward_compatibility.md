# Data Versioning and Backward Compatibility

## Purpose

RepForge must remain changeable after release without destroying user trust or user data. Users may track months or years of sessions. Official exercises, catalog metadata, analytics formulas, premium features, and UI flows may evolve, but historical training data must stay readable and meaningful.

This document is mandatory reading for any slice that changes Drift schema, catalog JSON schema, exercise identifiers, analytics formulas, import/export formats, or user-facing history.

## Core rule

Never make a content or schema change that can orphan, overwrite, or reinterpret existing user history without an explicit migration and tests.

## Stable identity model

Official catalog entities use stable IDs that are never reused:

- `catalogExerciseId`
- `catalogMuscleId`
- `catalogEquipmentId`
- `movementPatternId`

A stable ID may be deprecated, renamed, localized differently, or superseded, but it must not be deleted from the local imported history while user data references it.

Custom user entities use local UUIDs:

- `customExerciseId`
- `workoutGroupId`
- `sessionId`
- `setEntryId`

Historical set entries reference an exercise through a stable reference object, not through mutable display text.

Recommended reference shape:

```text
ExerciseRef
- source: official | custom
- id: catalogExerciseId or customExerciseId
- displayNameSnapshot: localized name shown when the set was logged
- catalogVersionSnapshot: optional for official exercises
```

The snapshot fields make old sessions understandable even if the official exercise is later renamed.

## Official catalog evolution

Allowed changes:

- add new official exercises,
- add aliases,
- add localized names,
- add movement pattern tags,
- adjust approximate activation metadata with version notes,
- deprecate unsafe or duplicate exercises,
- add replacement suggestions,
- add optional fields with defaults.

Restricted changes:

- do not delete official exercises referenced by user data,
- do not reuse an old ID for a different exercise,
- do not mutate historical set entries when catalog metadata changes,
- do not overwrite custom exercises or user overrides,
- do not silently change units or tracking modes without migration.

If an official exercise becomes incorrect or obsolete, mark it as deprecated:

```json
{
  "catalogId": "old_exercise_id",
  "status": "deprecated",
  "replacedBy": "better_exercise_id",
  "deprecationReason": "Duplicate naming; preserved for history."
}
```

## Drift schema evolution

Drift schema changes must be backward-compatible where possible:

- prefer additive columns with defaults,
- prefer new tables over destructive rewrites,
- keep migration steps deterministic,
- migrate in transactions,
- test migration from previous schema versions,
- include a fixture database when the migration is non-trivial,
- never drop user tables without export/migration path.

Every migration slice must include tests for:

1. empty database,
2. database with official catalog imported,
3. database with custom exercises,
4. database with logged sessions and set entries,
5. database with user overrides.

## JSON schema evolution

Catalog JSON assets include both `catalogVersion` and `schemaVersion`.

Rules:

- `catalogVersion` changes whenever official content changes.
- `schemaVersion` changes whenever JSON shape changes.
- build-time validation must reject invalid catalog files.
- importer tests must cover older schema versions if they remain supported.
- unsupported schema versions must fail safely before modifying Drift.

## Analytics formula evolution

Analytics formulas may improve over time, but historical data must not become misleading.

For derived metrics:

- raw set history is the source of truth,
- derived metrics can be recalculated,
- formula versions should be documented when visible numbers can change,
- UI should use hedging for approximate values,
- reports may show "estimated" or "calculated with current formula" where appropriate.

For stored analytics snapshots, include:

```text
formulaVersion
computedAt
sourceDateRange
```

## Public APIs inside the app

RepForge is not a .NET backend, so it does not need controller/API-version annotations for MVP. Instead, versioning is handled at the boundaries that actually persist or exchange data:

- Drift schema versions,
- catalog JSON schema versions,
- backup/export format versions,
- entitlement model versions,
- optional future sync API versions,
- platform-channel contracts if native integrations are added.

Dart abstract classes should define stable ports for repositories and platform adapters. Do not rely on annotation magic for architectural stability.

## Refactoring safety

Feature internals may be refactored aggressively if boundaries stay stable:

- Domain entities and value objects stay pure Dart.
- Application use cases depend on repository ports, not Drift or Flutter.
- Infrastructure adapters can be replaced behind ports.
- Presentation BLoCs/Cubits depend on use cases, not Drift tables.
- Catalog importer is isolated from UI.
- Platform-specific code is isolated behind adapters and, later, Pigeon/Method Channel contracts.

## Acceptance criteria for future changes

Any future slice that changes catalog, persistence, import/export, or analytics must prove:

- existing user sessions remain readable,
- custom exercises remain intact,
- archived/deprecated official exercises still render in history,
- migrations are tested,
- export/import version is documented,
- docs and slice status are updated.
