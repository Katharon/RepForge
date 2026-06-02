import 'package:repforge/src/features/notifications/domain/notifications_domain.dart';

final class RegisterRemotePush {
  RegisterRemotePush(this._gateway, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final RemotePushGateway _gateway;
  final DateTime Function() _now;

  Future<RemotePushRegistration> call(
    RemotePushRegistrationConfiguration configuration,
  ) {
    if (!configuration.shouldRegister) {
      return Future<RemotePushRegistration>.value(
        RemotePushRegistration.disabled(
          capturedAt: _now().toUtc(),
          requestedCapabilities: configuration.enabledCapabilities,
          messageTypes: configuration.messageTypes,
        ),
      );
    }

    return _gateway.register(configuration);
  }
}
