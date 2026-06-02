import '../entities/remote_push_registration.dart';

abstract interface class RemotePushGateway {
  Future<RemotePushRegistration> register(
    RemotePushRegistrationConfiguration configuration,
  );
}
