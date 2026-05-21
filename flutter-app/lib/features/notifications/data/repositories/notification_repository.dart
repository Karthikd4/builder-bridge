import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/notifications/data/models/notification_model.dart';

class NotificationRepository {
  final _db = DatabaseHelper();

  Future<List<NotificationModel>> getForUser(int userId) async {
    final db = await _db.database;
    final rows = await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return rows.map(NotificationModel.fromJson).toList();
  }

  Future<int> unreadCount(int userId) async {
    final db = await _db.database;
    final rows = await db.rawQuery(
      'SELECT COUNT(*) FROM notifications WHERE user_id = ? AND read_at IS NULL',
      [userId],
    );
    return (rows.first.values.first as int?) ?? 0;
  }

  Future<void> markRead(int id) async {
    final db = await _db.database;
    await db.update(
      'notifications',
      {'read_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markAllRead(int userId) async {
    final db = await _db.database;
    await db.update(
      'notifications',
      {'read_at': DateTime.now().toIso8601String()},
      where: 'user_id = ? AND read_at IS NULL',
      whereArgs: [userId],
    );
  }
}
