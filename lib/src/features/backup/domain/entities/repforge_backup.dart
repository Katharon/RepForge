import 'dart:convert';

import '../exceptions/backup_validation_exception.dart';

const int currentBackupExportVersion = 1;
const int currentBackupSchemaVersion = 1;
const String repForgeBackupAppId = 'repforge';

final class BackupValidationResult {
  const BackupValidationResult._(this.errors);

  factory BackupValidationResult.valid() {
    return const BackupValidationResult._(<BackupValidationError>[]);
  }

  factory BackupValidationResult.invalid(
    Iterable<BackupValidationError> errors,
  ) {
    return BackupValidationResult._(
      List<BackupValidationError>.unmodifiable(errors),
    );
  }

  final List<BackupValidationError> errors;

  bool get isValid => errors.isEmpty;
}

final class RepForgeBackup {
  const RepForgeBackup({
    required this.exportVersion,
    required this.schemaVersion,
    required this.appId,
    required this.exportedAt,
    required this.workoutSets,
    required this.workoutGroups,
    required this.workoutGroupAssignments,
    required this.catalogImports,
    this.settingsProfile,
    this.onboardingStatus,
  });

  factory RepForgeBackup.create({
    required DateTime exportedAt,
    List<BackupWorkoutSet> workoutSets = const <BackupWorkoutSet>[],
    List<BackupWorkoutGroup> workoutGroups = const <BackupWorkoutGroup>[],
    List<BackupWorkoutGroupAssignment> workoutGroupAssignments =
        const <BackupWorkoutGroupAssignment>[],
    List<BackupCatalogImport> catalogImports = const <BackupCatalogImport>[],
    BackupSettingsProfile? settingsProfile,
    BackupOnboardingStatus? onboardingStatus,
  }) {
    return RepForgeBackup(
      exportVersion: currentBackupExportVersion,
      schemaVersion: currentBackupSchemaVersion,
      appId: repForgeBackupAppId,
      exportedAt: exportedAt.toUtc(),
      workoutSets: workoutSets,
      workoutGroups: workoutGroups,
      workoutGroupAssignments: workoutGroupAssignments,
      catalogImports: catalogImports,
      settingsProfile: settingsProfile,
      onboardingStatus: onboardingStatus,
    );
  }

  factory RepForgeBackup.fromJson(Map<String, Object?> json) {
    final errors = <BackupValidationError>[];

    final exportVersion = _requiredInt(json, 'exportVersion', errors);
    final schemaVersion = _requiredInt(json, 'schemaVersion', errors);
    final appId = _requiredString(json, 'appId', errors);
    final exportedAt = _requiredDateTime(json, 'exportedAt', errors);

    if (exportVersion != null && exportVersion != currentBackupExportVersion) {
      errors.add(
        const BackupValidationError(
          field: 'exportVersion',
          message: 'Unsupported backup export version.',
        ),
      );
    }
    if (schemaVersion != null && schemaVersion != currentBackupSchemaVersion) {
      errors.add(
        const BackupValidationError(
          field: 'schemaVersion',
          message: 'Unsupported backup schema version.',
        ),
      );
    }
    if (appId != null && appId != repForgeBackupAppId) {
      errors.add(
        const BackupValidationError(
          field: 'appId',
          message: 'Unsupported backup app identifier.',
        ),
      );
    }

    final workoutSets = _requiredList(
      json,
      'workoutSets',
      errors,
      (value, field) => BackupWorkoutSet.fromJson(value, field, errors),
    );
    final workoutGroups = _requiredList(
      json,
      'workoutGroups',
      errors,
      (value, field) => BackupWorkoutGroup.fromJson(value, field, errors),
    );
    final assignments = _requiredList(json, 'workoutGroupAssignments', errors, (
      value,
      field,
    ) {
      return BackupWorkoutGroupAssignment.fromJson(value, field, errors);
    });
    final catalogImports = _optionalList(
      json,
      'catalogImports',
      errors,
      (value, field) => BackupCatalogImport.fromJson(value, field, errors),
    );

    final settingsProfile = _optionalObject(
      json,
      'settingsProfile',
      errors,
      (value, field) => BackupSettingsProfile.fromJson(value, field, errors),
    );
    final onboardingStatus = _optionalObject(
      json,
      'onboardingStatus',
      errors,
      (value, field) => BackupOnboardingStatus.fromJson(value, field, errors),
    );

    _rejectDuplicates(
      field: 'workoutSets.id',
      values: workoutSets.map((set) => set.id),
      errors: errors,
    );
    _rejectDuplicates(
      field: 'workoutGroups.id',
      values: workoutGroups.map((group) => group.id),
      errors: errors,
    );
    _rejectDuplicates(
      field: 'workoutGroupAssignments.id',
      values: assignments.map((assignment) => assignment.id),
      errors: errors,
    );

    if (errors.isNotEmpty) {
      throw BackupValidationException(errors);
    }

    return RepForgeBackup(
      exportVersion: exportVersion!,
      schemaVersion: schemaVersion!,
      appId: appId!,
      exportedAt: exportedAt!,
      workoutSets: List<BackupWorkoutSet>.unmodifiable(workoutSets),
      workoutGroups: List<BackupWorkoutGroup>.unmodifiable(workoutGroups),
      workoutGroupAssignments: List<BackupWorkoutGroupAssignment>.unmodifiable(
        assignments,
      ),
      catalogImports: List<BackupCatalogImport>.unmodifiable(catalogImports),
      settingsProfile: settingsProfile,
      onboardingStatus: onboardingStatus,
    );
  }

