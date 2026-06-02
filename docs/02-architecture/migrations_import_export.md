# Migrations, Import, and Export

## Database migrations

Every schema migration must have a test. Migration code must preserve user data.

### Implemented migration-test foundation

Slice 25 pins the current Drift schema version and table list, validates the
current schema against Drift metadata in tests, and adds a non-empty schema v1
migration fixture that verifies additive creation of later tables and the
`workout_sets.set_label` column while preserving existing workout-set history.

Historical generated schema snapshots were not present before Slice 25. This
fixture is the migration-test foundation for future changes; every future schema
bump should add its own historical snapshot or fixture before changing
production migration code.

## Export formats

Initial recommended formats:

- JSON backup for full fidelity.
- CSV export for spreadsheet use.

### Implemented JSON backup v1

Slice 24 adds the first local JSON backup format:

- `exportVersion: 1`
- `schemaVersion: 1`
- `appId: repforge`
- UTC `exportedAt`
- workout sets with stable IDs, exercise refs, display-name/catalog snapshots,
  labels, comments, session IDs, reps, load, and `performedAt`
- workout groups and assignments with stable exercise refs/snapshots
- settings/profile values and structured equipment inventory
- onboarding status
- catalog import/version metadata only

Official catalog rows and bundled catalog assets are intentionally not exported.
Logged workout data preserves snapshots so history remains readable even if a
future catalog patch renames or replaces an official exercise.

Slice 44 keeps JSON backup v1 backward-compatible while extending the optional
`settingsProfile` object with sex/gender preference, birth year, body weight,
height, training goal, recovery sensitivity, coaching strictness, and
equipment load constraints. Older backups without those fields still parse with
local defaults; new exports include the fields so local profile data remains
exportable.

## Import rules

- Validate schema version.
- Validate entity IDs and required fields.
- Use transaction boundaries.
- Provide dry-run validation before applying import.
- Do not import remote/premium metadata into local entitlement state.

### Implemented import policy

Slice 24 import validation rejects missing or unsupported versions, malformed
required fields, invalid exercise refs, invalid set labels, negative reps/load,
invalid settings values, invalid equipment values, and malformed dates with
deterministic field-level errors.

The write policy is additive/upsert by stable ID inside a transaction. Import
does not wipe existing workout data and does not mutate official catalog rows.
Settings and onboarding are single local records, so when a backup contains
those sections they are applied by upsert. Platform file selection and CSV are
not part of this slice.

Slice 25 adds archive/delete policy tests confirming that backup import upserts
do not wipe unrelated workout sets, workout groups, assignments, or official
catalog rows.

## Integrity checks and repair policy

The local persistence layer exposes deterministic integrity findings for:

- orphaned workout group assignments;
- invalid exercise source values;
- missing or blank exercise snapshot data;
- invalid or legacy blank set labels;
- invalid repetitions or load values;
- invalid settings/profile/equipment values;
- invalid onboarding status values;
- broken catalog import metadata.

Repair is explicit and report-only by default. The first safe repair normalizes
legacy blank workout-set labels to `NULL`; it does not delete rows, alter
training history snapshots, or mutate official catalog rows. Orphaned rows and
other ambiguous findings remain report-only until a later slice defines a
user-visible archive/delete decision.

## Backup privacy

Exported files may contain sensitive training data. UI must warn users and offer safe sharing behavior.

Slice 24 exposes JSON content services only; it does not add platform file
pickers, sharing, remote storage, or cloud backup. Any future user-facing export
UI must warn that backup JSON can contain sensitive training/profile data.

Slice 30 exposes a local backup privacy warning in the export use case and adds
a backup JSON redactor for diagnostic use. Validation exception strings list
invalid fields only and do not echo payload values. This does not change JSON
backup v1, database schema, import semantics, file IO, sharing, sync, or cloud
storage.

## Future encrypted export

Post-MVP option: encrypted ZIP or JSON backup with passphrase-based encryption.


## Backward compatibility baseline

Migration and import/export work must follow `docs/02-architecture/data_versioning_backward_compatibility.md`.

Minimum expectations:

- app schema version is explicit,
- catalog schema version is explicit,
- export format version is explicit,
- old set history remains readable after catalog patches,
- deprecated official exercises remain displayable,
- custom exercises remain untouched by official catalog imports,
- migrations are tested with non-empty historical data.
