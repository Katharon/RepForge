import '../value_objects/remote_push_capability.dart';
import '../value_objects/remote_push_failure.dart';
import '../value_objects/remote_push_message_type.dart';
import '../value_objects/remote_push_permission_status.dart';
import '../value_objects/remote_push_registration_status.dart';
import '../value_objects/remote_push_token.dart';

final class RemotePushRegistrationConfiguration {
  const RemotePushRegistrationConfiguration.disabled()
    : isEnabled = false,
      enabledCapabilities = RemotePushCapabilitySet.none,
      messageTypes = RemotePushMessageTypeSet.none;

  const RemotePushRegistrationConfiguration.enabled({
    required this.enabledCapabilities,
    required this.messageTypes,
  }) : isEnabled = true;

  final bool isEnabled;
  final RemotePushCapabilitySet enabledCapabilities;
  final RemotePushMessageTypeSet messageTypes;

  bool get shouldRegister =>
      isEnabled && enabledCapabilities.isNotEmpty && messageTypes.isNotEmpty;

  bool get requiresAccountForLocalUse => false;

  bool isCapabilityEnabled(RemotePushCapability capability) {
    return isEnabled && enabledCapabilities.contains(capability);
  }

  @override
  bool operator ==(Object other) {
    return other is RemotePushRegistrationConfiguration &&
        other.isEnabled == isEnabled &&
        other.enabledCapabilities == enabledCapabilities &&
        other.messageTypes == messageTypes;
  }

  @override
  int get hashCode => Object.hash(isEnabled, enabledCapabilities, messageTypes);
}

final class RemotePushRegistration {
  const RemotePushRegistration._({
    required this.status,
    required this.capturedAt,
    required this.requestedCapabilities,
    required this.registeredCapabilities,
    required this.messageTypes,
    required this.permissionStatus,
    this.token,
    this.failure,
  });

  const RemotePushRegistration.disabled({
    required DateTime capturedAt,
    RemotePushCapabilitySet requestedCapabilities =
        RemotePushCapabilitySet.none,
    RemotePushMessageTypeSet messageTypes = RemotePushMessageTypeSet.none,
  }) : this._(
         status: RemotePushRegistrationStatus.disabled,
         capturedAt: capturedAt,
         requestedCapabilities: requestedCapabilities,
         registeredCapabilities: RemotePushCapabilitySet.none,
         messageTypes: messageTypes,
         permissionStatus: RemotePushPermissionStatus.unknown,
       );

  const RemotePushRegistration.unavailable({
    required DateTime capturedAt,
    required RemotePushCapabilitySet requestedCapabilities,
    required RemotePushMessageTypeSet messageTypes,
  }) : this._(
         status: RemotePushRegistrationStatus.unavailable,
         capturedAt: capturedAt,
         requestedCapabilities: requestedCapabilities,
         registeredCapabilities: RemotePushCapabilitySet.none,
         messageTypes: messageTypes,
         permissionStatus: RemotePushPermissionStatus.unavailable,
       );

  const RemotePushRegistration.permissionDenied({
    required DateTime capturedAt,
    required RemotePushCapabilitySet requestedCapabilities,
    required RemotePushMessageTypeSet messageTypes,
  }) : this._(
         status: RemotePushRegistrationStatus.permissionDenied,
         capturedAt: capturedAt,
         requestedCapabilities: requestedCapabilities,
         registeredCapabilities: RemotePushCapabilitySet.none,
         messageTypes: messageTypes,
         permissionStatus: RemotePushPermissionStatus.denied,
       );

  const RemotePushRegistration.tokenUnavailable({
    required DateTime capturedAt,
    required RemotePushCapabilitySet requestedCapabilities,
    required RemotePushMessageTypeSet messageTypes,
  }) : this._(
         status: RemotePushRegistrationStatus.tokenUnavailable,
         capturedAt: capturedAt,
         requestedCapabilities: requestedCapabilities,
         registeredCapabilities: RemotePushCapabilitySet.none,
         messageTypes: messageTypes,
         permissionStatus: RemotePushPermissionStatus.granted,
       );

  const RemotePushRegistration.registered({
    required DateTime capturedAt,
    required RemotePushToken token,
    required RemotePushCapabilitySet registeredCapabilities,
    required RemotePushMessageTypeSet messageTypes,
  }) : this._(
         status: RemotePushRegistrationStatus.registered,
         capturedAt: capturedAt,
         requestedCapabilities: registeredCapabilities,
         registeredCapabilities: registeredCapabilities,
         messageTypes: messageTypes,
         permissionStatus: RemotePushPermissionStatus.granted,
         token: token,
       );

  const RemotePushRegistration.failed({
    required DateTime capturedAt,
    required RemotePushCapabilitySet requestedCapabilities,
    required RemotePushMessageTypeSet messageTypes,
    required RemotePushFailure failure,
  }) : this._(
         status: RemotePushRegistrationStatus.failed,
         capturedAt: capturedAt,
         requestedCapabilities: requestedCapabilities,
         registeredCapabilities: RemotePushCapabilitySet.none,
         messageTypes: messageTypes,
         permissionStatus: RemotePushPermissionStatus.unknown,
         failure: failure,
       );

  final RemotePushRegistrationStatus status;
  final DateTime capturedAt;
  final RemotePushCapabilitySet requestedCapabilities;
  final RemotePushCapabilitySet registeredCapabilities;
  final RemotePushMessageTypeSet messageTypes;
  final RemotePushPermissionStatus permissionStatus;
  final RemotePushToken? token;
  final RemotePushFailure? failure;

  bool get isRegistered => status == RemotePushRegistrationStatus.registered;

  bool get blocksLocalUse => false;

  bool get requiresAccountForLocalUse => false;

  @override
  bool operator ==(Object other) {
    return other is RemotePushRegistration &&
        other.status == status &&
        other.capturedAt == capturedAt &&
        other.requestedCapabilities == requestedCapabilities &&
        other.registeredCapabilities == registeredCapabilities &&
        other.messageTypes == messageTypes &&
        other.permissionStatus == permissionStatus &&
        other.token == token &&
        other.failure == failure;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      capturedAt,
      requestedCapabilities,
      registeredCapabilities,
      messageTypes,
      permissionStatus,
      token,
      failure,
    );
  }
}
