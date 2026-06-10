import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import 'package:builder_bridge/core/database/app_database.dart';

/// Thin facade over [AppDatabase] that exposes a sqflite-compatible surface
/// so repositories require minimal changes after the sqflite → Drift migration.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  late final AppDatabase _appDb;

  Future<void> init() async {
    _appDb = AppDatabase();
    // First access triggers onCreate / onUpgrade migration callbacks.
    await _appDb.customSelect('SELECT 1').get();
    await _seedIfEmpty();
  }

  // ── sqflite-compatible query surface ──────────────────────────────────────

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) {
    var sql = 'SELECT * FROM $table';
    if (where != null) sql += ' WHERE $where';
    if (orderBy != null) sql += ' ORDER BY $orderBy';
    if (limit != null) sql += ' LIMIT $limit';
    return _select(sql, whereArgs ?? []);
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? args,
  ]) =>
      _select(sql, args ?? []);

  /// Inserts [values] into [table]. Returns the last inserted row ID.
  Future<int> insert(String table, Map<String, dynamic> values) {
    final cols = values.keys.join(', ');
    final placeholders = List.filled(values.length, '?').join(', ');
    return _appDb.customInsert(
      'INSERT INTO $table ($cols) VALUES ($placeholders)',
      variables: _vars(values.values.toList()),
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) {
    final sets = values.keys.map((k) => '$k = ?').join(', ');
    var sql = 'UPDATE $table SET $sets';
    if (where != null) sql += ' WHERE $where';
    final vars = [
      ..._vars(values.values.toList()),
      ..._vars(whereArgs ?? []),
    ];
    return _appDb.customUpdate(
      sql,
      variables: vars,
      updateKind: UpdateKind.update,
    );
  }

  /// Runs [action] inside a database transaction.
  /// All [insert]/[update]/[query]/[rawQuery] calls within [action]
  /// automatically participate in the transaction via Drift's ambient context.
  Future<T> transaction<T>(Future<T> Function() action) =>
      _appDb.transaction(action);

  Future<void> close() => _appDb.close();

  // ── Seeding ───────────────────────────────────────────────────────────────

  Future<void> _seedIfEmpty() async {
    final rows = await rawQuery('SELECT COUNT(*) FROM projects');
    final count = rows.first.values.first as int? ?? 0;
    if (count > 0) return;
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/seed_data.json');
      await _SeedLoader(this).load(jsonStr);
    } catch (_) {}
  }

  // ── Internals ─────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> _select(
    String sql,
    List<Object?> args,
  ) async =>
      (await _appDb.customSelect(sql, variables: _vars(args)).get())
          .map((r) => r.data)
          .toList();

  static List<Variable<Object>> _vars(List<Object?> args) =>
      args.map((a) => Variable(a)).toList();
}

class _SeedLoader {
  final DatabaseHelper _db;
  _SeedLoader(this._db);

  Future<void> load(String jsonStr) async {
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    await _db.transaction(() async {
      for (final p in (data['projects'] as List<dynamic>)) {
        await _insertIgnore('projects', p as Map);
      }
      for (final t in (data['towers'] as List<dynamic>)) {
        await _insertIgnore('towers', t as Map);
      }
      for (final u in (data['units'] as List<dynamic>)) {
        await _insertIgnore('units', u as Map);
      }
      for (final u in (data['users'] as List<dynamic>? ?? [])) {
        await _insertIgnore('users', u as Map);
      }
      for (final b in (data['bookings'] as List<dynamic>? ?? [])) {
        await _insertIgnore('bookings', b as Map);
      }
      for (final m in (data['payment_milestones'] as List<dynamic>? ?? [])) {
        await _insertIgnore('payment_milestones', m as Map);
      }
      for (final d in (data['documents'] as List<dynamic>? ?? [])) {
        await _insertIgnore('documents', d as Map);
      }
      for (final t in (data['tickets'] as List<dynamic>? ?? [])) {
        await _insertIgnore('tickets', t as Map);
      }
      for (final c in (data['ticket_comments'] as List<dynamic>? ?? [])) {
        await _insertIgnore('ticket_comments', c as Map);
      }
      for (final n in (data['notifications'] as List<dynamic>? ?? [])) {
        await _insertIgnore('notifications', n as Map);
      }
    });
  }

  Future<void> _insertIgnore(String table, Map values) async {
    final row = Map<String, dynamic>.from(values);
    final cols = row.keys.join(', ');
    final placeholders = List.filled(row.length, '?').join(', ');
    await _db._appDb.customInsert(
      'INSERT OR IGNORE INTO $table ($cols) VALUES ($placeholders)',
      variables: DatabaseHelper._vars(row.values.toList()),
    );
  }
}
