# Migrations, Import, and Export

## Database migrations

Every schema migration must have a test. Migration code must preserve user data.

## Export formats

Initial recommended formats:

- JSON backup for full fidelity.
- CSV export for spreadsheet use.

## Import rules

- Validate schema version.
- Validate entity IDs and required fields.
- Use transaction boundaries.
- Provide dry-run validation before applying import.
- Do not import remote/premium metadata into local entitlement state.

## Backup privacy

Exported files may contain sensitive training data. UI must warn users and offer safe sharing behavior.

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
