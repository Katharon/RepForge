import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/backup/domain/backup_domain.dart';

void main() {
  test('JSON export contains exportVersion schemaVersion and exportedAt', () {
    final backup = RepForgeBackup.create(
      exportedAt: DateTime.utc(2026, 5, 28, 12),
    );

    final json = backup.toJson();

    expect(json['exportVersion'], currentBackupExportVersion);
    expect(json['schemaVersion'], currentBackupSchemaVersion);
    expect(json['appId'], repForgeBackupAppId);
    expect(json['exportedAt'], '2026-05-28T12:00:00.000Z');
  });

  test('missing version is rejected deterministically', () {
    final result = RepForgeBackup.validateJsonString(
      jsonEncode(_validBackupJson()..remove('exportVersion')),
    );

    expect(result.isValid, isFalse);
    expect(result.errors.single.field, 'exportVersion');
  });

  test('unsupported version is rejected deterministically', () {
    final result = RepForgeBackup.validateJsonString(
      jsonEncode(_validBackupJson()..['schemaVersion'] = 99),
    );

    expect(result.isValid, isFalse);
    expect(result.errors.single.field, 'schemaVersion');
  });

  test('invalid reps load label settings and equipment are rejected', () {
    final json = _validBackupJson();
    final workoutSets = json['workoutSets']! as List<Map<String, Object?>>;
    workoutSets.single
      ..['repetitions'] = 0
      ..['loadKg'] = -1
      ..['label'] = 'maximalVibes';
    final settings = json['settingsProfile']! as Map<String, Object?>;
    settings
      ..['languageOverride'] = 'fr'
      ..['displayName'] = 'x' * 81
      ..['sexGender'] = 'robot'
      ..['birthYear'] = 1800
      ..['bodyWeightKg'] = 501
      ..['heightCm'] = 0
      ..['trainingGoal'] = 'bulkOnly'
      ..['recoverySensitivity'] = 'fragile'
      ..['coachingStrictness'] = 'mean'
      ..['equipmentInventory'] = <String>['bodyweight', 'bodyweight', 'jetpack']
      ..['equipmentLoadConstraints'] = <Map<String, Object?>>[
        <String, Object?>{
          'equipment': 'dumbbell',
          'maxLoadKg': 20,
          'incrementKg': 25,
        },
      ];

    final result = RepForgeBackup.validateJsonString(jsonEncode(json));

    expect(result.isValid, isFalse);
    expect(
      result.errors.map((error) => error.field),
      containsAll(<String>[
        'workoutSets[0].repetitions',
        'workoutSets[0].loadKg',
        'workoutSets[0].label',
        'settingsProfile.languageOverride',
        'settingsProfile.displayName',
        'settingsProfile.sexGender',
        'settingsProfile.birthYear',
        'settingsProfile.bodyWeightKg',
        'settingsProfile.heightCm',
        'settingsProfile.trainingGoal',
        'settingsProfile.recoverySensitivity',
        'settingsProfile.coachingStrictness',
        'settingsProfile.equipmentInventory',
        'settingsProfile.equipmentLoadConstraints[0].incrementKg',
      ]),
    );
  });

  test('valid backup parses workout groups settings and onboarding status', () {
    final backup = RepForgeBackup.parseJsonString(
      jsonEncode(_validBackupJson()),
    );

    expect(backup.workoutSets.single.id, 'set-1');
    expect(backup.workoutGroups.single.id, 'group-1');
    expect(backup.workoutGroupAssignments.single.exerciseRef.id, 'bench');
    expect(backup.settingsProfile?.equipmentInventory, <String>[
      'bodyweight',
      'dumbbell',
      'rack',
    ]);
    expect(backup.settingsProfile?.sexGender, 'preferNotToSay');
    expect(backup.settingsProfile?.birthYear, 1991);
    expect(backup.settingsProfile?.bodyWeightKg, 82.5);
    expect(backup.settingsProfile?.heightCm, 181);
    expect(backup.settingsProfile?.trainingGoal, 'strength');
    expect(backup.settingsProfile?.recoverySensitivity, 'high');
    expect(backup.settingsProfile?.coachingStrictness, 'direct');
    expect(
      backup.settingsProfile?.equipmentLoadConstraints.single.maxLoadKg,
      40,
    );
    expect(backup.onboardingStatus?.completion, 'completed');
  });

  test('validation messages do not echo unsupported equipment values', () {
    final json = _validBackupJson();
    final settings = json['settingsProfile']! as Map<String, Object?>;
    settings['equipmentInventory'] = <String>[
      'bodyweight',
      'private-custom-machine',
    ];

    final result = RepForgeBackup.validateJsonString(jsonEncode(json));
    final equipmentError = result.errors.firstWhere(
      (error) =>
          error.field == 'settingsProfile.equipmentInventory' &&
          error.message == 'Unsupported equipment option.',
    );

    expect(result.isValid, isFalse);
    expect(equipmentError.message, isNot(contains('private')));
  });
}

