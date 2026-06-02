import 'package:repforge/src/features/cloud/domain/cloud_domain.dart';

final class UnavailableFirebaseInitializationGateway
    implements FirebaseInitializationGateway {
  UnavailableFirebaseInitializationGateway({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  @override
  Future<FirebaseInitializationResult> initialize(
    FirebaseIntegrationConfiguration configuration,
  ) async {
    final capturedAt = _now().toUtc();
    if (!configuration.shouldInitialize) {
      return FirebaseInitializationResult.disabled(
        capturedAt: capturedAt,
        configuredCapabilities: configuration.enabledCapabilities,
      );
    }

    return FirebaseInitializationResult.unavailable(
      capturedAt: capturedAt,
      configuredCapabilities: configuration.enabledCapabilities,
    );
  }
}
