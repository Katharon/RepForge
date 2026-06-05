# Slice 55 - Legal, Compliance, Privacy, and Safety Review

## Goal

Run a focused legal/compliance/privacy/safety documentation and guardrail review
for RepForge before later production hardening. Verify that current product
claims, store metadata, health/wearable/social boundaries, backups/export,
local-first positioning, premium/payment boundaries, and training-safety wording
are honest and consistent.

This is a documentation/compliance/safety hardening slice, not a feature slice.
It must not add product features, backend services, cloud sync, Firebase,
Firestore, remote push runtime, social runtime, health permissions, wearable
SDKs, ads, payment changes, or broad UI changes.

## Implementation note

Slice 55 was completed as a documentation-only review slice. It adds a
developer/product compliance baseline under
`docs/08-legal-compliance/legal_compliance_privacy_safety_review.md`, refreshes
the legal-compliance folder index, strengthens release/store checklist items,
records the review in the threat model, and updates slice status/changelog
bookkeeping.

No app runtime behavior changed. No visible localized copy, code, dependencies,
permissions, platform capabilities, backend configuration, Firebase/Firestore,
sync, social, wearable/health integration, ads, payments, or database migration
was added.

## Review summary

Reviewed documentation and runtime metadata for:

- local-first/no-account MVP positioning,
- bundled local official catalog distribution,
- backup/export/import privacy warnings,
- readiness, recovery, soreness, muscle-load, calorie, and recommendation
  estimate semantics,
- wearable/health future boundary,
- social/friends future boundary,
- remote push versus local rest-timer notifications,
- premium/payment and entitlement boundaries,
- store listing and privacy policy draft status,
- Android/iOS permissions and package dependencies.

The reviewed docs are consistent with the current product stance:

- Local tracking remains usable without an account, backend, sync, Firebase, or
  social graph.
- Official catalog data remains bundled local assets, not a cloud database.
- Health/wearable and calorie work remains future-only, opt-in, local-first, and
  rough-estimate-only.
- Social sharing remains future-only, opt-in, private by default, and separated
  from raw workout-log sync.
- Remote push remains a future server-driven boundary; local rest timers use
  local notifications.
- Training guidance remains advisory and avoids medical, exact-measurement,
  injury-prevention, guaranteed-result, shaming, or coercive claims.
- Privacy policy, terms, store data-safety declarations, support/deletion path,
  age rating, screenshots, and subscription disclosures still require owner
  review before public release.

## Validation

Run and report:

```bash
git status --short
git rev-parse --short HEAD
git log --oneline -8
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart run tool/validate_catalog.dart
git diff --check
git diff --exit-code -- lib test || true
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
scripts/check.sh
flutter build apk --debug
rg "legal|compliance|privacy|data safety|privacy policy|store review|owner review|not legal advice|local-first|health permission|social sharing|backup export|readiness estimate|rough estimate|advisory" docs lib test CHANGELOG.md pubspec.yaml android ios
rg "exact calorie|exact calories|exact burn|exact fatigue|fatigue measurement|diagnose|diagnosis|medical advice|injury prevention|guaranteed|must train|must stop|force heavier|shame|shaming" docs lib test || true
rg "Firebase|Firestore|cloud sync|backend|remote push|social feed|wearable|HealthKit|Health Connect|Google Fit" docs lib pubspec.yaml android ios || true
rg "storePassword|keyPassword|keyAlias|keystore|provisioning|App Store Connect|PLAY_STORE|GOOGLE_SERVICE_ACCOUNT|firebase_options|google-services.json|GoogleService-Info.plist" .github android ios lib docs || true
rg "package:flutter|Material|Widget|BuildContext" lib/src/features/*/domain || true
rg "package:drift|sqlite|GeneratedDatabase|Table|DataClass" lib/src/features/*/domain || true
```

## Follow-ups

- Release owner must finalize privacy policy, terms/safety disclaimer, store
  privacy/data-safety declarations, support/contact path, deletion request path,
  app category/age rating, screenshots, and store claims before public release.
- Any future health/wearable, social/backend, remote push, sync, diagnostics,
  ads, analytics SDK, or Premium subscription activation needs a dedicated slice
  and updated privacy/store review before shipping.
- Slice 56 remains reserved for backward-compatibility and runtime resilience
  hardening.
