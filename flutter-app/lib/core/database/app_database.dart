import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:builder_bridge/core/database/migrations/migration_v1.dart';
import 'package:builder_bridge/core/database/migrations/migration_v2.dart';
import 'package:builder_bridge/core/database/migrations/migration_v3.dart';

part 'app_database.g.dart';

@DriftDatabase()
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          for (final sql in MigrationV1.statements) {
            await customStatement(sql);
          }
          for (final sql in MigrationV2.statements) {
            await customStatement(sql);
          }
          for (final sql in MigrationV3.statements) {
            await customStatement(sql);
          }
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            for (final sql in MigrationV2.statements) {
              await customStatement(sql);
            }
          }
          if (from < 3) {
            for (final sql in MigrationV3.statements) {
              await customStatement(sql);
            }
          }
        },
      );
}

QueryExecutor _openConnection() => driftDatabase(
      name: 'builderbridge',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
