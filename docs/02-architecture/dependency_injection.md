# Dependency Injection

## Decision

Use constructor injection everywhere. Use a small composition root for app startup. `get_it` is acceptable for centralized registration, while `flutter_bloc` providers scope BLoCs to widget subtrees.

## Why this approach

- Familiar to .NET-style dependency injection users.
- Keeps classes testable.
- Avoids hidden singletons in domain/application.
- Works well with BLoC and repository abstractions.

## Initial pattern

```dart
final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<Clock>(() => SystemClock());
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase.open());
  getIt.registerLazySingleton<ExerciseRepository>(
    () => DriftExerciseRepository(getIt<AppDatabase>()),
  );
  getIt.registerFactory(() => ExerciseListCubit(getIt<ListExercises>()));
}
```

## Rules

- No service locator access inside domain entities or use cases.
- Prefer constructor parameters over `getIt()` calls inside feature classes.
- Service locator access is limited to app bootstrap and provider factories.
- Tests may build dependencies manually or with a test DI container.
- Do not add code generation for DI until manual DI becomes painful.

## BLoC provisioning

Use `BlocProvider` or `MultiBlocProvider` near route/screen boundaries. `BlocProvider` can act as a UI-scoped DI mechanism for BLoCs, while repositories and use cases are created by the composition root.
