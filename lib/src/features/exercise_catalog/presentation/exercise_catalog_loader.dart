import 'package:flutter/widgets.dart';

import '../domain/exercise_catalog_domain.dart';

typedef EnsureOfficialCatalogImported = Future<void> Function();

abstract interface class ExerciseCatalogListLoader {
  Future<ExerciseCatalogListViewModel> load({
    String? searchText,
    Locale? locale,
  });
}

final class RepositoryExerciseCatalogListLoader
    implements ExerciseCatalogListLoader {
  const RepositoryExerciseCatalogListLoader({
    required this.repository,
    this.ensureCatalogImported,
    this.limit = 50,
  });

  final ExerciseCatalogRepository repository;
  final EnsureOfficialCatalogImported? ensureCatalogImported;
  final int limit;

  @override
  Future<ExerciseCatalogListViewModel> load({
    String? searchText,
    Locale? locale,
  }) async {
    await ensureCatalogImported?.call();
    final page = await repository.findOfficialExercises(
      ExerciseCatalogQuery(limit: limit, offset: 0, searchText: searchText),
    );

    return ExerciseCatalogListViewModel(
      exercises: page.items
          .map(
            (exercise) => ExerciseListItemViewModel.fromExercise(
              exercise,
              locale: locale,
            ),
          )
          .toList(growable: false),
      totalCount: page.totalCount,
      hasMore: page.hasMore,
    );
  }
}

final class ExerciseCatalogListViewModel {
  const ExerciseCatalogListViewModel({
    required this.exercises,
    required this.totalCount,
    required this.hasMore,
  });

  final List<ExerciseListItemViewModel> exercises;
  final int totalCount;
  final bool hasMore;
}

final class ExerciseListItemViewModel {
  const ExerciseListItemViewModel({
    required this.id,
    required this.name,
    required this.equipment,
    required this.movementPatterns,
    required this.primaryMuscles,
    this.secondaryMuscles = const <String>[],
  });

  factory ExerciseListItemViewModel.fromExercise(
    OfficialExercise exercise, {
    Locale? locale,
  }) {
    return ExerciseListItemViewModel(
      id: exercise.id.value,
      name: locale?.languageCode == 'de'
          ? exercise.germanName
          : exercise.englishName,
      equipment: exercise.equipment
          .map((tag) => tag.value)
          .toList(growable: false),
      movementPatterns: exercise.movementPatterns
          .map((pattern) => pattern.value)
          .toList(growable: false),
      primaryMuscles: exercise.primaryMuscles
          .map((muscle) => muscle.value)
          .toList(growable: false),
      secondaryMuscles: exercise.secondaryMuscles
          .map((muscle) => muscle.value)
          .toList(growable: false),
    );
  }

  final String id;
  final String name;
  final List<String> equipment;
  final List<String> movementPatterns;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
}