  final int exportVersion;
  final int schemaVersion;
  final String appId;
  final DateTime exportedAt;
  final List<BackupWorkoutSet> workoutSets;
  final List<BackupWorkoutGroup> workoutGroups;
  final List<BackupWorkoutGroupAssignment> workoutGroupAssignments;
  final BackupSettingsProfile? settingsProfile;
  final BackupOnboardingStatus? onboardingStatus;
  final List<BackupCatalogImport> catalogImports;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'exportVersion': exportVersion,
      'schemaVersion': schemaVersion,
      'appId': appId,
      'exportedAt': exportedAt.toUtc().toIso8601String(),
      'workoutSets': workoutSets.map((set) => set.toJson()).toList(),
      'workoutGroups': workoutGroups.map((group) => group.toJson()).toList(),
      'workoutGroupAssignments': workoutGroupAssignments
          .map((assignment) => assignment.toJson())
          .toList(),
      'settingsProfile': settingsProfile?.toJson(),
      'onboardingStatus': onboardingStatus?.toJson(),
      'catalogImports': catalogImports.map((row) => row.toJson()).toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static RepForgeBackup parseJsonString(String source) {
    Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (error) {
      throw BackupValidationException(<BackupValidationError>[
        BackupValidationError(field: 'json', message: error.message),
      ]);
    }

    if (decoded is! Map<String, Object?>) {
      throw BackupValidationException(const <BackupValidationError>[
        BackupValidationError(
          field: 'json',
          message: 'Backup root must be a JSON object.',
        ),
      ]);
    }

    return RepForgeBackup.fromJson(decoded);
  }

  static BackupValidationResult validateJsonString(String source) {
    try {
      RepForgeBackup.parseJsonString(source);
      return BackupValidationResult.valid();
    } on BackupValidationException catch (error) {
      return BackupValidationResult.invalid(error.errors);
    }
  }
}

final class BackupExerciseRef {
  const BackupExerciseRef({
    required this.source,
    required this.id,
    required this.displayNameSnapshot,
    this.catalogVersionSnapshot,
  });

