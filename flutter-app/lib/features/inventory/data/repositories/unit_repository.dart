import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';

class UnitRepository {
  Future<List<UnitModel>> getUnitsForTower(int towerId) async {
    final db = await DatabaseHelper().database;
    final rows = await db.query(
      'units',
      where: 'tower_id = ?',
      whereArgs: [towerId],
      orderBy: 'floor ASC, unit_no ASC',
    );
    return rows.map(UnitModel.fromJson).toList();
  }

  Future<UnitModel?> getById(int id) async {
    final db = await DatabaseHelper().database;
    final rows = await db.query('units', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return UnitModel.fromJson(rows.first);
  }

  Future<Map<String, int>> getStatusCountsForTower(int towerId) async {
    final db = await DatabaseHelper().database;
    final rows = await db.rawQuery(
      'SELECT status, COUNT(*) as cnt FROM units WHERE tower_id = ? GROUP BY status',
      [towerId],
    );
    return {for (final r in rows) r['status'] as String: r['cnt'] as int};
  }
}
