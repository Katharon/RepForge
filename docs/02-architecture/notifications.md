# Notifications

## Rest timer notifications

Use local notifications for rest timers.

Reason:

- Rest timer due time is known on-device.
- No account or backend required.
- Works offline.
- Avoids unnecessary Firebase complexity.

## Notification types

MVP:

- Rest timer due.
- Optional reminder to continue session.

Later:

- Training reminder based on local schedule.
- Recovery/check-in reminder.

## Firebase Cloud Messaging

FCM is not needed for rest timers or local training reminders.

Slice 36 models remote push/FCM only as an optional Firebase capability flag.
The default configuration is disabled and the app does not request a token,
initialize FCM, or route rest-timer notifications through Firebase.

FCM may be introduced later only for true remote/server-driven features such as:

- social activity notifications,
- account/sync alerts,
- product/news updates,
- remote coach messages if a backend exists.

FCM token handling must be opt-in or tied to account/cloud features.

## Remote Push Boundary

Slice 38 adds a pure-Dart Remote Push boundary under the notifications feature.
It models future server-driven notification registration with:

- remote push token value objects,
- registration configuration and status,
- permission, unavailable, token-unavailable, registered, and failed states,
- future capabilities such as account/security notices, sync-conflict notices,
  social activity, server news, and remote coach messages,
- a fakeable `RemotePushGateway`.

Default app wiring uses a disabled registration configuration and an unavailable
gateway. Disabled registration returns locally without asking the gateway for a
token. Enabled registration still has no production adapter in this slice and
therefore reports unavailable through the default gateway.

Remote Push is separate from Local Notifications:

- rest timers use `RestTimerNotificationGateway`,
- normal rest periods never use Remote Push,
- local notification scheduling/cancel behavior is unchanged,
- local MVP features do not require a push token, account, Firebase, sync, or a
  backend.

Future Remote Push provider work must be an explicit slice. It must add privacy
review, consent/account rules where needed, provider-specific token handling
outside domain, backend registration if used, and tests proving local features
still work when Remote Push is disabled or unavailable.

## Future Social Notifications

Slice 54 keeps social notifications as design-only. A later social feature may
consider remote notifications for accepted friend requests, activity comments,
mentions, direct invitations, block/report outcomes, or moderation notices.

Rules for any future social notification implementation:

- no token request before explicit social/account consent,
- no remote push registration for users who keep social disabled,
- no private workout details, exact loads, comments, readiness, soreness,
  wearable/health data, or body metrics in lock-screen copy,
- block and mute settings must suppress relevant social notifications,
- rest timers and local reminders remain local notifications,
- remote social notifications require a backend/privacy review and tests proving
  local features still work when remote push is disabled, denied, unavailable,
  or failed.
