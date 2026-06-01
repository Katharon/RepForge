import 'premium_feature.dart';

enum FeatureGate {
  localWorkoutTracking,
  workoutGroups,
  customExercises,
  officialBaseCatalog,
  localBackupExport,
  baseAnalytics,
  privacySecurity,
  settingsProfile,
  onboarding,
  localImportExportValidation,
  advancedAnalytics,
  coachRecommendations,
  muscleBalanceHeatmap,
  advancedTemplates,
  optionalCloudSync,
  advancedExportFormats;

  static const localMvpFeatures = <FeatureGate>[
    FeatureGate.localWorkoutTracking,
    FeatureGate.workoutGroups,
    FeatureGate.customExercises,
    FeatureGate.officialBaseCatalog,
    FeatureGate.localBackupExport,
    FeatureGate.baseAnalytics,
    FeatureGate.privacySecurity,
    FeatureGate.settingsProfile,
    FeatureGate.onboarding,
    FeatureGate.localImportExportValidation,
  ];

  static const premiumFeatures = <FeatureGate>[
    FeatureGate.advancedAnalytics,
    FeatureGate.coachRecommendations,
    FeatureGate.muscleBalanceHeatmap,
    FeatureGate.advancedTemplates,
    FeatureGate.optionalCloudSync,
    FeatureGate.advancedExportFormats,
  ];
}

extension FeatureGateClassification on FeatureGate {
  bool get isLocalMvpFeature => FeatureGate.localMvpFeatures.contains(this);

  bool get requiresPremiumEntitlement =>
      FeatureGate.premiumFeatures.contains(this);

  bool get isUnavailableBeforeFutureSlice =>
      this == FeatureGate.optionalCloudSync;

  PremiumFeature? get premiumFeature {
    switch (this) {
      case FeatureGate.advancedAnalytics:
        return PremiumFeature.advancedAnalytics;
      case FeatureGate.coachRecommendations:
        return PremiumFeature.coachRecommendations;
      case FeatureGate.muscleBalanceHeatmap:
        return PremiumFeature.muscleBalanceHeatmap;
      case FeatureGate.advancedTemplates:
        return PremiumFeature.advancedTemplates;
      case FeatureGate.optionalCloudSync:
        return PremiumFeature.optionalCloudSync;
      case FeatureGate.advancedExportFormats:
        return PremiumFeature.advancedExportFormats;
      case FeatureGate.localWorkoutTracking:
      case FeatureGate.workoutGroups:
      case FeatureGate.customExercises:
      case FeatureGate.officialBaseCatalog:
      case FeatureGate.localBackupExport:
      case FeatureGate.baseAnalytics:
      case FeatureGate.privacySecurity:
      case FeatureGate.settingsProfile:
      case FeatureGate.onboarding:
      case FeatureGate.localImportExportValidation:
        return null;
    }
  }
}
