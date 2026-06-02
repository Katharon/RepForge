import 'package:drift/drift.dart';

import '../../../../shared/data/local/repforge_database.dart';
import '../../domain/recovery_domain.dart';
import '../mappers/readiness_check_in_mapper.dart';

final class DriftReadinessCheckInRepository
    implements ReadinessCheckInRepository {
  const DriftReadinessCheckInRepository(this._database);

  final RepForgeDatabase _database;

  @override
  Future<void> save(ReadinessCheckIn checkIn) async {
    await _database
        .into(_database.readinessCheckIns)
        .insertOnConflictUpdate(ReadinessCheckInMapper.toCompanion(checkIn));
  }

  @override
  Future<ReadinessCheckIn?> latest() async {
    final rows =
        await (_database.select(_database.readinessCheckIns)
              ..orderBy(_latestOrder)
              ..limit(1))
            .get();
    if (rows.isEmpty) {
      return null;
    }

    return ReadinessCheckInMapper.toDomain(rows.single);
  }

  @override
  Future<ReadinessCheckIn?> latestForRange({
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) async {
    final rows =
        await (_database.select(_database.readinessCheckIns)
              ..where(($ReadinessCheckInsTable table) {
                return table.checkedInAt.isBiggerOrEqualValue(
                      startInclusive.toUtc(),
                    ) &
                    table.checkedInAt.isSmallerThanValue(endExclusive.toUtc());
              })
              ..orderBy(_latestOrder)
              ..limit(1))
            .get();
    if (rows.isEmpty) {
      return null;
    }

    return ReadinessCheckInMapper.toDomain(rows.single);
  }
}

List<OrderingTerm Function($ReadinessCheckInsTable)> get _latestOrder {
  return <OrderingTerm Function($ReadinessCheckInsTable)>[
    ($ReadinessCheckInsTable table) => OrderingTerm.desc(table.checkedInAt),
    ($ReadinessCheckInsTable table) =>
        OrderingTerm.desc(table.readinessCheckInId),
  ];
}
