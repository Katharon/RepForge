# Version Notes v6: RepForge, Cost Strategy, Catalog Seeding, Packages

## Accepted decisions

- Product name baseline: `RepForge`.
- English and German localization are required from the MVP.
- MVP stays focused on tracker + workout groups + analytics.
- Official exercise catalog content is distributed as versioned JSON assets.
- Drift/SQLite is initialized on first launch and seeded/imported from the bundled JSON catalog.
- No paid cloud database, no paid backend, no paid analytics, no paid remote config, and no mandatory cloud services in MVP.
- Ads are excluded from MVP.
- Freemium strategy remains preferred: free core tracking; premium coach/guidance features later.
- ASO/SEO planning is now explicitly part of product documentation.

## Why JSON plus Drift

JSON is the authoring and release format. Drift is the local query/runtime format.

This gives RepForge:

- free catalog distribution through app releases,
- clear Git diffs for official exercise changes,
- build-time validation tests,
- simple German/English localization of exercise names and aliases,
- fast local filtering/search through Drift indexes,
- safe preservation of custom exercises and user overrides.

## Files changed/added

- `README.md`
- `AGENTS.md`
- `docs/00-project/project_memory_brief.md`
- `docs/00-project/decisions.md`
- `docs/00-project/open_questions.md`
- `docs/00-project/business_model_zero_cost.md`
- `docs/00-project/marketing_aso_seo.md`
- `docs/00-project/version_notes_v6_repforge_cost_stack.md`
- `docs/02-architecture/exercise_catalog_distribution.md`
- `docs/02-architecture/payments_entitlements.md`
- `docs/02-architecture/sync_cloud_backend_strategy.md`
- `docs/02-architecture/tech_stack_and_packages.md`
- `docs/05-codex/chatgpt_project_instructions.md`
- `docs/06-slices/index.md`
