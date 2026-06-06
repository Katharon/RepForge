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
- `workoutSessionId`
- `workoutSetId`

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

Schema version 1 starts the local Drift baseline with persisted workout-set
history. The v1 `workout_sets` table stores stable set IDs, stable exercise
references, display-name snapshots, optional catalog-version snapshots,
optional session/comment fields, raw repetitions/load, and performed
timestamps. Raw logged sets are source-of-truth training data.

Schema version 2 adds the first official exercise catalog runtime tables:
`official_exercises`, official exercise equipment tags, movement patterns,
muscle groups, and `catalog_imports`. The migration is additive only and must
not rewrite, drop, or reinterpret v1 `workout_sets` rows. Official catalog
imports write only official catalog tables and import-version metadata.

Schema version 3 adds `workout_groups` and
`workout_group_exercise_assignments`. Assignment rows store stable exercise
source, stable exercise ID, display-name snapshot, optional official
catalog-version snapshot, and assignment position. The migration is additive
only and must not rewrite `workout_sets` or official catalog tables. Official
catalog imports must not overwrite workout groups or assignments.

Schema version 4 additively adds nullable `workout_sets.set_label` for the
single MVP set marker. Existing logged rows with null or empty labels continue
to mean `none`; unsupported non-empty stored labels fail deterministically in
the training-log mapper instead of being silently reinterpreted.

Schema version 9 additively adds `readiness_checkins` for local readiness
feedback. It stores stable check-in ids, UTC timestamps, bounded soreness,
sleep quality, energy, stress, and motivation ratings, plus a latest-query
index. The migration creates only the new table and must not rewrite workout
history, catalog rows, workout groups, settings/profile data, onboarding
status, purchases, auth, sync metadata, or notification state.

Schema version 10 additively adds `custom_exercises`. Custom exercise rows are
user-owned local data with stable `customExerciseId` values, user-editable
metadata, UTC timestamps, and soft archive state. The migration creates only
the new table and must not rewrite official catalog rows, workout sets, workout
groups, settings/profile data, onboarding status, purchases, auth, sync
metadata, readiness check-ins, or notification state.

Slice 47 also adds an optional `readinessCheckIns` array to local backup JSON.
The backup schema version remains compatible because older backups without the
field continue to parse as an empty readiness list, while exported readiness
rows preserve their stable ids and timestamps.

Slice 56 hardens the backup/import tests around that contract. Readiness
check-ins must round-trip through backup JSON and Drift import with stable ids,
preserved timestamp instants, and bounded values. Invalid readiness backup
ratings must fail deterministic validation before import. Official catalog rows
remain release-managed bundled data and are not exported as full backup content;
backup compatibility relies on stable exercise references and display-name
snapshots in user-owned workout sets and group assignments.

The app composition root owns the runtime `RepForgeDatabase` instance it
creates through the local database factory and closes it through
`AppDependencies.close()`. Tests may inject in-memory executors or caller-owned
database instances so validation never touches real app storage.

Training-log repository history queries match exercises by stable source and ID,
not by display-name snapshot. Mapper code must preserve each persisted snapshot
as logged. Custom exercise rows with catalog-version snapshots are invalid
persisted data because custom exercises do not belong to an official catalog
version.

Workout-group assignment mapper code follows the same rule: official assignment
rows may carry catalog-version snapshots, while custom assignment rows with
catalog-version snapshots are invalid persisted data and must fail
deterministically.

Archiving a custom exercise or custom folder must not delete historical logged
sets or assignment snapshots. Old workout history remains understandable through
`ExerciseRef.custom` stable IDs and display-name snapshots even if the custom
exercise is later renamed or archived.

Drift schema changes must be backward-compatible where possible:

- prefer additive columns with defaults,
- prefer new tables over destructive rewrites,
- preserve v1 `workout_sets` rows and snapshot meaning across migrations,
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
- Slice 11 ships `assets/catalog/official_exercises_v1.json` as the first
  bundled official catalog asset.
- The Slice 11 parser supports schema version `1` and rejects unsupported
  schemas before Drift import.
- build-time validation must reject invalid catalog files.
- importer tests must cover older schema versions if they remain supported.
- unsupported schema versions must fail safely before modifying Drift.

## Analytics formula evolution

Analytics formulas may improve over time, but historical data must not become misleading.

For derived metrics:

- raw set history is the source of truth,
- derived metrics can be recalculated,
- formula versions should be documented when visible numbers can change,
- non-persisted formula results should still carry explicit formula identity
  when practical, so current calculations are explainable,
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
