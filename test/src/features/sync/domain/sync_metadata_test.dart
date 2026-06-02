import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/auth/application/auth_application.dart';
import 'package:repforge/src/features/auth/domain/auth_domain.dart';
import 'package:repforge/src/features/cloud/domain/cloud_domain.dart';
import 'package:repforge/src/features/sync/domain/sync_domain.dart';

void main() {
  group('sync metadata boundary', () {
    final createdAt = DateTime.utc(2026, 6, 2, 10);
    final updatedAt = DateTime.utc(2026, 6, 2, 11);
    final deletedAt = DateTime.utc(2026, 6, 2, 12);

    test('default metadata is localOnly and non-blocking', () {
      final metadata = SyncMetadata.localOnly(
        entityType: SyncEntityType.workoutSet,
        entityId: SyncEntityId('set-1'),
        createdAt: createdAt,
      );

      expect(metadata.syncState, SyncState.localOnly);
      expect(metadata.remoteId, isNull);
      expect(metadata.deletedAt, isNull);
      expect(metadata.localVersion, SyncVersion.initial);
      expect(metadata.requiresRemoteTransport, isFalse);
    });

    test('local MVP features do not require sync metadata', () {
      for (final entityType in SyncEntityType.localMvpEntityTypes) {
        expect(entityType.requiresSyncForLocalUse, isFalse);
      }
    });

    test('official catalog entities are not cloud-synced user data', () {
      expect(SyncEntityType.officialCatalog.isUserDataSyncCandidate, isFalse);
      expect(SyncEntityType.officialExercise.isUserDataSyncCandidate, isFalse);
      expect(SyncEntityType.officialCatalog.requiresSyncForLocalUse, isFalse);
    });

    test(
      'custom user data metadata can be represented without remote calls',
      () {
        final metadata = SyncMetadata(
          entityType: SyncEntityType.customExercise,
          entityId: SyncEntityId('custom-pushup'),
          createdAt: createdAt,
          updatedAt: updatedAt,
          localVersion: SyncVersion(2),
          syncState: SyncState.pendingUpload,
        );

        expect(metadata.entityType.isUserDataSyncCandidate, isTrue);
        expect(metadata.remoteId, isNull);
        expect(metadata.requiresRemoteTransport, isTrue);
      },
    );

    test('tombstone behavior is deterministic', () {
      final metadata = SyncMetadata.localOnly(
        entityType: SyncEntityType.workoutSet,
        entityId: SyncEntityId('set-1'),
        createdAt: createdAt,
      );

      final tombstone = metadata.markDeleted(deletedAt: deletedAt);

      expect(tombstone.syncState, SyncState.tombstoned);
      expect(tombstone.deletedAt, deletedAt);
      expect(tombstone.updatedAt, deletedAt);
      expect(tombstone.localVersion, SyncVersion(2));
      expect(SyncTombstone.fromMetadata(tombstone).deletedAt, deletedAt);
    });

    test('version and conflict policy are deterministic', () {
      final local = SyncMetadata(
        entityType: SyncEntityType.workoutSet,
        entityId: SyncEntityId('set-1'),
        createdAt: createdAt,
        updatedAt: updatedAt,
        localVersion: SyncVersion(3),
        remoteId: 'remote-set-1',
        syncState: SyncState.synced,
      );
      final incoming = local.copyWith(
        updatedAt: updatedAt.add(const Duration(minutes: 1)),
        localVersion: SyncVersion(2),
      );

      final resolution = const SyncConflictPolicy().resolve(
        localMetadata: local,
        incomingMetadata: incoming,
      );

      expect(resolution.kind, SyncConflictResolutionKind.useLocal);
      expect(resolution.resolvedMetadata, local);
    });

    test('equal versions with different timestamps require manual review', () {
      final local = SyncMetadata(
        entityType: SyncEntityType.settingsProfile,
        entityId: SyncEntityId('local-settings'),
        createdAt: createdAt,
        updatedAt: updatedAt,
        localVersion: SyncVersion(2),
        remoteId: 'settings-remote',
        syncState: SyncState.synced,
      );
      final incoming = local.copyWith(
        updatedAt: updatedAt.add(const Duration(minutes: 5)),
      );

      final resolution = const SyncConflictPolicy().resolve(
        localMetadata: local,
        incomingMetadata: incoming,
      );

      expect(resolution.kind, SyncConflictResolutionKind.manualReview);
      expect(resolution.resolvedMetadata, isNull);
    });

    test('auth is not required for local-only mode', () async {
      final authStatus = await GetAuthStatus(
        LocalOnlyAuthGateway(now: () => createdAt),
      )();
      final metadata = SyncMetadata.localOnly(
        entityType: SyncEntityType.settingsProfile,
        entityId: SyncEntityId('settings'),
        createdAt: createdAt,
      );

      expect(authStatus.session.state, AuthSessionState.localOnly);
      expect(metadata.requiresAccount, isFalse);
    });

    test('disabled Firebase does not block local-only sync mode', () {
      const firebaseConfiguration = FirebaseIntegrationConfiguration.disabled();
      final metadata = SyncMetadata.localOnly(
        entityType: SyncEntityType.workoutGroup,
        entityId: SyncEntityId('push-day'),
        createdAt: createdAt,
      );

      expect(firebaseConfiguration.shouldInitialize, isFalse);
      expect(metadata.syncState, SyncState.localOnly);
      expect(metadata.requiresRemoteTransport, isFalse);
    });
  });

  test('feature domain imports stay free of platform and backend APIs', () {
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
