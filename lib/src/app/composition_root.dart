import 'dart:async';
import 'dart:ui';

import '../features/analytics/application/analytics_application.dart';
import '../features/auth/application/auth_application.dart';
import '../features/auth/domain/auth_domain.dart';
import '../features/backup/application/backup_application.dart';
import '../features/backup/data/backup_data.dart';
import '../features/backup/domain/backup_domain.dart';
import '../features/cloud/application/cloud_application.dart';
import '../features/cloud/domain/cloud_domain.dart';
import '../features/entitlements/application/entitlements_application.dart';
import '../features/entitlements/domain/entitlements_domain.dart';
import '../features/onboarding/application/onboarding_application.dart';
import '../features/onboarding/data/onboarding_data.dart';
import '../features/onboarding/domain/onboarding_domain.dart';
import '../features/purchases/application/purchases_application.dart';
import '../features/purchases/data/purchases_data.dart';
import '../features/purchases/domain/purchases_domain.dart';
import '../features/rest_timer/application/rest_timer_application.dart';
import '../features/rest_timer/data/rest_timer_data.dart';
import '../features/rest_timer/domain/rest_timer_domain.dart';
import '../features/settings/application/settings_application.dart';
import '../features/settings/data/settings_data.dart';
import '../features/settings/domain/settings_domain.dart';
import '../features/training_log/data/repositories/drift_workout_set_repository.dart';
import '../features/training_log/domain/training_log_domain.dart';
import '../features/workout_groups/data/repositories/drift_workout_group_repository.dart';
import '../features/workout_groups/domain/workout_groups_domain.dart';
import '../shared/data/local/repforge_database.dart';
import '../shared/data/local/repforge_database_factory.dart';

final class AppConfiguration {
  const AppConfiguration({
    this.locale,
    this.firebaseIntegrationConfiguration =
        const FirebaseIntegrationConfiguration.disabled(),
  });

  final Locale? locale;
  final FirebaseIntegrationConfiguration firebaseIntegrationConfiguration;
}

final class AppDependencies {
  AppDependencies({
    required this.configuration,
    required this.workoutSetRepository,
    required this.getExerciseAnalytics,
    required this.restTimerNotifications,
    required this.settingsProfileRepository,
    required this.loadSettingsProfile,
    required this.saveSettingsProfile,
    required this.resetSettingsProfile,
    required this.workoutGroupRepository,
    required this.onboardingStatusRepository,
    required this.loadOnboardingStatus,
    required this.skipOnboarding,
    required this.completeOnboarding,
    required this.localBackupRepository,
    required this.exportLocalBackup,
    required this.validateLocalBackup,
    required this.importLocalBackup,
    required this.authGateway,
    required this.getAuthStatus,
    required this.signOut,
    required this.authSessionPolicy,
    required this.firebaseInitializationGateway,
    required this.initializeFirebaseIntegration,
    required this.entitlementSnapshotSource,
    required this.getFeatureGateDecision,
    required this.purchaseGateway,
    required this.loadPurchaseProducts,
    required this.startPurchase,
    required this.restorePurchases,
    required this.purchaseEntitlementMapper,
    required this.purchaseVerificationSource,
    required this.verifyPurchaseEntitlement,
    required this.entitlementCachePolicy,
  }) : _closeOwnedResources = null;