  factory BackupExerciseRef.fromJson(
    Object? value,
    String field,
    List<BackupValidationError> errors,
  ) {
    if (value is! Map<String, Object?>) {
      errors.add(
        BackupValidationError(
          field: field,
          message: 'Exercise reference must be an object.',
        ),
      );
      return const BackupExerciseRef(
        source: 'official',
        id: 'invalid',
        displayNameSnapshot: 'Invalid',
      );
    }

    final source = _requiredString(value, '$field.source', errors);
    final id = _requiredString(value, '$field.id', errors);
    final displayName = _requiredString(
      value,
      '$field.displayNameSnapshot',
      errors,
    );
    final catalogVersion = _optionalString(
      value,
      '$field.catalogVersionSnapshot',
      errors,
    );

    if (source != null && source != 'official' && source != 'custom') {
      errors.add(
        BackupValidationError(
          field: '$field.source',
          message: 'Unsupported exercise source.',
        ),
      );
    }
    if (source == 'custom' && catalogVersion != null) {
      errors.add(
        BackupValidationError(
          field: '$field.catalogVersionSnapshot',
          message: 'Custom exercises must not contain catalog snapshots.',
        ),
      );
    }

    return BackupExerciseRef(
      source: source ?? 'official',
      id: id ?? 'invalid',
      displayNameSnapshot: displayName ?? 'Invalid',
      catalogVersionSnapshot: catalogVersion,
    );
  }

  final String source;
  final String id;
  final String displayNameSnapshot;
  final String? catalogVersionSnapshot;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'source': source,
      'id': id,
      'displayNameSnapshot': displayNameSnapshot,
      'catalogVersionSnapshot': catalogVersionSnapshot,
    };
  }
}

final class BackupWorkoutSet {
  const BackupWorkoutSet({
    required this.id,
    required this.exerciseRef,
    required this.repetitions,
    required this.loadKg,
    required this.performedAt,
    this.workoutSessionId,
    this.comment,
    this.label,
  });

  factory BackupWorkoutSet.fromJson(
    Object? value,
    String field,
    List<BackupValidationError> errors,
  ) {
    if (value is! Map<String, Object?>) {
      errors.add(
        BackupValidationError(
          field: field,
          message: 'Workout set must be an object.',
        ),
      );
      return BackupWorkoutSet(
        id: 'invalid',
        exerciseRef: const BackupExerciseRef(
          source: 'official',
          id: 'invalid',
          displayNameSnapshot: 'Invalid',
        ),
        repetitions: 1,
        loadKg: 0,
        performedAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );
    }

    final id = _requiredString(value, '$field.id', errors);
    final exerciseRef = BackupExerciseRef.fromJson(
      value['exerciseRef'],
      '$field.exerciseRef',
      errors,
    );
    final workoutSessionId = _optionalString(
      value,
      '$field.workoutSessionId',
      errors,
    );
    final repetitions = _requiredInt(value, '$field.repetitions', errors);
    final loadKg = _requiredNum(value, '$field.loadKg', errors);
    final performedAt = _requiredDateTime(value, '$field.performedAt', errors);
    final comment = _optionalString(value, '$field.comment', errors);
    final label = _optionalString(value, '$field.label', errors);

    if (repetitions != null && repetitions <= 0) {
      errors.add(
        BackupValidationError(
          field: '$field.repetitions',
          message: 'Repetitions must be greater than zero.',
        ),
      );
    }
    if (loadKg != null && (loadKg < 0 || !loadKg.isFinite)) {
      errors.add(
        BackupValidationError(
          field: '$field.loadKg',
          message: 'Load must be finite and non-negative.',
        ),
      );
    }
    if (label != null && !_allowedSetLabels.contains(label)) {
      errors.add(
        BackupValidationError(
          field: '$field.label',
          message: 'Unsupported workout set label.',
        ),
      );
    }

    return BackupWorkoutSet(
      id: id ?? 'invalid',
      exerciseRef: exerciseRef,
      workoutSessionId: workoutSessionId,
      repetitions: repetitions ?? 1,
      loadKg: loadKg?.toDouble() ?? 0,
      performedAt: performedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      comment: comment,
      label: label,
    );
  }

  final String id;
  final BackupExerciseRef exerciseRef;
  final String? workoutSessionId;
  final int repetitions;
  final double loadKg;
  final DateTime performedAt;
  final String? comment;
  final String? label;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'exerciseRef': exerciseRef.toJson(),
      'workoutSessionId': workoutSessionId,
      'repetitions': repetitions,
      'loadKg': loadKg,
      'performedAt': performedAt.toUtc().toIso8601String(),
      'comment': comment,
      'label': label,
    };
  }
}

