# Data Persistence

## Decision

Use SQLite through Drift for the local production database.

This is a local on-device database, not a paid cloud database.

## Rationale

Workout tracking is query-heavy:

- Sets by exercise and date range.
- Workout groups and ordered exercises.
- Aggregation by day/week/month.
- Period comparisons.
- Muscle-load summaries.
- Search and filtering.
- Export/import.
- Official catalog imports and migrations.

A relational local database is a strong fit. Drift offers type-safe queries, migrations, and testability.

## Initial database tables

- `official_exercises`
- `official_exercise_muscle_activations`
- `official_catalog_versions`
- `custom_exercises`
- `exercise_user_overrides`
- `workout_groups`
- `workout_group_exercises`
- `training_sessions`
- `workout_sets`
- `set_labels`
- `settings_profiles`
- `equipment_inventory_items`

Later tables:

- `readiness_checkins`
- `soreness_checkins`
- `recommendation_snapshots` optional
- `entitlements`
- `purchase_events`
- `notification_requests`
- `sync_records` optional post-MVP
- `wearable_samples` optional future
- `friend_activity_cache` optional future

## Official catalog import

The bundled catalog is stored as JSON assets and imported into `official_exercises` and related tables.

Import requirements:

- idempotent,
- version-aware,
- deterministic,
- migration-tested,
- does not overwrite user overrides,
- does not require internet.

## Mapping rule

Database rows are not domain entities. Use mappers:

```text
OfficialExerciseRow <-> OfficialExerciseDefinition
CustomExerciseRow <-> CustomExercise
WorkoutSetRow <-> WorkoutSet
WorkoutGroupRow <-> WorkoutGroup
```

## Migrations

- Every schema change needs a Drift migration test.
- Never drop user data silently.
- Use archive/soft-delete for exercises with historical sets.
- Official catalog version changes must be tested with fixture JSON.

## Security

If encrypted local DB is added, keep the encryption key in platform secure storage. Do not hardcode encryption keys.

## v5 persistence additions

Persist user profile and equipment inventory locally. Slice 22 implemented:

- `settings_profiles`
- `equipment_inventory_items`

Suggested future tables/entities:

- `user_profile`
- `user_preferences`
- `exercise_equipment_requirements`
- `exercise_catalog_versions`
- `user_exercise_overrides`

Official catalog assets are imported into local Drift tables. App patches may add official records, but user overrides and custom exercises remain separate.

## Slice 22 settings persistence

Drift schema v5 adds `settings_profiles` and `equipment_inventory_items`
additively. Existing users load deterministic defaults when no settings row is
present. Saving settings upserts the single local profile row and replaces only
that profile's structured equipment inventory; workout sets, workout groups, and
official catalog rows are not modified.

## Slice 25 persistence hardening

Drift schema remains v6. Slice 25 adds tests that pin the current table list,
validate the current Drift schema, and exercise a non-empty schema v1 migration
fixture to confirm additive upgrades preserve logged workout-set history.

The shared local data layer now includes deterministic integrity checks for
workout sets, workout group assignments, settings/equipment, onboarding status,
and catalog import metadata. Findings include severity, stable code, message,
affected table/entity id, and whether a safe repair exists. Repairs are
report-only by default; the only implemented safe repair normalizes legacy blank
workout-set labels to `NULL`. No repair silently deletes rows or mutates
official catalog records.
