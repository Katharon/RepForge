import 'dart:io';

import 'catalog_patch_validator.dart';

void main(List<String> arguments) {
  final rootPath = arguments.isEmpty ? Directory.current.path : arguments.first;
  final validator = CatalogPatchValidator(rootDirectory: Directory(rootPath));
  final result = validator.validate();

  if (result.isValid) {
    stdout.writeln('Catalog validation passed.');
    return;
  }

  stderr.writeln(
    'Catalog validation failed with ${result.issues.length} issue(s):',
  );
  for (final issue in result.issues) {
    stderr.writeln('- $issue');
  }
  exitCode = 1;
}
