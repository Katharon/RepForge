# Exercise Catalog Distribution

## Decision

The official exercise catalog is distributed through versioned bundled assets and app releases/patches. It is not stored in a paid cloud database.

## Why

A curated exercise catalog changes slowly enough that app releases are acceptable. This avoids backend cost, reduces privacy risk, works offline, and keeps MVP complexity low.

## Asset layout

Recommended structure:

```text
assets/
  catalog/
    catalog_manifest.json
    muscles_v1.json
    equipment_v1.json
    exercises_v2026_01.json
    exercise_aliases_de_v2026_01.json
    exercise_aliases_en_v2026_01.json
```

## Manifest fields

```json
{
  "catalogVersion": "2026.01.0",
  "schemaVersion": 1,
  "createdAt": "2026-05-26",
  "files": [
    "muscles_v1.json",
    "equipment_v1.json",
    "exercises_v2026_01.json"
  ]
}
```

## Exercise fields

```json
{
  "catalogId": "machine_leg_press_seated",
  "canonicalName": "Seated Leg Press",
  "localizedNames": { "de": "Beinpresse sitzend" },
  "aliases": ["leg press", "beinpresse"],
  "equipment": ["machine", "leg_press"],
  "movementPatterns": ["squat_pattern", "knee_dominant"],
  "primaryMuscles": ["quadriceps", "glutes"],
  "activation": {
    "quadriceps": 1.0,
    "glutes": 0.6,
    "hamstrings": 0.25,
    "calves": 0.1
  },
  "defaultRestSeconds": 120,
  "trackingMode": "load_reps"
}
```



## JSON assets vs Drift seeding

Use both, but for different responsibilities.

JSON assets are the canonical official catalog source because they are:

- easy to edit and review in Git,
- easy to diff in pull requests,
- easy to validate with schema tests,
- easy to localize through separate name/alias fields,
- easy to ship in app releases without any paid infrastructure,
- safe to keep immutable as official product content.

Drift/SQLite is the runtime store because it is better for:

- fast local search/filter/sort,
- joins between official exercises, user overrides, equipment inventory, workout groups, and set history,
- indexes for analytics,
- migrations,
- offline-first read models.

Therefore the flow is:

```text
Bundled JSON catalog assets
  -> validated by tests at build time
  -> read by CatalogImportService on first app start / app update
  -> imported idempotently into Drift official catalog tables
  -> queried by repositories and use cases
```

Do **not** hardcode the official catalog only as Dart seed statements or SQL inserts. That would make content updates harder to review, harder to translate, and harder to patch safely.

## First-launch behavior

On first launch:

1. Create/open Drift database.
2. Apply schema migrations.
3. Read `assets/catalog/catalog_manifest.json`.
4. Validate schema version and checksums.
5. Import official muscles, equipment, exercises, aliases, and recommendation metadata.
6. Store imported catalog version in a local `catalog_imports` table.
7. Continue onboarding.

## Bundled starter templates

Slice 23 adds a tiny `assets/templates/starter_groups_v1.json` asset for
optional starter workout groups. These templates reference stable official
catalog IDs and display-name/catalog-version snapshots from the bundled catalog.
Creating starter groups writes user-local workout group and assignment rows only;
it does not mutate official catalog rows, create custom exercises, or fetch
remote content.

On later launches after an app update:

1. Compare bundled catalog manifest with `catalog_imports`.
2. Import only new official catalog versions.
3. Never overwrite custom exercises.
4. Apply official corrections by stable `catalogId`, preserving user overrides.

## Import behavior

On app start or migration:

1. Read bundled manifest.
2. Compare with locally imported catalog versions.
3. Validate schema.
4. Import missing official definitions.
5. Apply safe correction migrations if provided.
6. Preserve all user overrides and custom exercises.

## Patch strategy

Preferred MVP strategy:

- Add/adjust catalog JSON in repository.
- Run catalog validation tests.
- Release app update weekly or as needed.
- App imports new bundled version after update.

Possible future strategy without cloud database:

- Publish signed static JSON via GitHub Releases, CDN, or object storage.
- App downloads only if user opts in or if content updates are enabled.
- Verify signature/checksum before import.
- Still no mutable cloud database.

## What not to do

- Do not query a cloud SQL/NoSQL database for exercises.
- Do not require login to access official exercises.
- Do not overwrite user-created exercises.
- Do not mutate official records directly from UI.

## v5 catalog scope

The first official catalog should be small and highly validated. Prefer all fundamental movement patterns over a huge incomplete database.

Initial catalog acceptance criteria:

- every exercise has at least one localized English and German name,
- every exercise has stable catalog ID,
- every exercise has movement pattern tags,
- every exercise has equipment requirements,
- every load-based exercise defines whether equipment max-load constraints apply,
- muscle activation estimates are present but explicitly approximate.

## Equipment-aware fields

Add optional fields to official exercises:

```json
{
  "equipmentRequirements": [
    {
      "kind": "barbell",
      "required": true,
      "loadConstraintApplies": true
    },
    {
      "kind": "bench",
      "required": true,
      "loadConstraintApplies": false
    }
  ],
  "defaultLoadUnit": "kg",
  "supportsTempoVariant": true,
  "supportsPausedVariant": true
}
```


## Backward compatibility and historical sessions

Official catalog changes must never break existing logged sessions. Set entries must reference exercises through stable IDs and keep enough snapshot data to remain understandable after catalog updates.

Rules:

- `catalogId` is immutable and must never be reused.
- Official exercises are deprecated, not deleted, once released.
- User-created exercises and user overrides are never overwritten by official imports.
- Exercise renames update current catalog display names but do not mutate historical set display-name snapshots.
- Catalog patches may add replacement suggestions for deprecated exercises.
- Importer tests must prove that old sessions still render after catalog updates.

See `docs/02-architecture/data_versioning_backward_compatibility.md`.