final class BackupWorkoutGroup {
  const BackupWorkoutGroup({
    required this.id,
    required this.name,
    required this.sortOrder,
    this.archivedAt,
  });

  factory BackupWorkoutGroup.fromJson(
    Object? value,
    String field,
    List<BackupValidationError> errors,
  ) {
    if (value is! Map<String, Object?>) {
      errors.add(
        BackupValidationError(
          field: field,
          message: 'Workout group must be an object.',
        ),
      );
      return const BackupWorkoutGroup(
        id: 'invalid',
        name: 'Invalid',
        sortOrder: 0,
      );
    }

    final id = _requiredString(value, '$field.id', errors);
    final name = _requiredString(value, '$field.name', errors);
    final sortOrder = _requiredInt(value, '$field.sortOrder', errors);
    final archivedAt = _optionalDateTime(value, '$field.archivedAt', errors);
    if (sortOrder != null && sortOrder < 0) {
      errors.add(
        BackupValidationError(
          field: '$field.sortOrder',
          message: 'Sort order must be non-negative.',
        ),
      );
    }

    return BackupWorkoutGroup(
      id: id ?? 'invalid',
      name: name ?? 'Invalid',
      sortOrder: sortOrder ?? 0,
      archivedAt: archivedAt,
    );
  }

  final String id;
  final String name;
  final int sortOrder;
  final DateTime? archivedAt;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'name': name,
      'sortOrder': sortOrder,
      'archivedAt': archivedAt?.toUtc().toIso8601String(),
    };
  }
}

final class BackupWorkoutGroupAssignment {
  const BackupWorkoutGroupAssignment({
    required this.id,
    required this.workoutGroupId,
    required this.exerciseRef,
    required this.position,
  });

  factory BackupWorkoutGroupAssignment.fromJson(
    Object? value,
    String field,
    List<BackupValidationError> errors,
  ) {
    if (value is! Map<String, Object?>) {
      errors.add(
        BackupValidationError(
          field: field,
          message: 'Workout group assignment must be an object.',
        ),
      );
      return BackupWorkoutGroupAssignment(
        id: 'invalid',
        workoutGroupId: 'invalid',
        exerciseRef: const BackupExerciseRef(
          source: 'official',
          id: 'invalid',
          displayNameSnapshot: 'Invalid',
        ),
        position: 0,
      );
    }

    final id = _requiredString(value, '$field.id', errors);
    final groupId = _requiredString(value, '$field.workoutGroupId', errors);
    final exerciseRef = BackupExerciseRef.fromJson(
      value['exerciseRef'],
      '$field.exerciseRef',
      errors,
    );
    final position = _requiredInt(value, '$field.position', errors);
    if (position != null && position < 0) {
      errors.add(
        BackupValidationError(
          field: '$field.position',
          message: 'Position must be non-negative.',
        ),
      );
    }

    return BackupWorkoutGroupAssignment(
      id: id ?? 'invalid',
      workoutGroupId: groupId ?? 'invalid',
      exerciseRef: exerciseRef,
      position: position ?? 0,
    );
  }

  final String id;
  final String workoutGroupId;
  final BackupExerciseRef exerciseRef;
  final int position;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'workoutGroupId': workoutGroupId,
      'exerciseRef': exerciseRef.toJson(),
      'position': position,
    };
  }
}

final class BackupSettingsProfile {
  const BackupSettingsProfile({
    required this.languageOverride,
    required this.unitPreference,
    required this.themePreference,
    required this.defaultRestSeconds,
    required this.focusProfile,
    required this.trainingDaysPerWeek,
    required this.sessionDurationMinutes,
    required this.equipmentInventory,
    this.displayName,
  });