Map<String, Object?> _validBackupJson() {
  return <String, Object?>{
    'exportVersion': currentBackupExportVersion,
    'schemaVersion': currentBackupSchemaVersion,
    'appId': repForgeBackupAppId,
    'exportedAt': '2026-05-28T12:00:00.000Z',
    'workoutSets': <Map<String, Object?>>[
      <String, Object?>{
        'id': 'set-1',
        'exerciseRef': <String, Object?>{
          'source': 'official',
          'id': 'bench',
          'displayNameSnapshot': 'Bench Press',
          'catalogVersionSnapshot': '2026.05.0',
        },
        'workoutSessionId': 'session-1',
        'repetitions': 5,
        'loadKg': 80,
        'performedAt': '2026-05-28T10:00:00.000Z',
        'comment': 'Top set',
        'label': 'personalRecord',
      },
    ],
    'workoutGroups': <Map<String, Object?>>[
      <String, Object?>{
        'id': 'group-1',
        'name': 'Push',
        'sortOrder': 0,
        'archivedAt': null,
      },
    ],
    'workoutGroupAssignments': <Map<String, Object?>>[
      <String, Object?>{
        'id': 'assignment-1',
        'workoutGroupId': 'group-1',
        'exerciseRef': <String, Object?>{
          'source': 'official',
          'id': 'bench',
          'displayNameSnapshot': 'Bench Press',
          'catalogVersionSnapshot': '2026.05.0',
        },
        'position': 0,
      },
    ],
    'settingsProfile': <String, Object?>{
      'languageOverride': 'system',
      'unitPreference': 'metric',
      'themePreference': 'dark',
      'defaultRestSeconds': 120,
      'displayName': 'Luki',
      'sexGender': 'preferNotToSay',
      'birthYear': 1991,
      'bodyWeightKg': 82.5,
      'heightCm': 181,
      'trainingGoal': 'strength',
      'focusProfile': 'strengthBasics',
      'trainingDaysPerWeek': 4,
      'sessionDurationMinutes': 60,
      'recoverySensitivity': 'high',
      'coachingStrictness': 'direct',
      'equipmentInventory': <String>['bodyweight', 'dumbbell', 'rack'],
      'equipmentLoadConstraints': <Map<String, Object?>>[
        <String, Object?>{
          'equipment': 'dumbbell',
          'maxLoadKg': 40,
          'incrementKg': 2,
        },
      ],
    },
    'onboardingStatus': <String, Object?>{
      'completion': 'completed',
      'updatedAt': '2026-05-28T11:00:00.000Z',
    },
    'catalogImports': <Map<String, Object?>>[
      <String, Object?>{
        'catalogVersion': '2026.05.0',
        'schemaVersion': 1,
        'importedAt': '2026-05-28T09:00:00.000Z',
      },
    ],
  };
}
