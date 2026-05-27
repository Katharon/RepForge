import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'repforge_database.dart';

typedef QueryExecutorFactory = QueryExecutor Function();

final class RepForgeDatabaseFactory {
  const RepForgeDatabaseFactory({this.createExecutor});

  final QueryExecutorFactory? createExecutor;

  RepForgeDatabase createDatabase() {
    final executorFactory = createExecutor;

    return RepForgeDatabase(
      executorFactory == null ? _openLocalDatabase() : executorFactory(),
    );
  }

  QueryExecutor _openLocalDatabase() {
    return LazyDatabase(() async {
      final directory = await getApplicationDocumentsDirectory();
      final databaseFile = File('${directory.path}/repforge.sqlite');

      return NativeDatabase.createInBackground(databaseFile);
    });
  }
}