  factory BackupSettingsProfile.fromJson(
    Object? value,
    String field,
    List<BackupValidationError> errors,
  ) {
    if (value is! Map<String, Object?>) {
      errors.add(
        BackupValidationError(
          field: field,
          message: 'Settings profile must be an object.',
        ),
      );
      return const BackupSettingsProfile(
        languageOverride: 'system',
        unitPreference: 'metric',
        themePreference: 'system',
        defaultRestSeconds: 90,
        focusProfile: 'balanced',
        trainingDaysPerWeek: 3,
        sessionDurationMinutes: 45,
        equipmentInventory: <String>['bodyweight'],
      );
    }

    final language = _requiredString(value, '$field.languageOverride', errors);
    final unit = _requiredString(value, '$field.unitPreference', errors);
    final theme = _requiredString(value, '$field.themePreference', errors);
    final restSeconds = _requiredInt(
      value,
      '$field.defaultRestSeconds',
      errors,
    );
    final displayName = _optionalString(value, '$field.displayName', errors);
    final focus = _requiredString(value, '$field.focusProfile', errors);
    final days = _requiredInt(value, '$field.trainingDaysPerWeek', errors);
    final duration = _requiredInt(
      value,
      '$field.sessionDurationMinutes',
      errors,
    );
    final equipment = _requiredStringList(
      value,
      '$field.equipmentInventory',
      errors,
    );

    _validateAllowed(
      field,
      'languageOverride',
      language,
      _allowedLanguages,
      errors,
    );
    _validateAllowed(field, 'unitPreference', unit, _allowedUnits, errors);
    _validateAllowed(field, 'themePreference', theme, _allowedThemes, errors);
    _validateAllowed(
      field,
      'focusProfile',
      focus,
      _allowedFocusProfiles,
      errors,
    );
    if (restSeconds != null && (restSeconds <= 0 || restSeconds > 1800)) {
      errors.add(
        BackupValidationError(
          field: '$field.defaultRestSeconds',
          message: 'Default rest time must be between 1 and 1800 seconds.',
        ),
      );
    }
    if (days != null && (days < 1 || days > 7)) {
      errors.add(
        BackupValidationError(
          field: '$field.trainingDaysPerWeek',
          message: 'Training frequency must be between 1 and 7 days.',
        ),
      );
    }
    if (duration != null && !_allowedSessionDurations.contains(duration)) {
      errors.add(
        BackupValidationError(
          field: '$field.sessionDurationMinutes',
          message: 'Unsupported session duration.',
        ),
      );
    }
    if (displayName != null && displayName.length > 80) {
      errors.add(
        BackupValidationError(
          field: '$field.displayName',
          message: 'Display name must be 80 characters or fewer.',
        ),
      );
    }
    if (equipment.isEmpty) {
      errors.add(
        BackupValidationError(
          field: '$field.equipmentInventory',
          message: 'Equipment inventory must not be empty.',
        ),
      );
    }
    _rejectDuplicates(
      field: '$field.equipmentInventory',
      values: equipment,
      errors: errors,
    );
    for (final item in equipment) {
      if (!_allowedEquipment.contains(item)) {
        errors.add(
          BackupValidationError(
            field: '$field.equipmentInventory',
            message: 'Unsupported equipment option.',
          ),
        );
      }
    }

    return BackupSettingsProfile(
      languageOverride: language ?? 'system',
      unitPreference: unit ?? 'metric',
      themePreference: theme ?? 'system',
      defaultRestSeconds: restSeconds ?? 90,
      displayName: displayName,
      focusProfile: focus ?? 'balanced',
      trainingDaysPerWeek: days ?? 3,
      sessionDurationMinutes: duration ?? 45,
      equipmentInventory: List<String>.unmodifiable(equipment),
    );
  }

  final String languageOverride;
  final String unitPreference;
  final String themePreference;
  final int defaultRestSeconds;
  final String? displayName;
  final String focusProfile;
  final int trainingDaysPerWeek;
  final int sessionDurationMinutes;
  final List<String> equipmentInventory;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'languageOverride': languageOverride,
      'unitPreference': unitPreference,
      'themePreference': themePreference,
      'defaultRestSeconds': defaultRestSeconds,
      'displayName': displayName,
      'focusProfile': focusProfile,
      'trainingDaysPerWeek': trainingDaysPerWeek,
      'sessionDurationMinutes': sessionDurationMinutes,
      'equipmentInventory': equipmentInventory,
    };
  }
}

