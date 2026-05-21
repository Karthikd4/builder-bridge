import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/support/data/models/ticket_comment_model.dart';
import 'package:builder_bridge/features/support/data/models/ticket_model.dart';

class SupportRepository {
  final _db = DatabaseHelper();

  Future<List<TicketModel>> getForUser(int userId) async {
    final db = await _db.database;
    final rows = await db.query(
      'tickets',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return rows.map(TicketModel.fromJson).toList();
  }

  Future<TicketModel?> getById(int id) async {
    final db = await _db.database;
    final rows = await db.query('tickets', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return TicketModel.fromJson(rows.first);
  }

  Future<List<TicketCommentModel>> getComments(int ticketId) async {
    final db = await _db.database;
    final rows = await db.query(
      'ticket_comments',
      where: 'ticket_id = ?',
      whereArgs: [ticketId],
      orderBy: 'created_at ASC',
    );
    return rows.map(TicketCommentModel.fromJson).toList();
  }

  Future<TicketModel> createTicket({
    required int userId,
    int? bookingId,
    required String title,
    required String description,
  }) async {
    final db = await _db.database;
    final now = DateTime.now().toIso8601String();
    final id = await db.insert('tickets', {
      'user_id': userId,
      if (bookingId != null) 'booking_id': bookingId,
      'title': title,
      'description': description,
      'status': 'open',
      'created_at': now,
    });
    return TicketModel(
      id: id,
      userId: userId,
      bookingId: bookingId,
      title: title,
      description: description,
      status: 'open',
      createdAt: now,
    );
  }

  Future<void> addComment({
    required int ticketId,
    required String author,
    required String body,
  }) async {
    final db = await _db.database;
    await db.insert('ticket_comments', {
      'ticket_id': ticketId,
      'author': author,
      'body': body,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
