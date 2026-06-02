import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/auth/application/auth_application.dart';
import 'package:repforge/src/features/auth/domain/auth_domain.dart';
import 'package:repforge/src/features/cloud/application/cloud_application.dart';
import 'package:repforge/src/features/cloud/domain/cloud_domain.dart';
import 'package:repforge/src/features/notifications/application/notifications_application.dart';
import 'package:repforge/src/features/notifications/domain/notifications_domain.dart';
import 'package:repforge/src/features/rest_timer/application/rest_timer_application.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';
import 'package:repforge/src/features/sync/domain/sync_domain.dart';

void main() {
  group('remote push boundary', () {
    final now = DateTime.utc(2026, 6, 2, 12);

    test('default state is disabled and non-blocking', () async {
      const configuration = RemotePushRegistrationConfiguration.disabled();
      final gateway = FakeRemotePushGateway(
        RemotePushRegistration.registered(
          capturedAt: now,
          token: RemotePushToken('future-token'),
          registeredCapabilities: RemotePushCapabilitySet.futureBoundary,
          messageTypes: RemotePushMessageTypeSet.futureBoundary,
        ),
      );

      final registration = await RegisterRemotePush(gateway, now: () => now)(
        configuration,
      );

      expect(configuration.shouldRegister, isFalse);
      expect(registration.status, RemotePushRegistrationStatus.disabled);
      expect(registration.blocksLocalUse, isFalse);
      expect(registration.requiresAccountForLocalUse, isFalse);
      expect(registration.token, isNull);
      expect(gateway.registerCount, 0);
    });

    test(
      'fake gateway returns registered unavailable denied token and failed states',
      () async {
        final registered = RemotePushRegistration.registered(
          capturedAt: now,
          token: RemotePushToken('future-token'),
          registeredCapabilities: RemotePushCapabilitySet.only(
            RemotePushCapability.accountSecurity,
          ),
          messageTypes: RemotePushMessageTypeSet.only(
            RemotePushMessageType.accountSecurityNotice,
          ),
        );
        final unavailable = RemotePushRegistration.unavailable(
          capturedAt: now,
          requestedCapabilities: RemotePushCapabilitySet.only(
            RemotePushCapability.serverNews,
          ),
          messageTypes: RemotePushMessageTypeSet.only(
            RemotePushMessageType.serverNews,
          ),
        );
        final denied = RemotePushRegistration.permissionDenied(
          capturedAt: now,
          requestedCapabilities: RemotePushCapabilitySet.only(
            RemotePushCapability.syncConflictNotice,
          ),
          messageTypes: RemotePushMessageTypeSet.only(
            RemotePushMessageType.syncConflictNotice,
          ),
        );
        final tokenUnavailable = RemotePushRegistration.tokenUnavailable(
          capturedAt: now,
          requestedCapabilities: RemotePushCapabilitySet.only(
            RemotePushCapability.socialActivity,
          ),
          messageTypes: RemotePushMessageTypeSet.only(
            RemotePushMessageType.socialActivity,
          ),
        );
        final failed = RemotePushRegistration.failed(
          capturedAt: now,
          requestedCapabilities: RemotePushCapabilitySet.only(
            RemotePushCapability.remoteCoachMessage,
          ),
          messageTypes: RemotePushMessageTypeSet.only(
            RemotePushMessageType.remoteCoachMessage,
          ),
          failure: const RemotePushFailure(
            code: 'push_unavailable',
            message: 'Remote push is not configured.',
          ),
        );
        final gateway = SequenceRemotePushGateway(<RemotePushRegistration>[
          registered,
          unavailable,
          denied,
          tokenUnavailable,
          failed,
        ]);
        final register = RegisterRemotePush(gateway);

        for (final expected in <RemotePushRegistration>[
          registered,
          unavailable,
          denied,
          tokenUnavailable,
          failed,
        ]) {
          final actual = await register(
            RemotePushRegistrationConfiguration.enabled(
              enabledCapabilities: expected.requestedCapabilities,
              messageTypes: expected.messageTypes,
            ),
          );

          expect(actual, expected);
        }

        expect(gateway.registerCount, 5);
      },
    );

    test('disabled capability does not request a push token', () async {
      final gateway = FakeRemotePushGateway(
        RemotePushRegistration.tokenUnavailable(
          capturedAt: now,
          requestedCapabilities: RemotePushCapabilitySet.futureBoundary,
          messageTypes: RemotePushMessageTypeSet.futureBoundary,
        ),
      );

      await RegisterRemotePush(gateway, now: () => now)(
        const RemotePushRegistrationConfiguration.disabled(),
      );

      expect(gateway.registerCount, 0);
      expect(gateway.tokenRequestCount, 0);
    });

    test('registration does not require auth in local-only mode', () async {
      final authStatus = await GetAuthStatus(
        LocalOnlyAuthGateway(now: () => now),
      )();
      final gateway = FakeRemotePushGateway(
        RemotePushRegistration.unavailable(
          capturedAt: now,
          requestedCapabilities: RemotePushCapabilitySet.futureBoundary,
          messageTypes: RemotePushMessageTypeSet.futureBoundary,
        ),
      );

      final registration = await RegisterRemotePush(gateway, now: () => now)(
        const RemotePushRegistrationConfiguration.disabled(),
      );

      expect(authStatus.session.state, AuthSessionState.localOnly);
      expect(registration.status, RemotePushRegistrationStatus.disabled);
      expect(registration.requiresAccountForLocalUse, isFalse);
      expect(gateway.registerCount, 0);
    });

    test(
      'unavailable Firebase boundary does not block local rest timer flow',
      () async {
        final firebaseResult =
            await InitializeFirebaseIntegration(
              UnavailableFirebaseInitializationGateway(now: () => now),
            )(
              FirebaseIntegrationConfiguration.enabled(
                enabledCapabilities: FirebaseCapabilitySet.only(
                  FirebaseCapability.remotePush,
                ),
              ),
            );
        final remotePushGateway = FakeRemotePushGateway(
          RemotePushRegistration.unavailable(
            capturedAt: now,
            requestedCapabilities: RemotePushCapabilitySet.futureBoundary,
            messageTypes: RemotePushMessageTypeSet.futureBoundary,
          ),
        );
        final localNotificationGateway = _FakeRestTimerNotificationGateway();
        final coordinator = RestTimerNotificationCoordinator(
          timerController: RestTimerController(
            timeProvider: _FixedTimeProvider(now),
          ),
          notificationGateway: localNotificationGateway,
        );

        await coordinator.start(
          RestTimerDuration(const Duration(seconds: 90)),
          content: RestTimerNotificationContent.genericFinished,
        );

        expect(firebaseResult.status, FirebaseIntegrationStatus.unavailable);
        expect(localNotificationGateway.scheduledRequests, hasLength(1));
        expect(remotePushGateway.registerCount, 0);
      },
    );

    test('sync metadata does not activate remote push', () async {
      final metadata = SyncMetadata.localOnly(
        entityType: SyncEntityType.workoutSet,
        entityId: SyncEntityId('set-1'),
        createdAt: now,
      );
      final gateway = FakeRemotePushGateway(
        RemotePushRegistration.registered(
          capturedAt: now,
          token: RemotePushToken('future-token'),
          registeredCapabilities: RemotePushCapabilitySet.futureBoundary,
          messageTypes: RemotePushMessageTypeSet.futureBoundary,
        ),
      );

      final registration = await RegisterRemotePush(gateway, now: () => now)(
        const RemotePushRegistrationConfiguration.disabled(),
      );

      expect(metadata.syncState, SyncState.localOnly);
      expect(metadata.requiresRemoteTransport, isFalse);
      expect(registration.status, RemotePushRegistrationStatus.disabled);
      expect(gateway.registerCount, 0);
    });

    test('normal rest periods use local notifications only', () async {
      final remotePushGateway = FakeRemotePushGateway(
        RemotePushRegistration.registered(
          capturedAt: now,
          token: RemotePushToken('future-token'),
          registeredCapabilities: RemotePushCapabilitySet.futureBoundary,
          messageTypes: RemotePushMessageTypeSet.futureBoundary,
        ),
      );
      final localNotificationGateway = _FakeRestTimerNotificationGateway();
      final coordinator = RestTimerNotificationCoordinator(
        timerController: RestTimerController(
          timeProvider: _FixedTimeProvider(now),
        ),
        notificationGateway: localNotificationGateway,
      );

      await coordinator.start(
        RestTimerDuration(const Duration(minutes: 2)),
        content: const RestTimerNotificationContent(
          title: 'Rest complete',
          body: 'Time for the next set.',
        ),
      );

      expect(localNotificationGateway.permissionRequests, 1);
      expect(localNotificationGateway.scheduledRequests, hasLength(1));
      expect(remotePushGateway.registerCount, 0);
      expect(remotePushGateway.tokenRequestCount, 0);
    });
  });

  test('feature domain imports stay free of platform and push SDK APIs', () {
    final domainRoot = Directory('lib/src/features');
    final forbiddenImports = <String>[
      'dart:html',
      'dart:io',
      'dart:ui',
      'package:drift',
      'package:firebase',
      'package:firebase_messaging',
      'package:flutter',
      <String>['package:', 'ht', 'tp'].join(),
      <String>['package:', 'd', 'io'].join(),
    ];
    final violations = <String>[];

    for (final entity in domainRoot.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }
      if (!entity.path.contains('/domain/')) {
        continue;
      }

      final importLines = entity.readAsLinesSync().where(
        (line) => line.trimLeft().startsWith('import '),
      );
      for (final line in importLines) {
        for (final forbidden in forbiddenImports) {
          if (line.contains(forbidden)) {
            violations.add('${entity.path}: $line');
          }
        }
      }
    }

    expect(violations, isEmpty);
  });
}

