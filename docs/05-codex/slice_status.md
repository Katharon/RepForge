# Slice Status

Status values:

- `planned`
- `in_progress`
- `done`
- `blocked`
- `deferred`

All slices are planned until implemented and committed.

## Current status

- Slice 00–10: planned foundation.
- Slice 11–23: planned local tracking MVP with bundled catalog, custom exercises, workout groups, analytics foundations, settings, onboarding.
- Slice 24–31: planned local hardening.
- Slice 32–38: planned post-MVP monetization/optional cloud boundaries.
- Slice 39–42: planned release pipeline and production checklist.
- Slice 43–54: planned advanced catalog, training intelligence, recovery, muscle balance, quick session, wearable design, and social design.

## Critical project decision

The official exercise catalog must not depend on a paid cloud database. Catalog updates are shipped as versioned app assets through app releases/patches and imported locally.

## Update rule

After every implemented slice, Codex must update this file with:

- date,
- slice number,
- status,
- commit hash,
- short implementation summary,
- validation commands run,
- follow-ups.

## v5 documentation status

Planning docs were updated with:

- multilingual/system-locale decision,
- MVP boundary: tracker + groups + analytics,
- small official catalog scope,
- equipment inventory and max-load modeling,
- Setgraph-inspired but original UI direction,
- freemium monetization strategy,
- training disclaimer/safety boundary,
- naming candidate list.

Implementation has not started yet. Slice 00 remains the first implementation slice.

| 56 | Data versioning and backward compatibility hardening | Planned | Hardens stable IDs, deprecation, migrations, import/export versioning, and historical session safety. |
