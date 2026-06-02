import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/composition_root.dart';
import 'package:repforge/src/features/auth/domain/auth_domain.dart';
import 'package:repforge/src/features/backup/data/backup_data.dart';
import 'package:repforge/src/features/backup/domain/backup_domain.dart';
import 'package:repforge/src/features/cloud/domain/cloud_domain.dart';
import 'package:repforge/src/features/notifications/domain/notifications_domain.dart';
import 'package:repforge/src/features/onboarding/data/onboarding_data.dart';
import 'package:repforge/src/features/onboarding/domain/onboarding_domain.dart';
import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';
import 'package:repforge/src/features/rest_timer/application/rest_timer_application.dart';
import 'package:repforge/src/features/settings/data/settings_data.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/data/repositories/drift_workout_set_repository.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database_factory.dart';

import '../features/purchases/fakes/fake_purchase_gateway.dart';

void main() {
  test('builds current app dependencies from an injected database factory', () {
    final dependencies = _composeInMemoryDependencies();

    addTearDown(dependencies.close);

    expect(dependencies.configuration.locale, isNull);
    expect(dependencies.workoutSetRepository, isA<WorkoutSetRepository>());
    expect(dependencies.workoutSetRepository, isA<DriftWorkoutSetRepository>());
    expect(
      dependencies.settingsProfileRepository,
      isA<SettingsProfileRepository>(),
    );
    expect(
      dependencies.settingsProfileRepository,
      isA<DriftSettingsProfileRepository>(),
    );
    expect(
      dependencies.onboardingStatusRepository,
      isA<OnboardingStatusRepository>(),
    );
    expect(
      dependencies.onboardingStatusRepository,
      isA<DriftOnboardingStatusRepository>(),
    );
    expect(dependencies.localBackupRepository, isA<LocalBackupRepository>());
    expect(
      dependencies.localBackupRepository,
      isA<DriftLocalBackupRepository>(),
    );
    expect(
      dependencies.restTimerNotifications,
      isA<RestTimerNotificationCoordinator>(),
    );
    expect(dependencies.authGateway, isA<AuthGateway>());
    expect(
      dependencies.configuration.firebaseIntegrationConfiguration,
      const FirebaseIntegrationConfiguration.disabled(),
    );
    expect(
      dependencies.configuration.remotePushRegistrationConfiguration,
      const RemotePushRegistrationConfiguration.disabled(),
    );
    expect(
      dependencies.firebaseInitializationGateway,
      isA<FirebaseInitializationGateway>(),
    );
    expect(dependencies.remotePushGateway, isA<RemotePushGateway>());
    expect(dependencies.purchaseGateway, isA<PurchaseGateway>());
    expect(
      dependencies.purchaseVerificationSource,
      isA<PurchaseVerificationSource>(),
    );
  });

  test('composed repository saves and finds a workout set', () async {
    final dependencies = _composeInMemoryDependencies();

    addTearDown(dependencies.close);

    final set = _set(id: 'composed-set-1');

    await dependencies.workoutSetRepository.save(set);

    expect(
      await dependencies.workoutSetRepository.findById(
        WorkoutSetId('composed-set-1'),
      ),
      set,
    );
  });

  test('composed settings repository saves and loads profile', () async {
    final dependencies = _composeInMemoryDependencies();

    addTearDown(dependencies.close);

    final profile = SettingsProfile.defaults().copyWith(
      focusProfile: FocusProfile.timeEfficient,
    );

    await dependencies.saveSettingsProfile(profile);

    expect(await dependencies.loadSettingsProfile(), profile);
  });

  test('composed onboarding status repository saves skipped state', () async {
    final dependencies = _composeInMemoryDependencies();

    addTearDown(dependencies.close);

    await dependencies.skipOnboarding();

    expect(
      (await dependencies.loadOnboardingStatus()).completion,
      OnboardingCompletion.skipped,
    );
  });

  test('composed backup repository exports local JSON', () async {
    final dependencies = _composeInMemoryDependencies();

    addTearDown(dependencies.close);

    final json = await dependencies.exportLocalBackup();

    expect(json, contains('"exportVersion":1'));
    expect(json, contains('"appId":"repforge"'));
  });

  test(
    'failed Firebase initialization does not block local dependencies',
    () async {
      final failedFirebaseGateway = _FakeFirebaseInitializationGateway(
        FirebaseInitializationResult.failed(
          capturedAt: DateTime.utc(2026, 6),
          configuredCapabilities: FirebaseCapabilitySet.only(
            FirebaseCapability.auth,
          ),
          failure: const FirebaseInitializationFailure(
            code: 'firebase_unavailable',
            message: 'Firebase is not configured.',
          ),
        ),
      );
      final dependencies = _composeInMemoryDependencies(
        configuration: AppConfiguration(
          firebaseIntegrationConfiguration:
              FirebaseIntegrationConfiguration.enabled(
                enabledCapabilities: FirebaseCapabilitySet.only(
                  FirebaseCapability.auth,
                ),
              ),
        ),
        firebaseInitializationGateway: failedFirebaseGateway,
      );

      addTearDown(dependencies.close);

      final firebaseResult = await dependencies.initializeFirebaseIntegration(
        dependencies.configuration.firebaseIntegrationConfiguration,
      );
      final set = _set(id: 'firebase-failed-local-set');

      await dependencies.workoutSetRepository.save(set);

      expect(firebaseResult.status, FirebaseIntegrationStatus.failed);
      expect(failedFirebaseGateway.initializeCount, 1);
      expect(
        await dependencies.workoutSetRepository.findById(
          WorkoutSetId('firebase-failed-local-set'),
        ),
        set,
      );
    },
  );

  test('default remote push registration does not block local data', () async {
    final dependencies = _composeInMemoryDependencies();

    addTearDown(dependencies.close);

    final registration = await dependencies.registerRemotePush(
      dependencies.configuration.remotePushRegistrationConfiguration,
    );
    final set = _set(id: 'remote-push-disabled-local-set');

    await dependencies.workoutSetRepository.save(set);

    expect(registration.status, RemotePushRegistrationStatus.disabled);
    expect(registration.blocksLocalUse, isFalse);
    expect(
      await dependencies.workoutSetRepository.findById(
        WorkoutSetId('remote-push-disabled-local-set'),
      ),
      set,
    );
  });

  test('close is idempotent for owned dependencies', () async {
    final dependencies = _composeInMemoryDependencies();

    await dependencies.close();
    await dependencies.close();
    await dependencies.close();
  });
}

AppDependencies _composeInMemoryDependencies({
  AppConfiguration configuration = const AppConfiguration(),
  FirebaseInitializationGateway? firebaseInitializationGateway,
}) {
  return CompositionRoot(
    configuration: configuration,
    databaseFactory: RepForgeDatabaseFactory(
      createExecutor: () => NativeDatabase.memory(),
    ),
    firebaseInitializationGateway: firebaseInitializationGateway,
    purchaseGateway: FakePurchaseGateway(
      products: const <PurchaseProduct>[],
      now: DateTime.now,
    ),
  ).compose();
}

WorkoutSet _set({required String id}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell-bench-press'),
      displayNameSnapshot: 'Barbell Bench Press',
      catalogVersionSnapshot: '2026.05.0',
    ),
    repetitions: Repetitions(5),
    load: LoadKg(100),
    performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 12)),
  );
}

final class _FakeFirebaseInitializationGateway
    implements FirebaseInitializationGateway {
  _FakeFirebaseInitializationGateway(this.result);

  final FirebaseInitializationResult result;
  int initializeCount = 0;

  @override
  Future<FirebaseInitializationResult> initialize(
    FirebaseIntegrationConfiguration configuration,
  ) async {
    initializeCount += 1;
    return result;
  }
}
