# Version Notes v9 — Data Evolution and Refactoring Safety

## Added

- Explicit backward compatibility architecture for long-lived local user history.
- Stable official catalog IDs that must never be reused.
- Deprecation-over-deletion policy for released official exercises.
- Historical set entry snapshots for readable old sessions after catalog renames.
- Drift migration and catalog importer test requirements.
- Export/import and analytics formula versioning guidance.
- Slice 56 for data versioning and backward compatibility hardening.

## Clarified

Flutter/Dart does not need .NET-style API version annotations for the MVP. RepForge versions the things that persist or cross boundaries: Drift schemas, catalog JSON schemas, backup/export formats, analytics formula versions, and later optional sync/native platform contracts.

## Current start recommendation

Start with Slice 00. Slice 56 is planned as a later hardening slice, but its principles should be respected from the earliest persistence and catalog slices.
