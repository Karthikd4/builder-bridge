import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/interests/data/models/interest_model.dart';

class InterestRepository {
  final _db = DatabaseHelper();

  // Shared JOIN query body — filter/sort suffix appended at each call site.
  static const _baseQuery = '''
    SELECT i.*,
           u.name  AS user_name,
           u.phone AS phone,
           u.email AS email,
           un.unit_no   AS unit_no,
           un.type      AS unit_type,
           un.floor     AS unit_floor,
           t.name       AS tower_name
    FROM interests i
    LEFT JOIN users u  ON i.user_id  = u.id
    LEFT JOIN units un ON i.unit_id  = un.id
    LEFT JOIN towers t ON un.tower_id = t.id
  ''';

  Future<InterestModel?> getLatestForUser(int userId) async {
    final rows = await _db.rawQuery(
      '$_baseQuery WHERE i.user_id = ? ORDER BY i.created_at DESC LIMIT 1',
      [userId],
    );
    if (rows.isEmpty) return null;
    return InterestModel.fromJson(Map<String, dynamic>.from(rows.first));
  }

  /// Returns all expressed interests with buyer + unit details.
  /// TODO(backend): Replace with GET /interests API call so the builder portal
  /// can surface buyer interest data without relying on local SQLite.
  Future<List<InterestModel>> getAllInterests() async {
    final rows = await _db.rawQuery(
      '$_baseQuery ORDER BY i.created_at DESC',
    );
    return rows
        .map((r) => InterestModel.fromJson(Map<String, dynamic>.from(r)))
        .toList();
  }

  /// Submits an interest record and triggers an in-app notification.
  /// TODO(backend): POST /interests — send to backend so builder portal shows
  /// who expressed interest in which unit with their contact details.
  Future<InterestModel> submitInterest({
    required int unitId,
    required int userId,
    required String unitNo,
  }) async {
    final now = DateTime.now().toIso8601String();

    return _db.transaction(() async {
      final id = await _db.insert('interests', {
        'unit_id': unitId,
        'user_id': userId,
        'status': InterestStatus.newInterest,
        'created_at': now,
      });

      await _db.insert('notifications', {
        'user_id': userId,
        'type': 'booking_confirmed',
        'title': 'Interest registered',
        'body':
            'Your interest in Unit $unitNo has been noted. Our team will contact you within 24 hours.',
        'read_at': null,
        'created_at': now,
      });

      return InterestModel(
        id: id,
        unitId: unitId,
        userId: userId,
        status: InterestStatus.newInterest,
        createdAt: now,
      );
    });
  }

  Future<void> updateStatus(int interestId, String status) async {
    await _db.update(
      'interests',
      {'status': status},
      where: 'id = ?',
      whereArgs: [interestId],
    );
  }
}

/// Known interest status values — use these constants instead of bare strings.
abstract final class InterestStatus {
  static const newInterest = 'new';
  static const contacted   = 'contacted';
  static const converted   = 'converted';
}
