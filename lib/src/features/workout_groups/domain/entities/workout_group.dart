import '../value_objects/workout_group_ids.dart';
import '../value_objects/workout_group_values.dart';

final class WorkoutGroup {
  WorkoutGroup({
    required this.id,
    required this.name,
    required this.sortOrder,
    DateTime? archivedAt,
  }) : archivedAt = archivedAt?.toUtc();

  final WorkoutGroupId id;
  final WorkoutGroupName name;
  final WorkoutGroupSortOrder sortOrder;
  final DateTime? archivedAt;

  @override
  bool operator ==(Object other) {
    return other is WorkoutGroup &&
        other.id == id &&
        other.name == name &&
        other.sortOrder == sortOrder &&
        other.archivedAt == archivedAt;
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, archivedAt);
}
