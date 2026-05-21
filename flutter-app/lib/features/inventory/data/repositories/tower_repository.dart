import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/inventory/data/models/tower_model.dart';

class TowerRepository {
  Future<List<TowerModel>> getTowersForProject(int projectId) async {
    final db = await DatabaseHelper().database;
    final rows = await db.query(
      'towers',
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'id ASC',
    );
    return rows.map(TowerModel.fromJson).toList();
  }

  Future<TowerModel?> getById(int id) async {
    final db = await DatabaseHelper().database;
    final rows = await db.query('towers', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return TowerModel.fromJson(rows.first);
  }
}
