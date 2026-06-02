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
- App icon.
- Screenshots.
- Store description.
- Store privacy/data safety copy.
- Splash/launch-screen review.
- Age rating/content declaration.
- Subscription metadata if premium exists.
- Data safety forms.

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
