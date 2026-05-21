import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/inventory/data/models/project_model.dart';

class ProjectRepository {
  Future<ProjectModel?> getFirstProject() async {
    final db = await DatabaseHelper().database;
    final rows = await db.query('projects', limit: 1, orderBy: 'id ASC');
    if (rows.isEmpty) return null;
    return ProjectModel.fromJson(rows.first);
  }

  Future<ProjectModel?> getById(int id) async {
    final db = await DatabaseHelper().database;
    final rows = await db.query('projects', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return ProjectModel.fromJson(rows.first);
  }
}
