# Navigation

## Router

Use a declarative router, preferably `go_router`, once the project is bootstrapped.

## Route model

```text
/                       -> Today
/exercises              -> Exercise list
/exercises/new          -> Create exercise
/exercises/:id          -> Exercise detail
/exercises/:id/sets/new -> Add set
/sets/:id/edit          -> Edit set
/programs               -> Program list
/programs/:id           -> Program detail
/analytics              -> Global analytics
/settings               -> Settings
/settings/notifications -> Notification settings
/settings/data          -> Export/import
/premium                -> Premium / Pro
```

## Navigation rules

- Bottom navigation appears on main destinations.
- Detail/edit screens use back navigation.
- Add-set flow should return to the originating exercise detail or Today context.
- Destructive operations require confirmation.
- Route parameters should use stable IDs.

## Deep links

Post-MVP:

- Restore purchase result.
- Open exercise detail.
- Open backup import.

Do not implement deep links before the core navigation is stable.
