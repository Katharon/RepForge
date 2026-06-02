import 'package:repforge/src/features/cloud/domain/cloud_domain.dart';

final class InitializeFirebaseIntegration {
  InitializeFirebaseIntegration(this._gateway, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final FirebaseInitializationGateway _gateway;
  final DateTime Function() _now;

  Future<FirebaseInitializationResult> call(
    FirebaseIntegrationConfiguration configuration,
  ) {
    if (!configuration.shouldInitialize) {
      return Future<FirebaseInitializationResult>.value(
        FirebaseInitializationResult.disabled(
          capturedAt: _now().toUtc(),
          configuredCapabilities: configuration.enabledCapabilities,
        ),
      );
    }

    return _gateway.initialize(configuration);
  }
}