  AppDependencies._withOwnedResources({
    required this.configuration,
    required this.workoutSetRepository,
    required this.getExerciseAnalytics,
    required this.restTimerNotifications,
    required this.settingsProfileRepository,
    required this.loadSettingsProfile,
    required this.saveSettingsProfile,
    required this.resetSettingsProfile,
    required this.workoutGroupRepository,
    required this.onboardingStatusRepository,
    required this.loadOnboardingStatus,
    required this.skipOnboarding,
    required this.completeOnboarding,
    required this.localBackupRepository,
    required this.exportLocalBackup,
    required this.validateLocalBackup,
    required this.importLocalBackup,
    required this.authGateway,
    required this.getAuthStatus,
    required this.signOut,
    required this.authSessionPolicy,
    required this.firebaseInitializationGateway,
    required this.initializeFirebaseIntegration,
    required this.entitlementSnapshotSource,
    required this.getFeatureGateDecision,
    required this.purchaseGateway,
    required this.loadPurchaseProducts,
    required this.startPurchase,
    required this.restorePurchases,
    required this.purchaseEntitlementMapper,
    required this.purchaseVerificationSource,
    required this.verifyPurchaseEntitlement,
    required this.entitlementCachePolicy,
    required this._closeOwnedResources,
  });

  final AppConfiguration configuration;
  final WorkoutSetRepository workoutSetRepository;
  final GetExerciseAnalytics getExerciseAnalytics;
  final RestTimerNotificationCoordinator restTimerNotifications;
  final SettingsProfileRepository settingsProfileRepository;
  final LoadSettingsProfile loadSettingsProfile;
  final SaveSettingsProfile saveSettingsProfile;
  final ResetSettingsProfile resetSettingsProfile;
  final WorkoutGroupRepository workoutGroupRepository;
  final OnboardingStatusRepository onboardingStatusRepository;
  final LoadOnboardingStatus loadOnboardingStatus;
  final SkipOnboarding skipOnboarding;
  final CompleteOnboarding completeOnboarding;
  final LocalBackupRepository localBackupRepository;
  final ExportLocalBackup exportLocalBackup;
  final ValidateLocalBackup validateLocalBackup;
  final ImportLocalBackup importLocalBackup;
  final AuthGateway authGateway;
  final GetAuthStatus getAuthStatus;
  final SignOut signOut;
  final AuthSessionPolicy authSessionPolicy;
  final FirebaseInitializationGateway firebaseInitializationGateway;
  final InitializeFirebaseIntegration initializeFirebaseIntegration;
  final EntitlementSnapshotSource entitlementSnapshotSource;
  final GetFeatureGateDecision getFeatureGateDecision;
  final PurchaseGateway purchaseGateway;
  final LoadPurchaseProducts loadPurchaseProducts;
  final StartPurchase startPurchase;
  final RestorePurchases restorePurchases;
  final PurchaseEntitlementMapper purchaseEntitlementMapper;
  final PurchaseVerificationSource purchaseVerificationSource;
  final VerifyPurchaseEntitlement verifyPurchaseEntitlement;
  final EntitlementCachePolicy entitlementCachePolicy;

  final Future<void> Function()? _closeOwnedResources;
  Future<void>? _closeOperation;

  /// Closes resources owned by this dependency object.
  ///
  /// Resources created by [CompositionRoot.compose] are owned by this object.
  /// Supplied database instances are closed only when ownership is explicitly
  /// enabled by the caller.
  /// Calling this method more than once is safe; owned resources are closed at
  /// most once.
  Future<void> close() {
    final closeOwnedResources = _closeOwnedResources;
    if (closeOwnedResources == null) {
      return Future<void>.value();
    }

    final existingClose = _closeOperation;
    if (existingClose != null) {
      return existingClose;
    }

    final completer = Completer<void>.sync();
    _closeOperation = completer.future;

    unawaited(
      Future<void>.sync(
        closeOwnedResources,
      ).then(completer.complete, onError: completer.completeError),
    );

    return completer.future;
  }
}

final class CompositionRoot {
  const CompositionRoot({
    this.configuration = const AppConfiguration(),
    this.databaseFactory = const RepForgeDatabaseFactory(),
    this.database,
    this.ownsDatabase,
    this.restTimerNotificationGateway,
    this.authGateway,
    this.firebaseInitializationGateway,
    this.entitlementSnapshotSource,
    this.purchaseGateway,
    this.purchaseVerificationSource,
  });

