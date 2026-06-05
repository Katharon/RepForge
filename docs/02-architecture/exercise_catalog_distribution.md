# Exercise Catalog Distribution

## Decision

The official exercise catalog is distributed through versioned bundled assets and app releases/patches. It is not stored in a paid cloud database.

## Why

A curated exercise catalog changes slowly enough that app releases are acceptable. This avoids backend cost, reduces privacy risk, works offline, and keeps MVP complexity low.

## Asset layout

Current bundled structure:

```text
assets/
  catalog/
    catalog_manifest.json
    official_exercises_v1.json
```

Slice 11 introduced `official_exercises_v1.json` as the first versioned
official exercise asset. Slice 43 keeps that asset path stable, adds
`catalog_manifest.json`, bumps the content version to `2026.06.0`, and expands
the bundled MVP catalog with a small curated set of fundamental barbell,
dumbbell, cable, machine, and bodyweight exercises.

## Manifest fields

```json
{
  "catalogVersion": "2026.06.0",
  "schemaVersion": 1,
  "currentCatalogAsset": "assets/catalog/official_exercises_v1.json",
  "contentNotes": [
    "Expanded MVP catalog with fundamental barbell, dumbbell, cable, machine, and bodyweight movements."
  ]
}
```

The manifest is validation metadata for bundled content. It does not fetch
remote catalog data. Parser tests verify that the manifest schema is supported
and that `currentCatalogAsset` points to an existing bundled catalog JSON file
under `assets/catalog/`.

Slice 52 adds the repository validation command:

```bash
dart run tool/validate_catalog.dart
```

This command must pass for every catalog patch before review/merge. It validates
the manifest path, supported manifest schema, existing bundled asset reference,
manifest/catalog `catalogVersion` and `schemaVersion` consistency, and all
bundled catalog JSON files under `assets/catalog/`. The manifest does not
currently contain a checksum field; if a future schema adds one, it should be
deterministic and validated by this command before runtime import support is
extended.

## Exercise fields

```json
{
  "catalogId": "dumbbell_goblet_squat",
  "localizedNames": {
    "en": "Dumbbell Goblet Squat",
    "de": "Goblet-Kniebeuge mit Kurzhantel"
  },
  "equipment": ["dumbbells"],
  "movementPatterns": ["squat", "knee_dominant"],
  "primaryMuscles": ["quadriceps", "glutes"],
  "secondaryMuscles": ["hamstrings", "core"]
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
4. Validate the manifest schema and current catalog asset reference.
5. Read and validate the referenced official exercise catalog JSON.
6. Import official exercises, equipment tags, movement patterns, and muscle
   metadata.
7. Store imported catalog version in a local `catalog_imports` table.
8. Continue onboarding.

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
- Run `dart run tool/validate_catalog.dart`.
- Run catalog validation tests.
- Release app update weekly or as needed.
- App imports new bundled version after update.

Weekly bundled patch workflow:

1. Edit official JSON assets in `assets/catalog/`.
2. Bump `catalogVersion` for content changes.
3. Update `catalog_manifest.json` when the current asset, version, schema, or
   content notes change.
4. Keep released `catalogId` values stable. `tool/catalog_stable_ids_baseline.json`
   pins the current released IDs and the validator fails if a released ID is
   deleted or renamed.
5. Validate English and German names, optional localized aliases/synonyms,
   equipment tags, movement patterns, primary muscles, secondary muscles, and
   manifest consistency with `dart run tool/validate_catalog.dart`.
6. Run the normal test/analysis/build gates before release.

The current bundled schema has primary/secondary muscle metadata but no
first-class activation-weight field. The Slice 52 validator is future-ready: if
`activationProfile`, `activationWeights`, or `muscleActivations` fields are
added later, activation muscle IDs must be known and weights must be within
`0.0..1.0`.

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
- every load-based exercise can be extended with equipment max-load constraint
  metadata in a later slice,
- muscle activation estimates remain explicitly approximate and are deferred to
  the later muscle activation slices unless the current schema adds them.

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
