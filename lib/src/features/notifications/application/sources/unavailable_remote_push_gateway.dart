import 'package:repforge/src/features/notifications/domain/notifications_domain.dart';

final class UnavailableRemotePushGateway implements RemotePushGateway {
  UnavailableRemotePushGateway({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  @override
  Future<RemotePushRegistration> register(
    RemotePushRegistrationConfiguration configuration,
  ) async {
    final capturedAt = _now().toUtc();
    if (!configuration.shouldRegister) {
      return RemotePushRegistration.disabled(
        capturedAt: capturedAt,
        requestedCapabilities: configuration.enabledCapabilities,
        messageTypes: configuration.messageTypes,
      );
    }

    return RemotePushRegistration.unavailable(
      capturedAt: capturedAt,
      requestedCapabilities: configuration.enabledCapabilities,
      messageTypes: configuration.messageTypes,
    );
  }
}
