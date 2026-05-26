# Version Notes — v4 No-Cloud Catalog

This documentation version incorporates the product decision that the official exercise catalog must not require a paid cloud database.

## Main changes

- Official exercises are distributed as bundled, versioned JSON assets.
- Weekly catalog updates are implemented through app releases/patches.
- Local Drift/SQLite remains the app's on-device database.
- User custom exercises and user overrides stay local.
- Optional future dynamic content updates may use signed static JSON, but not a mutable cloud database.
- Training-intelligence features remain planned: muscle balance, recovery/readiness, quick sessions, adaptive recommendations, and future wearables/social boundaries.

## Concept status

The concept is sufficiently defined to start implementation. Remaining open questions are mostly product-detail decisions and can be resolved slice-by-slice.
