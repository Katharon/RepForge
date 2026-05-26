# Version Notes v7 — Final Concept Check

## Purpose

This version consolidates the latest project decisions before implementation begins.

## Updated decisions

- `RepForge` is the selected app name, subject only to future trademark and store-availability checks.
- German and English are required from the MVP. The app uses the system locale when supported and falls back to English.
- MVP scope remains intentionally small: tracking, workout groups, custom exercises, official base exercise catalog, local persistence, and analytics.
- The official exercise catalog is authored as versioned JSON assets, shipped with app releases/patches, validated on import, and projected into Drift/SQLite on first launch or catalog update.
- Drift/SQLite is the local runtime database for search, filtering, analytics, user logs, groups, custom exercises, settings, and catalog projection.
- Baseline operation must avoid developer-controlled recurring costs: no paid cloud database, no backend hosting, no paid analytics, no remote config service, no RevenueCat at the beginning, and no ads in MVP.
- Monetization is freemium: basic tracking/analytics remain free; coaching, guidance, recommendations, muscle balance, recovery/readiness, quick sessions, wearables, and advanced reports are Premium candidates.
- The free experience should be pleasant and habit-forming, not intentionally annoying. Ads are deliberately excluded from MVP.
- Coaching and recovery text must use hedging and cautious language. RepForge should say that something `may`, `could`, `appears`, is `estimated`, or `can be useful`, instead of making absolute medical-style claims.

## Remaining non-blocking questions

- Trademark and store-name availability for `RepForge`.
- Exact Premium price, yearly discount, and trial length.
- Exact initial official exercise catalog list.
- Exact safety/disclaimer wording for onboarding and recommendation surfaces.
- Whether a static marketing website is launched before or after the first public app release.
