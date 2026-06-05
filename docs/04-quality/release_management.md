# Release Management

## Versioning

Use Semantic Versioning for user-facing releases:

```text
MAJOR.MINOR.PATCH+BUILD
```

Flutter `pubspec.yaml` example:

```yaml
version: 0.1.0+1
```

## Release stages

- `0.1.x`: internal architecture and local MVP.
- `0.2.x`: usable alpha with persistence and core UI.
- `0.3.x`: analytics and timer polish.
- `0.4.x`: backup/export and QA.
- `0.9.x`: beta candidate.
- `1.0.0`: production release.

## Tags

Use tags like:

```text
v0.1.0
v0.2.0
v0.9.0-beta.1
v1.0.0
```

## Changelog

Update `CHANGELOG.md` for every release. Keep entries user-facing.

## App-store readiness

Before public release:

- Privacy policy.
- Terms/safety disclaimer.
- App icon.
- Screenshots.
- Store description.
- Store privacy/data safety copy.
- Splash/launch-screen review.
- Age rating/content declaration.
- Subscription metadata if premium exists.
- Data safety forms.
- Support contact and deletion request path.
- Open-source license notices.
- Owner review of all store claims against the exact shipped binary.

## Legal, privacy, and safety review gate

Slice 55 adds a developer/product compliance review baseline. It is not legal
advice and does not finalize release copy.

Before public release, the release owner must confirm:

1. Privacy policy drafts in English and German match the exact shipped binary.
2. Terms/safety disclaimer avoids medical, exact-measurement,
   injury-prevention, guaranteed-result, shaming, and coercive claims.
3. Store privacy/data-safety declarations match actual collection, sharing,
   permissions, SDKs, and account/backend behavior.
4. Backup/export privacy warnings match the shipped export format.
5. Support contact, vulnerability contact, and deletion request path are live.
6. App category, age/content rating, screenshots, and store copy show only
   shipped behavior.
7. Premium/subscription disclosures are either disabled from the release or
   reviewed with price, billing period, trial, renewal, cancellation, restore,
   terms, and privacy links.
8. Health/wearable, social/backend, remote push, sync, Firebase/Firestore, ads,
   diagnostics, analytics SDK, and support-upload behavior remain future-only
   unless later explicit slices enable them and update privacy/security/store
   documentation.

## Health permission release gate

Slice 53 keeps wearable and calorie work as documentation only. RepForge must
not ship Android/iOS health permissions, HealthKit entitlements, Health Connect
permissions, Google Fit scopes, wearable SDK integrations, or health-data upload
until a later explicit implementation slice completes a store/privacy review.

Before any build requests health or wearable permissions:

1. Define the exact data categories to read and why.
2. Add localized user-facing opt-in and disconnect/delete copy.
3. Update the privacy policy, store privacy/data-safety declarations, and this
   release document.
4. Confirm no account, sync, Firebase, backend, cloud analytics, or upload is
   required for local tracking.
5. Confirm backup/export behavior for imported health data is explicit.
6. Run guardrail searches for health permissions, provider SDKs, upload/sync
   language, and exact calorie-burn claims.

Calories must be described as rough estimates in store copy, screenshots, and
in-app text. Do not market exact calorie burn, medical diagnosis, injury
prevention, or guaranteed outcomes.

## Social release gate

Slice 54 keeps friends/social activity as documentation only. RepForge must not
ship a social backend, account requirement, friends list, feed UI, public
profile, Firebase/Firestore social database, remote social push runtime,
moderation runtime, public leaderboard, social comparison feature, or upload of
private training data until a later explicit implementation slice completes a
privacy, safety, and store review.

Before any build includes social runtime behavior:

1. Define the exact shared activity categories and default them to private.
2. Add localized opt-in, first-share preview, revoke, delete/unshare, block,
   mute, report, and account-deletion copy.
3. Update the privacy policy, store privacy/data-safety declarations, support
   path, and this release document.
4. Confirm local tracking works with no account, friends, sync, Firebase,
   Firestore, remote push, or backend.