final class BackupOnboardingStatus {
  const BackupOnboardingStatus({required this.completion, this.updatedAt});

  factory BackupOnboardingStatus.fromJson(
    Object? value,
    String field,
    List<BackupValidationError> errors,
  ) {
    if (value is! Map<String, Object?>) {
      errors.add(
        BackupValidationError(
          field: field,
          message: 'Onboarding status must be an object.',
        ),
      );
      return const BackupOnboardingStatus(completion: 'notStarted');
    }

    final completion = _requiredString(value, '$field.completion', errors);
    final updatedAt = _optionalDateTime(value, '$field.updatedAt', errors);
    _validateAllowed(
      field,
      'completion',
      completion,
      _allowedOnboardingCompletions,
      errors,
    );

    return BackupOnboardingStatus(
      completion: completion ?? 'notStarted',
      updatedAt: updatedAt,
    );
  }

  final String completion;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'completion': completion,
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
    };
  }
}

final class BackupCatalogImport {
  const BackupCatalogImport({
    required this.catalogVersion,
    required this.schemaVersion,
    required this.importedAt,
  });

  factory BackupCatalogImport.fromJson(
    Object? value,
    String field,
    List<BackupValidationError> errors,
  ) {
    if (value is! Map<String, Object?>) {
      errors.add(
        BackupValidationError(
          field: field,
          message: 'Catalog import metadata must be an object.',
        ),
      );
      return BackupCatalogImport(
        catalogVersion: 'invalid',
        schemaVersion: 1,
        importedAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );
    }

    final catalogVersion = _requiredString(
      value,
      '$field.catalogVersion',
      errors,
    );
    final schemaVersion = _requiredInt(value, '$field.schemaVersion', errors);
    final importedAt = _requiredDateTime(value, '$field.importedAt', errors);
    if (schemaVersion != null && schemaVersion <= 0) {
      errors.add(
        BackupValidationError(
          field: '$field.schemaVersion',
          message: 'Catalog schema version must be positive.',
        ),
      );
    }

    return BackupCatalogImport(
      catalogVersion: catalogVersion ?? 'invalid',
      schemaVersion: schemaVersion ?? 1,
      importedAt: importedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  final String catalogVersion;
  final int schemaVersion;
  final DateTime importedAt;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'catalogVersion': catalogVersion,
      'schemaVersion': schemaVersion,
      'importedAt': importedAt.toUtc().toIso8601String(),
    };
  }
}

const Set<String> _allowedSetLabels = <String>{
  'none',
  'warmup',
  'failure',
  'personalRecord',
  'dropSet',
  'pain',
};

const Set<String> _allowedLanguages = <String>{'system', 'en', 'de'};
const Set<String> _allowedUnits = <String>{'metric', 'imperial'};
const Set<String> _allowedThemes = <String>{'system', 'dark', 'light'};
const Set<String> _allowedFocusProfiles = <String>{
  'balanced',
  'upperBodyFocus',
  'lowerBodyGluteFocus',
  'armsChestFocus',
  'strengthBasics',
  'timeEfficient',
  'beginnerFoundation',
  'custom',
};
const Set<int> _allowedSessionDurations = <int>{15, 25, 35, 45, 60, 75};
const Set<String> _allowedEquipment = <String>{
  'bodyweight',
  'barbell',
  'dumbbell',
  'cable',
  'machine',
  'smithMachine',
  'pullUpBar',
  'bench',
  'legPress',
};
const Set<String> _allowedOnboardingCompletions = <String>{
  'notStarted',
  'skipped',
  'completed',
};

void _validateAllowed(
  String parentField,
  String childField,
  String? value,
  Set<String> allowed,
  List<BackupValidationError> errors,
) {
  if (value != null && !allowed.contains(value)) {
    errors.add(
      BackupValidationError(
        field: '$parentField.$childField',
        message: 'Unsupported value.',
      ),
    );
  }
}

String? _requiredString(
  Map<String, Object?> json,
  String field,
  List<BackupValidationError> errors,
) {
  final key = field.split('.').last;
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  errors.add(
    BackupValidationError(field: field, message: 'Required string is missing.'),
  );
  return null;
}

