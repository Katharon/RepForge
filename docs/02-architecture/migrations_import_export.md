# Migrations, Import, and Export

## Database migrations

Every schema migration must have a test. Migration code must preserve user data.

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

## Backup privacy

Exported files may contain sensitive training data. UI must warn users and offer safe sharing behavior.

Slice 24 exposes JSON content services only; it does not add platform file
pickers, sharing, remote storage, or cloud backup. Any future user-facing export
UI must warn that backup JSON can contain sensitive training/profile data.

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
