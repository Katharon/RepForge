# Dependency Rules

## Allowed imports

### Domain

Allowed:

- Dart SDK.
- Other domain files in the same feature.
- Core pure-Dart helpers if truly generic.

Forbidden:

- `package:flutter/...`
- Database packages.
- Firebase packages.
- Notification packages.
- In-app-purchase packages.
- HTTP clients.
- Secure storage.

### Application

Allowed:

- Domain.
- Pure Dart core helpers.
- Repository interfaces.

Forbidden:

- Flutter widgets.
- Direct database/plugin implementation.

### Data

Allowed:

- Domain/application contracts.
- Database packages.
- Platform/plugin APIs.
- Mappers.

Forbidden:

- Presentation widgets.
- Direct UI concerns.

### Presentation

Allowed:

- Flutter.
- BLoC/Cubit.
- Application use cases.
- UI-only models.

Forbidden:

- Raw SQL.
- Direct Firebase/app-store/local-notification APIs.
- Domain rule duplication.

## Dependency inversion

Application/domain define contracts; data implements them. Composition root wires concrete implementations.

## Practical rule

If swapping Drift for another database requires changing domain or widgets, the boundary is wrong.