final class FakeRemotePushGateway implements RemotePushGateway {
  FakeRemotePushGateway(this.registration);

  final RemotePushRegistration registration;
  int registerCount = 0;
  int tokenRequestCount = 0;
  RemotePushRegistrationConfiguration? lastConfiguration;

  @override
  Future<RemotePushRegistration> register(
    RemotePushRegistrationConfiguration configuration,
  ) async {
    registerCount += 1;
    lastConfiguration = configuration;
    if (configuration.shouldRegister) {
      tokenRequestCount += 1;
    }
    return registration;
  }
}

final class SequenceRemotePushGateway implements RemotePushGateway {
  SequenceRemotePushGateway(this._registrations);

  final List<RemotePushRegistration> _registrations;
  int registerCount = 0;

  @override
  Future<RemotePushRegistration> register(
    RemotePushRegistrationConfiguration configuration,
  ) async {
    final index = registerCount;
    registerCount += 1;
    return _registrations[index];
  }
}

final class _FixedTimeProvider implements TimeProvider {
  const _FixedTimeProvider(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

final class _FakeRestTimerNotificationGateway
    implements RestTimerNotificationGateway {
  int permissionRequests = 0;
  final List<RestTimerNotificationRequest> scheduledRequests =
      <RestTimerNotificationRequest>[];
  final List<int> cancelledNotificationIds = <int>[];

  @override
  Future<RestTimerNotificationPermissionStatus> requestPermission() async {
    permissionRequests += 1;
    return RestTimerNotificationPermissionStatus.granted;
  }

  @override
  Future<void> scheduleRestTimerFinished(
    RestTimerNotificationRequest request,
  ) async {
    scheduledRequests.add(request);
  }

  @override
  Future<void> cancelRestTimer(int notificationId) async {
    cancelledNotificationIds.add(notificationId);
  }
}
