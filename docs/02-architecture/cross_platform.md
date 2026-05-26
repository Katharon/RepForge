# Cross-Platform Strategy

## Primary platforms

- Android
- iOS

## Secondary platforms

- macOS
- Windows
- Linux
- Web

Secondary platforms should compile only when the relevant plugins and capabilities are supported. Do not let unsupported features contaminate the domain model.

## Capability abstraction

Use explicit capability interfaces:

- `NotificationScheduler`
- `PurchaseGateway`
- `SecureStorage`
- `FileExportGateway`
- `ShareGateway`
- `CrashReporter`

Each platform can provide an implementation or a no-op/unsupported implementation.

## Feature support matrix

| Feature | Android | iOS | Desktop | Web |
|---|---:|---:|---:|---:|
| Local workout logging | yes | yes | later | later |
| SQLite local DB | yes | yes | possible | special handling |
| Local rest notifications | yes | yes | later | limited |
| App-store IAP | yes | yes | macOS possible | no |
| Firebase Cloud Messaging | yes | yes | limited | possible with web setup |
| Export/import | yes | yes | yes | possible |

## Rule

Domain and application must not contain `Platform.isAndroid`, `kIsWeb`, or plugin-specific conditionals.
