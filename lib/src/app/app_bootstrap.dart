import 'package:flutter/widgets.dart';

import 'composition_root.dart';
import 'repforge_app.dart';

void bootstrapRepForgeApp({
  CompositionRoot compositionRoot = const CompositionRoot(),
}) {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = compositionRoot.compose();
  runApp(RepForgeApp(dependencies: dependencies));
}
