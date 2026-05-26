import 'dart:ui';

final class AppConfiguration {
  const AppConfiguration({this.locale});

  final Locale? locale;
}

final class AppDependencies {
  const AppDependencies({required this.configuration});

  final AppConfiguration configuration;
}

final class CompositionRoot {
  const CompositionRoot({this.configuration = const AppConfiguration()});

  final AppConfiguration configuration;

  AppDependencies compose() {
    return AppDependencies(configuration: configuration);
  }
}