  final AppConfiguration configuration;
  final RepForgeDatabaseFactory databaseFactory;
  final RepForgeDatabase? database;
  final bool? ownsDatabase;
  final RestTimerNotificationGateway? restTimerNotificationGateway;
  final AuthGateway? authGateway;
  final FirebaseInitializationGateway? firebaseInitializationGateway;
  final EntitlementSnapshotSource? entitlementSnapshotSource;
  final PurchaseGateway? purchaseGateway;
  final PurchaseVerificationSource? purchaseVerificationSource;

  AppDependencies compose() {
    final composedDatabase = database ?? databaseFactory.createDatabase();
    final workoutSetRepository = DriftWorkoutSetRepository(composedDatabase);
    final workoutGroupRepository = DriftWorkoutGroupRepository(
      composedDatabase,
    );
    final settingsProfileRepository = DriftSettingsProfileRepository(
      composedDatabase,
    );
    final onboardingStatusRepository = DriftOnboardingStatusRepository(
      composedDatabase,
    );
    final localBackupRepository = DriftLocalBackupRepository(composedDatabase);
    final getExerciseAnalytics = GetExerciseAnalytics(workoutSetRepository);
    final restTimerNotifications = RestTimerNotificationCoordinator(
      timerController: RestTimerController(
        timeProvider: const SystemTimeProvider(),
      ),
      notificationGateway:
          restTimerNotificationGateway ??
          FlutterLocalRestTimerNotificationGateway(),
    );
    final loadSettingsProfile = LoadSettingsProfile(settingsProfileRepository);
    final saveSettingsProfile = SaveSettingsProfile(settingsProfileRepository);
    final resetSettingsProfile = ResetSettingsProfile(
      settingsProfileRepository,
    );
    final loadOnboardingStatus = LoadOnboardingStatus(
      onboardingStatusRepository,
    );
    final skipOnboarding = SkipOnboarding(onboardingStatusRepository);
    final createStarterGroups = CreateStarterGroups(workoutGroupRepository);
    final completeOnboarding = CompleteOnboarding(
      loadSettingsProfile: loadSettingsProfile,
      saveSettingsProfile: saveSettingsProfile,
      onboardingStatusRepository: onboardingStatusRepository,
      createStarterGroups: createStarterGroups,
      starterTemplateLoader: AssetStarterTemplateLoader(),
    );
    final exportLocalBackup = ExportLocalBackup(localBackupRepository);
    const validateLocalBackup = ValidateLocalBackup();
    final importLocalBackup = ImportLocalBackup(localBackupRepository);
    final composedAuthGateway = authGateway ?? LocalOnlyAuthGateway();
    final getAuthStatus = GetAuthStatus(composedAuthGateway);
    final signOut = SignOut(composedAuthGateway);
    const authSessionPolicy = AuthSessionPolicy();
    final composedFirebaseInitializationGateway =
        firebaseInitializationGateway ??
        UnavailableFirebaseInitializationGateway();
    final initializeFirebaseIntegration = InitializeFirebaseIntegration(
      composedFirebaseInitializationGateway,
    );
    final composedEntitlementSnapshotSource =
        entitlementSnapshotSource ?? LocalFreeEntitlementSnapshotSource();
    final getFeatureGateDecision = GetFeatureGateDecision(
      composedEntitlementSnapshotSource,
    );
    final composedPurchaseGateway = purchaseGateway ?? InAppPurchaseGateway();
    final loadPurchaseProducts = LoadPurchaseProducts(composedPurchaseGateway);
    final startPurchase = StartPurchase(composedPurchaseGateway);
    final restorePurchases = RestorePurchases(composedPurchaseGateway);
    const purchaseEntitlementMapper = PurchaseEntitlementMapper();
    final composedPurchaseVerificationSource =
        purchaseVerificationSource ?? UnavailablePurchaseVerificationSource();
    final verifyPurchaseEntitlement = VerifyPurchaseEntitlement(
      composedPurchaseVerificationSource,
    );
    const entitlementCachePolicy = EntitlementCachePolicy();
    final shouldOwnDatabase = ownsDatabase ?? (database == null);

    if (!shouldOwnDatabase) {
      return AppDependencies(
        configuration: configuration,
        workoutSetRepository: workoutSetRepository,
        getExerciseAnalytics: getExerciseAnalytics,
        restTimerNotifications: restTimerNotifications,
        settingsProfileRepository: settingsProfileRepository,
        loadSettingsProfile: loadSettingsProfile,
        saveSettingsProfile: saveSettingsProfile,
        resetSettingsProfile: resetSettingsProfile,
        workoutGroupRepository: workoutGroupRepository,
        onboardingStatusRepository: onboardingStatusRepository,
        loadOnboardingStatus: loadOnboardingStatus,
        skipOnboarding: skipOnboarding,
        completeOnboarding: completeOnboarding,
        localBackupRepository: localBackupRepository,
        exportLocalBackup: exportLocalBackup,
        validateLocalBackup: validateLocalBackup,
        importLocalBackup: importLocalBackup,
        authGateway: composedAuthGateway,
        getAuthStatus: getAuthStatus,
        signOut: signOut,
        authSessionPolicy: authSessionPolicy,
        firebaseInitializationGateway: composedFirebaseInitializationGateway,
        initializeFirebaseIntegration: initializeFirebaseIntegration,
        entitlementSnapshotSource: composedEntitlementSnapshotSource,
        getFeatureGateDecision: getFeatureGateDecision,
        purchaseGateway: composedPurchaseGateway,
        loadPurchaseProducts: loadPurchaseProducts,
        startPurchase: startPurchase,
        restorePurchases: restorePurchases,
        purchaseEntitlementMapper: purchaseEntitlementMapper,
        purchaseVerificationSource: composedPurchaseVerificationSource,
        verifyPurchaseEntitlement: verifyPurchaseEntitlement,
        entitlementCachePolicy: entitlementCachePolicy,
      );
    }

    return AppDependencies._withOwnedResources(
      configuration: configuration,
      workoutSetRepository: workoutSetRepository,
      getExerciseAnalytics: getExerciseAnalytics,
      restTimerNotifications: restTimerNotifications,
      settingsProfileRepository: settingsProfileRepository,
      loadSettingsProfile: loadSettingsProfile,
      saveSettingsProfile: saveSettingsProfile,
      resetSettingsProfile: resetSettingsProfile,
      workoutGroupRepository: workoutGroupRepository,
      onboardingStatusRepository: onboardingStatusRepository,
      loadOnboardingStatus: loadOnboardingStatus,
      skipOnboarding: skipOnboarding,
      completeOnboarding: completeOnboarding,
      localBackupRepository: localBackupRepository,
      exportLocalBackup: exportLocalBackup,
      validateLocalBackup: validateLocalBackup,
      importLocalBackup: importLocalBackup,
      authGateway: composedAuthGateway,
      getAuthStatus: getAuthStatus,
      signOut: signOut,
      authSessionPolicy: authSessionPolicy,
      firebaseInitializationGateway: composedFirebaseInitializationGateway,
      initializeFirebaseIntegration: initializeFirebaseIntegration,
      entitlementSnapshotSource: composedEntitlementSnapshotSource,
      getFeatureGateDecision: getFeatureGateDecision,
      purchaseGateway: composedPurchaseGateway,
      loadPurchaseProducts: loadPurchaseProducts,
      startPurchase: startPurchase,
      restorePurchases: restorePurchases,
      purchaseEntitlementMapper: purchaseEntitlementMapper,
      purchaseVerificationSource: composedPurchaseVerificationSource,
      verifyPurchaseEntitlement: verifyPurchaseEntitlement,
      entitlementCachePolicy: entitlementCachePolicy,
      closeOwnedResources: composedDatabase.close,
    );
  }
}
