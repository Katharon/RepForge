import '../value_objects/capability.dart';
import '../value_objects/initialization_failure.dart';
import '../value_objects/integration_status.dart';

final class FirebaseInitializationResult {
  const FirebaseInitializationResult._({
    required this.status,
    required this.capturedAt,
    required this.configuredCapabilities,
    required this.initializedCapabilities,
    this.failure,
  });

  const FirebaseInitializationResult.disabled({
    required DateTime capturedAt,
    FirebaseCapabilitySet configuredCapabilities = FirebaseCapabilitySet.none,
  }) : this._(
         status: FirebaseIntegrationStatus.disabled,
         capturedAt: capturedAt,
         configuredCapabilities: configuredCapabilities,
         initializedCapabilities: FirebaseCapabilitySet.none,
       );

  const FirebaseInitializationResult.unavailable({
    required DateTime capturedAt,
    required FirebaseCapabilitySet configuredCapabilities,
  }) : this._(
         status: FirebaseIntegrationStatus.unavailable,
         capturedAt: capturedAt,
         configuredCapabilities: configuredCapabilities,
         initializedCapabilities: FirebaseCapabilitySet.none,
       );

  const FirebaseInitializationResult.initialized({
    required DateTime capturedAt,
    required FirebaseCapabilitySet initializedCapabilities,
  }) : this._(
         status: FirebaseIntegrationStatus.initialized,
         capturedAt: capturedAt,
         configuredCapabilities: initializedCapabilities,
         initializedCapabilities: initializedCapabilities,
       );

  const FirebaseInitializationResult.failed({
    required DateTime capturedAt,
    required FirebaseCapabilitySet configuredCapabilities,
    required FirebaseInitializationFailure failure,
  }) : this._(
         status: FirebaseIntegrationStatus.failed,
         capturedAt: capturedAt,
         configuredCapabilities: configuredCapabilities,
         initializedCapabilities: FirebaseCapabilitySet.none,
         failure: failure,
       );

  final FirebaseIntegrationStatus status;
  final DateTime capturedAt;
  final FirebaseCapabilitySet configuredCapabilities;
  final FirebaseCapabilitySet initializedCapabilities;
  final FirebaseInitializationFailure? failure;

  bool get isInitialized => status == FirebaseIntegrationStatus.initialized;

  @override
  bool operator ==(Object other) {
    return other is FirebaseInitializationResult &&
        other.status == status &&
        other.capturedAt == capturedAt &&
        other.configuredCapabilities == configuredCapabilities &&
        other.initializedCapabilities == initializedCapabilities &&
        other.failure == failure;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      capturedAt,
      configuredCapabilities,
      initializedCapabilities,
      failure,
    );
  }
}
