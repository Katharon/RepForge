enum AppRoute {
  today(name: 'today', path: '/today'),
  groups(name: 'groups', path: '/groups'),
  exercises(name: 'exercises', path: '/exercises'),
  analytics(name: 'analytics', path: '/analytics'),
  settings(name: 'settings', path: '/settings');

  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;

  static const initial = today;
}
