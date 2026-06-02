import '../value_objects/capability.dart';

final class FirebaseIntegrationConfiguration {
  const FirebaseIntegrationConfiguration.disabled()
    : isEnabled = false,
      enabledCapabilities = FirebaseCapabilitySet.none;

  const FirebaseIntegrationConfiguration.enabled({
    required this.enabledCapabilities,
  }) : isEnabled = true;

  final bool isEnabled;
  final FirebaseCapabilitySet enabledCapabilities;

  bool get shouldInitialize => isEnabled && enabledCapabilities.isNotEmpty;

  bool isCapabilityEnabled(FirebaseCapability capability) {
    return isEnabled && enabledCapabilities.contains(capability);
  }

  @override
  bool operator ==(Object other) {
    return other is FirebaseIntegrationConfiguration &&
        other.isEnabled == isEnabled &&
        other.enabledCapabilities == enabledCapabilities;
  }

  @override
  int get hashCode => Object.hash(isEnabled, enabledCapabilities);
}
