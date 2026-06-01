# Payments and Entitlements

## Timing

Payments are post-MVP. Do not implement payments before the local tracker, groups, and analytics are useful.

## Monetization decision

Use a **freemium model** instead of locking the whole app after a trial.

Free forever:

- local workout tracking,
- workout groups,
- official base exercise catalog,
- custom exercises,
- exercise assignment to groups,
- core analytics,
- local backup/export/import,
- settings and equipment inventory.

Premium candidates:

- coach/recommendation engine,
- smart exercise ordering,
- equipment-aware alternatives,
- muscle-balance dashboard,
- recovery/readiness guidance,
- quick-session generation,
- adaptive set/backoff suggestions,
- advanced progression/periodization,
- wearable integration,
- advanced reports/export,
- optional social comparison later.

## Trial strategy

Offer a Premium free trial through official app-store subscription mechanisms when Premium exists. Do not require payment for the free local tracker.

The purchase UI must clearly show:

- subscription name,
- billing period,
- included Premium features,
- trial duration if any,
- renewal price after trial,
- cancellation/renewal behavior as required by the stores,
- restore purchases action,
- Terms of Use and Privacy Policy links.

## No cloud exercise database

Premium features must not depend on a paid exercise-catalog database. The official catalog is shipped through bundled assets/app patches. Premium may unlock advanced local algorithms, not basic access to the exercise list.

## Entitlement model

Do not gate features with a random local `isPremium` boolean.

Use an entitlement domain model:

- `Entitlement`
- `EntitlementSource`
- `PurchaseEvent`
- `EntitlementStatus`
- `ExpiresAt`
- `LastVerifiedAt`

Slice 32 implements the first version under
`lib/src/features/entitlements/`:

- `EntitlementId`, `EntitlementKind`, `EntitlementSource`,
  `EntitlementState`, and `EntitlementSnapshot` describe source-separated
  entitlement evidence.
- `FeatureGate` enumerates both non-gated local MVP features and optional
  future Premium gates.
- `PremiumFeature` names optional post-MVP capabilities without implying that
  they exist in the current UI.
- `FeatureGateDecision` and `EntitlementPolicy` return explicit outcomes:
  allowed, locked, unavailable, or unknown/unverified with deterministic reason
  codes.
- `EntitlementSnapshotSource` is the source port. The current composed source is
  a local/free source that returns an empty snapshot and is not purchase proof.

The default policy always allows the local MVP gates:

- local workout tracking,
- Workout Groups,
- Custom Exercises,
- official base catalog,
- local backup/export,
- base analytics,
- privacy/security functionality,
- settings/profile,
- onboarding,
- local import/export validation.

Future Premium gates are prepared for optional capabilities only, such as
advanced analytics, coach/recommendation features, muscle balance/heatmap,
advanced templates, optional cloud/sync, and advanced export formats. Optional
cloud/sync remains unavailable until a later explicit slice.

## Store integration

Use app-store purchase APIs through data-layer adapters. Domain/application sees only entitlement ports.

## Verification strategy

For development/testing, local store restore mechanisms may be enough. For production subscriptions, consider trusted receipt validation or a managed entitlement provider. This may require a minimal backend/provider, but it does **not** imply a cloud exercise database.

## Non-goals

- Payments before local MVP.
- Account requirement for local tracking.
- Cloud database for exercise definitions.
- Paywalling user-owned workout history or export.


## v6 monetization boundary

RepForge uses a freemium model.

Free features:

- tracking,
- workout groups,
- custom exercises,
- official base catalog,
- base analytics,
- local backup/export/import.

Premium candidates:

- coach,
- training guidance,
- exercise recommendations,
- adaptive alternatives,
- muscle-balance analysis,
- recovery/readiness suggestions,
- quick sessions,
- advanced reports,
- wearable interpretation.

Do not implement Premium before the local MVP is valuable. The entitlement model should exist before payment integration, but payment integration comes later.

Do not use RevenueCat in the baseline. Use `in_app_purchase` when store payments are implemented. Reconsider a paid subscription-management service only if the app later needs server-side entitlement validation, cross-platform account sync, win-back flows, or complex subscription analytics.
