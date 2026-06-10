import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/documents/data/models/document_model.dart';

class DocumentRepository {
  final _db = DatabaseHelper();

  Future<List<DocumentModel>> getForBooking(int bookingId) async {
    final rows = await _db.query(
      'documents',
      where: 'booking_id = ?',
      whereArgs: [bookingId],
      orderBy: 'created_at DESC',
    );
    return rows.map(DocumentModel.fromJson).toList();
  }

  Future<DocumentModel?> getById(int id) async {
    final rows = await _db.query('documents', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return DocumentModel.fromJson(rows.first);
  }

  /// Idempotent: if a booking has no documents (legacy state), generate
  /// the standard 6-doc starter pack (confirmation letter, AOS draft,
  /// floor plan, master layout, RERA cert, title deed).
  Future<bool> ensureBookingDocsFor({
    required int bookingId,
    required String unitNo,
  }) async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(*) FROM documents WHERE booking_id = ?', [bookingId]);
    final existing = rows.first.values.first as int? ?? 0;
    if (existing > 0) return false;

    final now = DateTime.now().toIso8601String();
    final docs = <(String, String, String)>[
      ('Agreement',  'Booking Confirmation Letter.pdf',       'signed'),
      ('Agreement',  'Agreement of Sale — Draft v1.pdf',      'under_review'),
      ('Plans',      'Unit $unitNo — Floor plan.pdf',         'ready'),
      ('Plans',      'The Vue Residences — Master layout.pdf', 'ready'),
      ('Compliance', 'RERA Certificate — P02400006789.pdf',   'ready'),
      ('Compliance', 'Title deed — Survey 138/2.pdf',         'ready'),
    ];
    await _db.transaction(() async {
      for (final (type, name, status) in docs) {
        await _db.insert('documents', {
          'booking_id': bookingId,
          'type': type,
          'name': name,
          'status': status,
          'file_path': null,
          'created_at': now,
        });
      }
    });
    return true;
  }
}
