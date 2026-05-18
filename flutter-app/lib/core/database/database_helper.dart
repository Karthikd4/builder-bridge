import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:builder_bridge/core/database/migrations/migration_v1.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<void> init() async {
    await database;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'builderbridge.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final statement in MigrationV1.statements) {
      batch.execute(statement);
    }
    await batch.commit();
    await _seedIfEmpty(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future migrations added here by version increment only
  }

  Future<void> _seedIfEmpty(Database db) async {
    final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM projects')) ?? 0;
    if (count > 0) return;

    try {
      final jsonStr = await rootBundle.loadString('assets/seed/seed_data.json');
      await SeedLoader(db).load(jsonStr);
    } catch (_) {
      // Seed file not present yet — skip silently
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}

class SeedLoader {
  final Database db;
  SeedLoader(this.db);

  Future<void> load(String jsonStr) async {
    // Implemented in Sprint 2 when seed data is ready
  }
}
