# Social Friends and Activity

## Status

Design boundary only. Slice 54 documents the future social/friends bounded
context without adding backend APIs, social UI, account requirements, sync
activation, Firebase, Firestore, remote push runtime, moderation runtime,
payments changes, or data upload.

Social remains post-MVP, disabled by default, and opt-in only.

## Goal

Allow a future RepForge version to support carefully scoped friend relationships
and activity sharing while preserving local-first workout tracking. Local
logging, groups, catalog access, analytics, readiness, recommendations,
settings, backup/export/import, purchases, and entitlements must remain usable
without accounts, friends, social activity, sync, or backend services.

Social features must never expose private training data by default.

## Non-Goals

- No backend, cloud database, Firebase, Firestore, or hosted feed.
- No account requirement for local tracking.
- No social UI, friends list UI, feed UI, public leaderboard, or social
  comparison runtime.
- No sync activation or reuse of sync metadata as social sharing.
- No remote push runtime.
- No moderation/reporting runtime.
- No upload of private workout history, backups, comments, notes, profile
  details, body metrics, readiness, soreness, injury/pain flags, or
  wearable/health data.
- No official exercise catalog backend. Official catalog remains bundled local
  assets and app/content patches.
- No assumption that Premium entitlement equals user identity.

## Bounded Context

Future code should keep social vocabulary separate from training-log,
recommendation, analytics, sync, auth, payments, and notification domains.
Suggested concepts:

- `PublicProfile` / `FriendProfile`: minimal remote-visible identity, for
  example display name, optional avatar, and user-controlled profile handle. It
  must not include body metrics, age, sex/gender, training goal, equipment,
  readiness, soreness, health data, purchases, or private settings by default.
- `Friendship` / `FollowRelationship`: relationship state between two accounts.
  Relationship semantics must be explicit: mutual friends, one-way following,
  or invite-only contacts are different products.
- `FriendRequest` / `Invite`: pending relationship request with sender,
  recipient, created timestamp, status, and optional expiration. Invites must
  support decline and blocking.
- `ActivityItem`: one shareable feed entry derived from an explicitly shared
  activity summary, not from raw workout logs.
- `ShareableTrainingSummary`: sanitized summary prepared for sharing after
  consent. It should be generated from local training data through a privacy
  filter.
- `ActivityPrivacy`: per-item privacy state such as private, friends only,
  selected friends, or public.
- `SocialConsent`: record of the user's opt-in choices, preview acceptance, and
  category-level sharing settings.
- `SocialVisibility`: account/profile visibility state, separate from per-item
  privacy.
- `BlockedUser` and `MutedUser`: user safety controls that affect requests,
  visibility, notifications, and feed rendering.
- `ReportedContent` and `ModerationEvent`: future abuse-reporting and moderation
  concepts. They require backend policy, retention, operator access rules, and
  appeal/deletion handling before a feed ships.

Domain-facing social models, if added later, must be pure Dart and fakeable.
Provider SDKs, backend DTOs, Firebase types, platform APIs, Drift rows, and
Flutter presentation types must stay outside social domain objects.

## Privacy Defaults

Default behavior:

- social feature disabled,
- activity sharing off,
- profile visibility private/local-only,
- no account required,
- no friends or follow graph,
- no upload,
- no remote feed,
- no public discoverability,
- no social push registration.

Private by default:

- workout history,
- exact sets/reps/load,
- exercise comments and notes,
- set labels such as pain/failure,
- body weight, height, age, sex/gender preference, and profile details,
- equipment inventory and home-gym constraints,
- readiness, soreness, sleep, stress, energy, motivation, injury/pain context,
- wearable/health data and calorie estimates,
- backup/export files,
- precise timestamps, location, gym name, and routine patterns,
- purchases and entitlement state.

The user must be able to revoke sharing later. Revocation should stop future
sharing and should define whether already-shared activity is deleted,
unpublished, or retained according to the future backend policy.

## Shareable Data Categories

Use three categories when designing future sharing controls.

Safe default candidates:

- generic session completed,
- high-level streak or consistency milestone,
- broad achievement copy such as `New training milestone`,
- non-specific weekly activity count range,
- opt-in PR flag without exact load.

Optional explicit categories:

- exercise names,
- workout group name,
- volume ranges rather than exact volume,
- broad session duration bucket,
- approximate time bucket such as `today` or `this week`,
- PR flag with user-reviewed detail,
- user-written share caption after preview.

Sensitive categories:

- exact sets, repetitions, loads, and timestamps,
- comments, notes, pain/failure labels, and injury context,
- body weight, height, age, sex/gender, body metrics, and profile details,
- readiness, soreness, sleep, stress, energy, motivation, and recovery signals,
- wearable/health data, heart rate, calories, and active energy,
- location, gym name, device identifiers, and routine patterns,
- backups, export files, purchase state, account identifiers, and raw local
  database records.