5. Confirm exact sets/reps/loads, comments, notes, body metrics, readiness,
   soreness, health/wearable data, backups, location, and precise timestamps are
   excluded by default.
6. Define moderation, report handling, abuse prevention, rate limits, retention,
   export, deletion, and operator-access rules.
7. Run guardrail searches for backend/Firebase activation, upload/sync wording,
   account-required claims, leaderboard/social-comparison language, and private
   training-data sharing.

Public leaderboards and broad social comparison are not recommended for MVP.

## Branding and store metadata

Slice 40 validates the current launcher icon setup:

- source asset: `assets/icon/repforge_icon.png`
- Android generated icons: `android/app/src/main/res/mipmap-*`
- iOS generated icons: `ios/Runner/Assets.xcassets/AppIcon.appiconset`
- display name: `RepForge` on Android and iOS

The launcher icon is managed by `flutter_launcher_icons` in `pubspec.yaml`.
Regenerate only when the source icon or icon config changes:

```bash
dart run flutter_launcher_icons
```

Native launch screens currently use the RepForge near-black background
`#0B0F14` as a stable splash foundation without adding
`flutter_native_splash`. If a later slice adds a branded centered splash image
or Android 12 splash customization, define the generator config first and then
run:

```bash
dart run flutter_native_splash:create
```

Store copy drafts live in `docs/08-legal-compliance/store_listing_draft.md`.
They are product/legal drafts only; they do not publish to Google Play, App
Store Connect, TestFlight, or any paid runtime service.

## Beta release candidate

Slice 41 prepares the repository for the first beta release-candidate tag
without publishing to any store or creating signing secrets.

Current beta metadata:

- app version: `0.9.0+1`
- proposed local tag: `v0.9.0-beta.1`
- artifact for inspection: unsigned debug APK from `flutter build apk --debug`
- store listing draft: `docs/08-legal-compliance/store_listing_draft.md`

Before creating a beta tag:

1. Confirm `git status --short` is clean.
2. Run the full local validation gate from this document and
   `docs/04-quality/test_strategy.md`.
3. Confirm generated files are fresh:

   ```bash
   flutter gen-l10n
   dart run build_runner build --delete-conflicting-outputs
   git diff --exit-code -- lib test
   dart run tool/validate_catalog.dart
   ```

4. Confirm no signing secrets, keystores, provisioning profiles, Firebase config
   files, store service accounts, ads, cloud sync, or backend publishing
   credentials were added.
5. Create the tag only after validation passes:

   ```bash
   git tag -a v0.9.0-beta.1 -m "RepForge v0.9.0 beta 1"
   ```

Do not push the tag until the release owner has reviewed the beta checklist,
store/privacy copy, and artifact limitations.

### Beta release blockers and follow-ups

- No public store release until trademark and store-name availability for
  `RepForge` are verified.
- No signed Android App Bundle, TestFlight build, or App Store upload exists
  yet.
- Privacy/data-safety declarations, support/contact links, age rating, and final
  screenshots still need release-owner review.
- The debug APK is useful for local inspection only; it is not store-ready.

## CI artifacts

Slice 39 adds a secret-free Android debug artifact through the `RepForge CI`
workflow. The artifact is named `repforge-debug-apk` and is produced with:

```bash
flutter build apk --debug
```

This is not a Play Store artifact and is not suitable for public distribution.
It exists so CI can prove the Android project builds and so reviewers can
inspect a debug APK when needed.

## Signing and publishing boundaries

Store release signing is intentionally not implemented in Slice 39.

Do not commit:

- keystores,
- signing passwords,
- provisioning profiles,
- App Store Connect credentials,
- Google Play service-account JSON,
- Firebase configuration files.

Future release slices may add signed Android App Bundle and iOS/TestFlight jobs
only after secrets, store identifiers, privacy declarations, and signing
ownership are defined. Those workflows should use GitHub Actions secrets and
environment protection, not repository files.

## Production v1.0.0 readiness

Slice 42 prepares the production-release checklist only. RepForge is not
production-ready at the current `0.9.0+1` beta-candidate metadata, and this
slice does not publish the app, create store artifacts, add signing secrets, or
push tags.

