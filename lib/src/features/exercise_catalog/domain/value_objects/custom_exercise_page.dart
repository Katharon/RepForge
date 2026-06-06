import '../entities/custom_exercise.dart';

final class CustomExercisePage {
  const CustomExercisePage({
    required this.items,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  final List<CustomExercise> items;
  final int totalCount;
  final int limit;
  final int offset;

  bool get hasMore => offset + items.length < totalCount;
}
