import '../entities/initialization_result.dart';
import '../entities/integration_configuration.dart';

abstract interface class FirebaseInitializationGateway {
  Future<FirebaseInitializationResult> initialize(
    FirebaseIntegrationConfiguration configuration,
  );
}
