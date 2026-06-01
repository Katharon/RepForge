import 'dart:convert';

final class BackupPrivacyWarning {
  const BackupPrivacyWarning({required this.title, required this.message});

  static const BackupPrivacyWarning localJsonExport = BackupPrivacyWarning(
    title: 'Backup contains sensitive local data',
    message:
        'RepForge backup JSON can include training history, comments, profile '
        'settings, and equipment. Keep the file somewhere you trust.',
  );

  final String title;
  final String message;
}

final class BackupLogRedactor {
  const BackupLogRedactor();

  static const String redacted = '[redacted]';
  static const String invalidJson = '[redacted invalid json]';

  static const Set<String> _sensitiveTopLevelFields = <String>{
    'workoutSets',
    'workoutGroups',
    'workoutGroupAssignments',
    'settingsProfile',
    'onboardingStatus',
  };

  String redactJsonString(String source) {
    try {
      final decoded = jsonDecode(source);
      return jsonEncode(redactDecoded(decoded));
    } on FormatException {
      return jsonEncode(<String, Object?>{'backup': invalidJson});
    }
  }

  Object? redactDecoded(Object? value) {
    if (value is Map<String, Object?>) {
      return <String, Object?>{
        for (final entry in value.entries)
          entry.key: _sensitiveTopLevelFields.contains(entry.key)
              ? redacted
              : entry.value,
      };
    }
    return redacted;
  }
}
