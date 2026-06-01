import '../entities/entitlement_snapshot.dart';

abstract interface class EntitlementSnapshotSource {
  Future<EntitlementSnapshot> loadSnapshot();
}
