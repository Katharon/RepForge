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
