enum SyncEntityType {
  workoutSet,
  workoutGroup,
  workoutGroupAssignment,
  customExercise,
  settingsProfile,
  onboardingStatus,
  officialCatalog,
  officialExercise;

  static const Set<SyncEntityType> localMvpEntityTypes = <SyncEntityType>{
    SyncEntityType.workoutSet,
    SyncEntityType.workoutGroup,
    SyncEntityType.workoutGroupAssignment,
    SyncEntityType.customExercise,
    SyncEntityType.settingsProfile,
    SyncEntityType.onboardingStatus,
    SyncEntityType.officialCatalog,
    SyncEntityType.officialExercise,
  };
}

extension SyncEntityTypePolicy on SyncEntityType {
  bool get isUserDataSyncCandidate {
    return switch (this) {
      SyncEntityType.workoutSet ||
      SyncEntityType.workoutGroup ||
      SyncEntityType.workoutGroupAssignment ||
      SyncEntityType.customExercise ||
      SyncEntityType.settingsProfile ||
      SyncEntityType.onboardingStatus => true,
      SyncEntityType.officialCatalog ||
      SyncEntityType.officialExercise => false,
    };
  }

  bool get requiresSyncForLocalUse => false;
}