Sensitive categories must not be shareable by default. Some may remain
non-shareable entirely unless a later legal/privacy review explicitly approves a
specific use case and copy.

## Visibility Levels

Future activity items should support:

- `private`: local-only and not uploaded.
- `friendsOnly`: visible only to accepted friends.
- `selectedFriends`: visible only to user-selected friends or groups.
- `public`: not recommended for MVP; requires stronger moderation, reporting,
  rate limits, discovery controls, and store privacy review.
- `anonymizedAggregate`: only if a future analytics design proves aggregation is
  truly anonymous and not re-identifiable.

Visibility must be set before upload. Defaults must resolve to `private`.

## Consent Model

Future sharing requires all of:

1. Social feature opt-in.
2. Account/backend opt-in if the chosen design requires identity.
3. Category-level sharing settings.
4. Explicit preview before the first share.
5. Per-activity confirmation unless the user later enables a clearly described
   auto-share rule.

Consent expectations:

- Local tracking remains available when consent is denied or revoked.
- The first-share preview must show the exact fields that would leave the
  device.
- Auto-share, if ever added, must be off by default and scoped by category.
- Delete/unshare controls must be available from activity history or privacy
  settings.
- Export must disclose social data separately from local workout backups.
- Account deletion must define deletion of profile, relationship graph, activity
  items, reports, moderation records, and retained safety logs.
- Consent records should be versioned if persisted so future copy/category
  changes can trigger re-consent.

## Relationship To Existing Boundaries

- Auth: optional and separate. An account may be required only for the future
  social feature itself, never for local tracking.
- Sync: optional and separate. Sharing an activity is not the same as syncing a
  workout log. Social must not silently upload all local history.
- Firebase: disabled/unavailable by default. Firestore must not become the
  default social database without a later explicit architecture and privacy
  slice.
- Remote Push: can be considered later for accepted friend requests, comments,
  mentions, or moderation notices. It must never replace local rest-timer
  notifications and must not register tokens before social/account consent.
- Payments/entitlements: Premium can gate a future social capability only after a
  product decision, but entitlement state is not identity and must not be public.
- Official catalog: stays bundled local assets. Social must not introduce an
  exercise catalog backend.
- Wearables/health: health, readiness, soreness, body metrics, and wearable data
  are not shared by default and should be treated as sensitive even if the user
  opts into social.
- Recommendations: social activity must not pressure users into heavier loads,
  unhealthy comparison, public rankings, or training through pain.

## Backend And Open Questions

Later implementation slices must answer:

- identity provider: local account, platform sign-in, email, passkeys, or
  another provider,
- minimal backend API surface for profiles, relationships, activity items,
  reports, deletion, and export,
- hosting/data-store choice and why Firebase/Firestore, if considered, is
  justified and not default infrastructure,
- relationship model: mutual friends, follow graph, invite links, contact
  discovery, or manual handles,
- whether contact discovery is allowed at all,
- moderation policy, reporting taxonomy, appeal handling, operator access, and
  evidence retention,
- block/mute semantics across search, invites, activity visibility, and
  notifications,
- abuse prevention: rate limits, spam controls, invite limits, scraping
  prevention, and public-profile enumeration controls,
- data retention for activity, deleted content, reports, moderation events, and
  safety logs,
- GDPR/data export/deletion behavior across local data and remote social data,
- age/content rating implications and whether minors are allowed,
- remote social notification copy and lock-screen privacy,
- whether social is free, Premium, or mixed,
- how to migrate or delete social records if the feature is removed.

## Moderation And Safety

No feed should ship without:

- report and block flows,
- documented moderation categories,
- rate limits and anti-spam rules,
- privacy review for public profiles,
- user controls for comments/replies if those exist,
- safety copy that avoids shaming, body comparison, and coercive competition,
- a support/contact path for abuse and deletion requests,
- clear operator-access rules for any remotely stored content.

Public leaderboards and broad social comparison are out of scope for the MVP and
not recommended until the product has a stronger moderation and wellbeing model.

## Release Gates

Before any social runtime ships:

1. Add a dedicated implementation slice for backend/provider architecture.
2. Update the threat model, privacy policy, store privacy/data-safety copy, and
   release checklist.
3. Add localized opt-in, preview, delete/unshare, report, block, and mute copy.
4. Add tests proving local tracking works without account/social/backend.
5. Add tests proving default activity privacy is private and sensitive fields
   are excluded.
6. Add abuse-prevention and moderation acceptance criteria.
7. Confirm no Firebase, Firestore, sync, remote push, or account dependency is
   activated by default.

Slice 54 does not implement social behavior. It defines the boundary future
slices must satisfy.
