import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/auth/application/auth_application.dart';
import 'package:repforge/src/features/auth/domain/auth_domain.dart';
import 'package:repforge/src/features/cloud/application/cloud_application.dart';
import 'package:repforge/src/features/cloud/domain/cloud_domain.dart';
import 'package:repforge/src/features/rest_timer/application/rest_timer_application.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';

void main() {
  group('Firebase optional integration boundary', () {
    final now = DateTime.utc(2026, 6);

    test('default configuration is disabled and does not initialize', () async {
      const configuration = FirebaseIntegrationConfiguration.disabled();
      final gateway = _FakeFirebaseInitializationGateway(
        FirebaseInitializationResult.initialized(
          capturedAt: now,
          initializedCapabilities: FirebaseCapabilitySet.futureFirebaseBoundary,
        ),
      );
      final initialize = InitializeFirebaseIntegration(gateway, now: () => now);

      final result = await initialize(configuration);

      expect(configuration.isEnabled, isFalse);
      expect(configuration.shouldInitialize, isFalse);
      expect(configuration.enabledCapabilities, FirebaseCapabilitySet.none);
      expect(result.status, FirebaseIntegrationStatus.disabled);
      expect(result.initializedCapabilities, FirebaseCapabilitySet.none);
      expect(gateway.initializeCount, 0);
    });

    test('local MVP capabilities do not require Firebase', () async {
      const configuration = FirebaseIntegrationConfiguration.enabled(
        enabledCapabilities: FirebaseCapabilitySet.localMvp,
      );
      final gateway = _FakeFirebaseInitializationGateway(
        FirebaseInitializationResult.initialized(
          capturedAt: now,
          initializedCapabilities: FirebaseCapabilitySet.futureFirebaseBoundary,
        ),
      );

      final result = await InitializeFirebaseIntegration(
        gateway,
        now: () => now,
      )(configuration);

      expect(FirebaseCapabilitySet.localMvp.isEmpty, isTrue);
      expect(configuration.shouldInitialize, isFalse);
      expect(result.status, FirebaseIntegrationStatus.disabled);
      expect(gateway.initializeCount, 0);
    });

    test(
      'fake gateway can report initialized unavailable and failed states',
      () async {
        final initialized = FirebaseInitializationResult.initialized(
          capturedAt: now,
          initializedCapabilities: FirebaseCapabilitySet.of(
            <FirebaseCapability>{
              FirebaseCapability.auth,
              FirebaseCapability.crashReporting,
            },
          ),
        );
        final unavailable = FirebaseInitializationResult.unavailable(
          capturedAt: now,
          configuredCapabilities: FirebaseCapabilitySet.only(
            FirebaseCapability.remotePush,
          ),
        );
        final failed = FirebaseInitializationResult.failed(
          capturedAt: now,
          configuredCapabilities: FirebaseCapabilitySet.only(
            FirebaseCapability.remoteConfig,
          ),
          failure: const FirebaseInitializationFailure(
            code: 'firebase_unavailable',
            message: 'Firebase is not configured.',
          ),
        );
        final gateway = _SequenceFirebaseInitializationGateway(
          <FirebaseInitializationResult>[initialized, unavailable, failed],
        );
        final initialize = InitializeFirebaseIntegration(gateway);

        for (final expected in <FirebaseInitializationResult>[
          initialized,
          unavailable,
          failed,
        ]) {
          final actual = await initialize(
            FirebaseIntegrationConfiguration.enabled(
              enabledCapabilities: expected.configuredCapabilities,
            ),
          );

          expect(actual, expected);
        }

        expect(gateway.initializeCount, 3);
      },
    );

    test('disabled remote-push capability is not initialized', () async {
      final configuration = FirebaseIntegrationConfiguration.enabled(
        enabledCapabilities: FirebaseCapabilitySet.only(
          FirebaseCapability.auth,
        ),
      );

      expect(configuration.shouldInitialize, isTrue);
      expect(
        configuration.isCapabilityEnabled(FirebaseCapability.remotePush),
        isFalse,
      );
    });

    test('default gateway reports unavailable without Firebase SDKs', () async {
      final configuration = FirebaseIntegrationConfiguration.enabled(
        enabledCapabilities: FirebaseCapabilitySet.only(
          FirebaseCapability.auth,
        ),
      );

      final result = await InitializeFirebaseIntegration(
        UnavailableFirebaseInitializationGateway(now: () => now),
      )(configuration);

      expect(result.status, FirebaseIntegrationStatus.unavailable);
      expect(
        result.configuredCapabilities.contains(FirebaseCapability.auth),
        isTrue,
      );
      expect(result.initializedCapabilities, FirebaseCapabilitySet.none);
    });

    test(
      'FCM capability is separate from local rest timer notifications',
      () async {
        final firebaseGateway = _FakeFirebaseInitializationGateway(
          FirebaseInitializationResult.initialized(
            capturedAt: now,
            initializedCapabilities: FirebaseCapabilitySet.only(
              FirebaseCapability.remotePush,
            ),
          ),
        );
        final restNotificationGateway = _FakeRestTimerNotificationGateway();
        final coordinator = RestTimerNotificationCoordinator(
          timerController: RestTimerController(
            timeProvider: _FixedTimeProvider(now),
          ),
          notificationGateway: restNotificationGateway,
        );

        await coordinator.start(
          RestTimerDuration(const Duration(seconds: 90)),
          content: RestTimerNotificationContent.genericFinished,
        );

        expect(restNotificationGateway.scheduleCount, 1);
        expect(
          restNotificationGateway.lastRequest?.targetAt,
          now.add(const Duration(seconds: 90)),
        );
        expect(firebaseGateway.initializeCount, 0);
      },
    );

    test(
      'auth boundary remains local-only by default without Firebase Auth',
      () async {
        final firebaseGateway = _FakeFirebaseInitializationGateway(
          FirebaseInitializationResult.initialized(
            capturedAt: now,
            initializedCapabilities: FirebaseCapabilitySet.only(
              FirebaseCapability.auth,
            ),
          ),
        );
        final authStatus = await GetAuthStatus(
          LocalOnlyAuthGateway(now: () => now),
        )();
        final firebaseStatus = await InitializeFirebaseIntegration(
          firebaseGateway,
          now: () => now,
        )(const FirebaseIntegrationConfiguration.disabled());

        expect(authStatus.session.state, AuthSessionState.localOnly);
        expect(firebaseStatus.status, FirebaseIntegrationStatus.disabled);
        expect(firebaseGateway.initializeCount, 0);
      },
    );
  });

  test('feature domain imports stay free of platform and Firebase APIs', () {
    final domainRoot = Directory('lib/src/features');
    final forbiddenImports = <String>[
      'dart:html',
      'dart:io',
      'dart:ui',
      'package:drift',
      'package:firebase',
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

final class _FakeFirebaseInitializationGateway
    implements FirebaseInitializationGateway {
  _FakeFirebaseInitializationGateway(this.result);

  final FirebaseInitializationResult result;
  int initializeCount = 0;
  FirebaseIntegrationConfiguration? lastConfiguration;

  @override
  Future<FirebaseInitializationResult> initialize(
    FirebaseIntegrationConfiguration configuration,
  ) async {
    initializeCount += 1;
    lastConfiguration = configuration;
    return result;
  }
}

final class _SequenceFirebaseInitializationGateway
    implements FirebaseInitializationGateway {
  _SequenceFirebaseInitializationGateway(this._results);

  final List<FirebaseInitializationResult> _results;
  int initializeCount = 0;

  @override
  Future<FirebaseInitializationResult> initialize(
    FirebaseIntegrationConfiguration configuration,
  ) async {
    return _results[initializeCount++];
  }
}

final class _FixedTimeProvider implements TimeProvider {
  const _FixedTimeProvider(this.value);

  final DateTime value;

  @override
  DateTime now() => value;
}

final class _FakeRestTimerNotificationGateway
    implements RestTimerNotificationGateway {
  int scheduleCount = 0;
  RestTimerNotificationRequest? lastRequest;

  @override
  Future<RestTimerNotificationPermissionStatus> requestPermission() async {
    return RestTimerNotificationPermissionStatus.granted;
  }

  @override
  Future<void> scheduleRestTimerFinished(
    RestTimerNotificationRequest request,
  ) async {
    scheduleCount += 1;
    lastRequest = request;
  }

  @override
  Future<void> cancelRestTimer(int notificationId) async {}
}
