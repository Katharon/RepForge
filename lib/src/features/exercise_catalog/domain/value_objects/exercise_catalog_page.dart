import '../entities/official_exercise.dart';

final class ExerciseCatalogPage {
  const ExerciseCatalogPage({
    required this.items,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  final List<OfficialExercise> items;
  final int totalCount;
  final int limit;
  final int offset;

  bool get hasMore {
    return offset + items.length < totalCount;
  }
}
