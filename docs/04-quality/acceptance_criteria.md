# Acceptance Criteria

## General slice acceptance

A slice is done when:

- The requested behavior is implemented.
- Relevant tests exist and pass.
- `dart format` passes.
- `flutter analyze` passes.
- Docs are updated if needed.
- `docs/05-codex/slice_status.md` is updated.
- A git commit exists unless the user explicitly asked not to commit.

## UI slice acceptance

A UI slice is done when:

- Loading, empty, error, and loaded states are handled where applicable.
- Main actions are reachable with sensible touch targets.
- No business logic is embedded in widgets.
- Widget tests cover the main state.

## Data slice acceptance

A data slice is done when:

- Repositories implement application contracts.
- Mappers are tested.
- Migrations are tested if schema changed.
- No user data is silently lost.

## Payment/cloud slice acceptance

A payment/cloud slice is done only when security and privacy docs are updated, local-only features still work without cloud, and tests/fakes exist for offline or unavailable service states.

## Beta release-candidate acceptance

A beta release-candidate hardening slice is done when:

- `pubspec.yaml` version metadata matches the documented beta plan.
- App display names, launcher icon setup, launch-screen foundation, and store
  metadata docs are consistent.
- Store and privacy copy avoid medical guarantees and match the local-first,
  no-account, no-ads, no-cloud-default MVP stance.
- CI expectations match local validation, including generated-code freshness.
- Debug APK artifacts are documented as inspection-only and not store-ready.
- Signing secrets, keystores, provisioning profiles, Firebase config files,
  store publishing credentials, cloud sync, ads, and backend activation are not
  introduced.
- A proposed beta tag command is documented, but no tag is pushed as part of the
  slice.

## Production release readiness acceptance

A production release-readiness slice is done when:

- The current app version, release stage, proposed production version, and tag
  policy are documented without contradicting beta metadata.
- Production status is stated honestly as ready, blocked, owner-decision
  required, and follow-up-slice required.
- Release-owner approval, clean working tree, generated-code freshness, local
  validation, CI green status, platform signing, store metadata, screenshots,
  support/contact, privacy/data-safety, age/content, subscription/payment, and
  trademark/name checks are covered.
- Final-release tag commands are documented for a future approved release, but
  no production tag is created or pushed by Codex.
- Production blockers remain blockers instead of being papered over by docs.
- No store publishing workflow, signing secret, cloud runtime, Firebase config,
  ads, remote sync, backend activation, remote push runtime, or paid runtime
  service is added unless a later explicit slice requires it.