String? _optionalString(
  Map<String, Object?> json,
  String field,
  List<BackupValidationError> errors,
) {
  final key = field.split('.').last;
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  errors.add(
    BackupValidationError(
      field: field,
      message: 'Optional string must be non-empty when present.',
    ),
  );
  return null;
}

int? _requiredInt(
  Map<String, Object?> json,
  String field,
  List<BackupValidationError> errors,
) {
  final key = field.split('.').last;
  final value = json[key];
  if (value is int) {
    return value;
  }
  errors.add(
    BackupValidationError(
      field: field,
      message: 'Required integer is missing.',
    ),
  );
  return null;
}

num? _requiredNum(
  Map<String, Object?> json,
  String field,
  List<BackupValidationError> errors,
) {
  final key = field.split('.').last;
  final value = json[key];
  if (value is num) {
    return value;
  }
  errors.add(
    BackupValidationError(field: field, message: 'Required number is missing.'),
  );
  return null;
}

DateTime? _requiredDateTime(
  Map<String, Object?> json,
  String field,
  List<BackupValidationError> errors,
) {
  final key = field.split('.').last;
  final value = json[key];
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed.toUtc();
    }
  }
  errors.add(
    BackupValidationError(
      field: field,
      message: 'Required ISO-8601 date/time is missing.',
    ),
  );
  return null;
}

DateTime? _optionalDateTime(
  Map<String, Object?> json,
  String field,
  List<BackupValidationError> errors,
) {
  final key = field.split('.').last;
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed.toUtc();
    }
  }
  errors.add(
    BackupValidationError(
      field: field,
      message: 'Optional date/time must be ISO-8601 when present.',
    ),
  );
  return null;
}

List<T> _requiredList<T>(
  Map<String, Object?> json,
  String field,
  List<BackupValidationError> errors,
  T Function(Object? value, String field) map,
) {
  final value = json[field];
  if (value is! List<Object?>) {
    errors.add(
      BackupValidationError(field: field, message: 'Required list is missing.'),
    );
    return <T>[];
  }

  return <T>[
    for (var index = 0; index < value.length; index++)
      map(value[index], '$field[$index]'),
  ];
}

List<T> _optionalList<T>(
  Map<String, Object?> json,
  String field,
  List<BackupValidationError> errors,
  T Function(Object? value, String field) map,
) {
  final value = json[field];
  if (value == null) {
    return <T>[];
  }
  if (value is! List<Object?>) {
    errors.add(
      BackupValidationError(field: field, message: 'Optional list is invalid.'),
    );
    return <T>[];
  }

  return <T>[
    for (var index = 0; index < value.length; index++)
      map(value[index], '$field[$index]'),
  ];
}

T? _optionalObject<T>(
  Map<String, Object?> json,
  String field,
  List<BackupValidationError> errors,
  T Function(Object? value, String field) map,
) {
  if (!json.containsKey(field) || json[field] == null) {
    return null;
  }
  return map(json[field], field);
}

List<String> _requiredStringList(
  Map<String, Object?> json,
  String field,
  List<BackupValidationError> errors,
) {
  final key = field.split('.').last;
  final value = json[key];
  if (value is! List<Object?>) {
    errors.add(
      BackupValidationError(field: field, message: 'Required list is missing.'),
    );
    return <String>[];
  }

  final strings = <String>[];
  for (var index = 0; index < value.length; index++) {
    final item = value[index];
    if (item is String && item.trim().isNotEmpty) {
      strings.add(item);
    } else {
      errors.add(
        BackupValidationError(
          field: '$field[$index]',
          message: 'Equipment item must be a non-empty string.',
        ),
      );
    }
  }
  return strings;
}

void _rejectDuplicates({
  required String field,
  required Iterable<String> values,
  required List<BackupValidationError> errors,
}) {
  final seen = <String>{};
  for (final value in values) {
    if (!seen.add(value)) {
      errors.add(
        BackupValidationError(field: field, message: 'Duplicate stable id.'),
      );
    }
  }
}