Current production status:

- Ready: no.
- Blocked: yes, pending release-owner decisions and store/signing work.
- Owner decision required: yes.
- Follow-up slice required: yes, for final production hardening/signing/store
  submission once the blockers below are resolved.

### Production blockers

RepForge v1.0.0 must not be tagged or submitted publicly until all of these are
resolved:

- Release owner approves the exact source revision, final changelog, final
  version number, final binaries, and store metadata.
- Working tree is clean after generation, formatting, analysis, tests, and build
  checks.
- CI is green on the release revision, including generated-code freshness.
- Android release signing ownership is defined, and a signed release App Bundle
  is built outside the repository-secret boundary.
- iOS signing ownership, bundle identifier, provisioning, archive, TestFlight,
  and App Store submission path are defined.
- Final English and German store listing copy, screenshots, privacy/data-safety
  declarations, support/contact URL or email, and age/content declarations are
  approved.
- `RepForge` trademark and App Store / Google Play name availability are
  checked by the release owner.
- Any Premium/subscription metadata is either disabled from the shipped
  production binary or fully configured with store products, review copy, and
  privacy declarations. Provisional/unverified purchases must not unlock future
  Premium gates.
- Backup/export wording, privacy warnings, and local-first data ownership copy
  are reviewed against the exact shipped binary.
- No Firebase/cloud sync/backend/remote-push runtime, ads, analytics SDK,
  crash-reporting SDK, or paid runtime service is active unless a later explicit
  slice enables it and updates privacy/security/store documentation.

### Production validation gate

Run these commands on the release candidate revision before creating a
production tag:

```bash
git status --short
git rev-parse --short HEAD
git log --oneline -8
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
dart run tool/validate_catalog.dart
git diff --check
git diff --exit-code -- lib test
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test test/src/integration
scripts/check.sh
flutter build apk --debug
```

For production store artifacts, the release owner must additionally run the
signed platform builds after signing and store identifiers are configured:

```bash
flutter build appbundle --release
flutter build ipa --release
```

The signed release outputs must be reviewed before upload. Do not commit
keystores, provisioning profiles, certificates, service-account files, App Store
Connect credentials, Play Store credentials, Firebase config files, or generated
store secrets.

### Production guardrail checks

Run these text checks during the final release pass and review every hit:

```bash
rg "RepForge|repforge|production|v1.0.0|release checklist|release notes|tag|store listing|privacy|data safety|support|trademark|age rating" docs CHANGELOG.md pubspec.yaml android ios .github scripts
rg "0.9.0|v0.9.0-beta.1|1.0.0|v1.0.0" docs CHANGELOG.md pubspec.yaml
rg "gesundheit-gym-app|Gesundheit Gym App" pubspec.yaml android ios lib docs CHANGELOG.md .github scripts
rg "TODO|FIXME|HACK|temporary|placeholder" lib docs pubspec.yaml android ios .github scripts
rg "storePassword|keyPassword|keyAlias|keystore|provisioning|App Store Connect|PLAY_STORE|GOOGLE_SERVICE_ACCOUNT|firebase_options|google-services.json|GoogleService-Info.plist" .github android ios lib docs
rg "Firebase|Firestore|firebase_messaging|firebase_core|cloud database|remote sync|backend|RevenueCat|AdMob|google_mobile_ads" pubspec.yaml lib docs .github
```

Expected non-blocking hits include historical documentation about future
Firebase, sync, backend, remote push, and store workflows. Blocking hits include
active runtime configuration, committed secrets, stale product names in shipped
metadata, or unreviewed production placeholders.

### v1.0.0 tag instructions

The future production tag is expected to be:

```text
v1.0.0
```

Do not create or push this tag until every production blocker is resolved and
the release owner approves the exact commit. When approved, run:

```bash
git status --short
git rev-parse --short HEAD
git tag -a v1.0.0 -m "RepForge v1.0.0"
git push origin v1.0.0
```

The `pubspec.yaml` version should remain `0.9.0+1` until the final production
hardening pass explicitly bumps it to `1.0.0+<build>` and all production gates
are met.
