# Version Notes v5 — Product Decisions

This documentation version incorporates the following decisions:

## Naming

A preliminary list of 30 coined app-name candidates was added in `docs/00-project/naming_candidates.md`. Store availability is not guaranteed until checked directly in App Store Connect, Google Play Console, and trademark databases.

## Localization

Multilingual support is a foundation requirement. The app starts with the system locale and falls back to English if unsupported. English and German should be the first supported languages.

## MVP boundary

The MVP is tracker + groups + analytics. Coach, recommendations, muscle-balance dashboard, readiness, wearables, social, and payments are planned after the local MVP.

## Exercise catalog

The official catalog starts small and clean, focused on fundamental compound lifts and a few essential accessories. It expands through versioned patches/assets, not a paid cloud database.

## Equipment constraints

The domain model must support available equipment and maximum usable load, especially for home gyms. This enables future recommendations that do not suggest impossible loads.

## UI direction

The UI is inspired by Setgraph's dark, fast, data-dense tracking experience, but it must become its own product identity.

## Monetization

Use freemium. Tracking, groups, base catalog, custom exercises, core analytics, and local backup remain free. Premium can unlock coaching, recommendations, muscle-balance/recovery guidance, advanced periodization, wearables, and advanced reports.

## Disclaimer/safety

Training guidance must be framed as estimated, educational, and non-medical. The app should avoid medical diagnosis claims and should advise users to reduce/stop training and consult qualified professionals when pain, injury, or medical conditions are involved.
