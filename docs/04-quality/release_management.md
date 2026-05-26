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
- `0.5.x`: beta candidate.
- `1.0.0`: production release.

## Tags

Use tags like:

```text
v0.1.0
v0.2.0
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
- Age rating/content declaration.
- Subscription metadata if premium exists.
- Data safety forms.
