import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    final db = await database;
    await _seedIfEmpty(db);
  }

  Future<Database> _initDatabase() async {
    final path = kIsWeb
        ? 'builderbridge.db'
        : join(await getDatabasesPath(), 'builderbridge.db');
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
          await db.rawQuery('SELECT COUNT(*) FROM projects')) ??
        0;
    if (count > 0) return;

    try {
      final jsonStr = await rootBundle.loadString('assets/seed/seed_data.json');
      await SeedLoader(db).load(jsonStr);
    } catch (_) {
      // Seed file not present — skip silently
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
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    const ignore = ConflictAlgorithm.ignore;

    await db.transaction((txn) async {
      for (final p in (data['projects'] as List<dynamic>)) {
        await txn.insert('projects', Map<String, dynamic>.from(p as Map), conflictAlgorithm: ignore);
      }
      for (final t in (data['towers'] as List<dynamic>)) {
        await txn.insert('towers', Map<String, dynamic>.from(t as Map), conflictAlgorithm: ignore);
      }
      for (final u in (data['units'] as List<dynamic>)) {
        await txn.insert('units', Map<String, dynamic>.from(u as Map), conflictAlgorithm: ignore);
      }
      for (final u in (data['users'] as List<dynamic>? ?? [])) {
        await txn.insert('users', Map<String, dynamic>.from(u as Map), conflictAlgorithm: ignore);
      }
      for (final b in (data['bookings'] as List<dynamic>? ?? [])) {
        await txn.insert('bookings', Map<String, dynamic>.from(b as Map), conflictAlgorithm: ignore);
      }
      for (final m in (data['payment_milestones'] as List<dynamic>? ?? [])) {
        await txn.insert('payment_milestones', Map<String, dynamic>.from(m as Map), conflictAlgorithm: ignore);
      }
      for (final d in (data['documents'] as List<dynamic>? ?? [])) {
        await txn.insert('documents', Map<String, dynamic>.from(d as Map), conflictAlgorithm: ignore);
      }
      for (final t in (data['tickets'] as List<dynamic>? ?? [])) {
        await txn.insert('tickets', Map<String, dynamic>.from(t as Map), conflictAlgorithm: ignore);
      }
      for (final c in (data['ticket_comments'] as List<dynamic>? ?? [])) {
        await txn.insert('ticket_comments', Map<String, dynamic>.from(c as Map), conflictAlgorithm: ignore);
      }
      for (final n in (data['notifications'] as List<dynamic>? ?? [])) {
        await txn.insert('notifications', Map<String, dynamic>.from(n as Map), conflictAlgorithm: ignore);
      }
    });
  }
}
