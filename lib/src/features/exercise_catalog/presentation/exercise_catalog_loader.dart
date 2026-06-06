import 'package:flutter/widgets.dart';

import '../../training_log/domain/training_log_domain.dart';
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
    this.customExerciseRepository,
    this.ensureCatalogImported,
    this.limit = 50,
  });

  final ExerciseCatalogRepository repository;
  final CustomExerciseRepository? customExerciseRepository;
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
    final customPage = await customExerciseRepository?.listCustomExercises(
      CustomExerciseQuery(limit: limit, offset: 0, searchText: searchText),
    );
    final customExercises = customPage?.items ?? const <CustomExercise>[];
    final items =
        [
          ...page.items.map(
            (exercise) => ExerciseListItemViewModel.fromExercise(
              exercise,
              locale: locale,
            ),
          ),
          ...customExercises.map(ExerciseListItemViewModel.fromCustomExercise),
        ]..sort((left, right) {
          return left.name.toLowerCase().compareTo(right.name.toLowerCase());
        });

    return ExerciseCatalogListViewModel(
      exercises: items,
      totalCount: page.totalCount + (customPage?.totalCount ?? 0),
      hasMore: page.hasMore || (customPage?.hasMore ?? false),
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
    this.source = ExerciseSource.official,
    this.catalogVersionSnapshot,
    this.notes,
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
      catalogVersionSnapshot: exercise.catalogVersion.value,
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

  factory ExerciseListItemViewModel.fromCustomExercise(
    CustomExercise exercise,
  ) {
    return ExerciseListItemViewModel(
      id: exercise.id.value,
      name: exercise.name,
      source: ExerciseSource.custom,
      notes: exercise.notes,
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

  factory ExerciseListItemViewModel.fromExerciseRef(ExerciseRef exerciseRef) {
    return ExerciseListItemViewModel(
      id: exerciseRef.id,
      name: exerciseRef.displayNameSnapshot,
      source: exerciseRef.source,
      catalogVersionSnapshot: exerciseRef.catalogVersionSnapshot,
      equipment: const <String>[],
      movementPatterns: const <String>[],
      primaryMuscles: const <String>[],
    );
  }

  final String id;
  final String name;
  final ExerciseSource source;
  final String? catalogVersionSnapshot;
  final String? notes;
  final List<String> equipment;
  final List<String> movementPatterns;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;

  bool get isCustom => source == ExerciseSource.custom;

  ExerciseRef toExerciseRef() {
    return switch (source) {
      ExerciseSource.official => ExerciseRef.official(
        id: OfficialExerciseId(id),
        displayNameSnapshot: name,
        catalogVersionSnapshot: catalogVersionSnapshot,
      ),
      ExerciseSource.custom => ExerciseRef.custom(
        id: CustomExerciseId(id),
        displayNameSnapshot: name,
      ),
    };
  }
}
