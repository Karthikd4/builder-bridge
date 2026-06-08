import 'package:sqflite/sqflite.dart';

import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/core/utils/format_utils.dart';
import 'package:builder_bridge/features/booking/data/models/booking_model.dart';

class BookingRepository {
  final _db = DatabaseHelper();

  Future<BookingModel?> getLatestForUser(int userId) async {
    final db = await _db.database;
    final rows = await db.query(
      'bookings',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'booked_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  Future<BookingModel?> getByUnit(int unitId) async {
    final db = await _db.database;
    final rows = await db.query(
      'bookings',
      where: 'unit_id = ?',
      whereArgs: [unitId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  /// True if this user has ANY booking (used to lock further bookings).
  Future<bool> userHasBooking(int userId) async {
    final db = await _db.database;
    final n = Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM bookings WHERE user_id = ?', [userId])) ??
        0;
    return n > 0;
  }

  /// Creates a booking atomically with milestones, base documents,
  /// token receipt, and a welcome notification.
  Future<BookingModel> createBooking({
    required int unitId,
    required int userId,
    required int tokenAmount,
    required int totalPaise,
    required String unitNo,
  }) async {
    final db = await _db.database;
    final now = DateTime.now().toIso8601String();

    return db.transaction((txn) async {
      final id = await txn.insert('bookings', {
        'unit_id': unitId,
        'user_id': userId,
        'status': 'reserved',
        'token_amount': tokenAmount,
        'booked_at': now,
      });

      await txn.update(
        'units',
        {'status': 'reserved'},
        where: 'id = ?',
        whereArgs: [unitId],
      );

      await _insertMilestones(txn, id, totalPaise, now);
      await _insertBookingDocs(txn, id, unitNo, now, tokenAmount: tokenAmount);
      await _insertWelcomeNotification(txn, userId, unitNo, now);

      return BookingModel(
        id: id,
        unitId: unitId,
        userId: userId,
        status: 'reserved',
        tokenAmount: tokenAmount,
        bookedAt: now,
      );
    });
  }

  Future<void> _insertMilestones(
      Transaction txn, int bookingId, int totalPaise, String bookedAt) async {
    final dt = DateTime.parse(bookedAt);
    final schedule = <(String, int, int, String?)>[
      ('Token Amount',      (totalPaise * 0.05).round(), 0,   bookedAt),
      ('On Agreement',      (totalPaise * 0.15).round(), 30,  null),
      ('On Foundation',     (totalPaise * 0.20).round(), 120, null),
      ('On Slab — 5th Flr', (totalPaise * 0.20).round(), 240, null),
      ('On Completion',     (totalPaise * 0.40).round(), 540, null),
    ];
    for (final (label, amount, daysOffset, paidAt) in schedule) {
      await txn.insert('payment_milestones', {
        'booking_id': bookingId,
        'label': label,
        'amount': amount,
        'due_date': dt.add(Duration(days: daysOffset)).toIso8601String(),
        'paid_at': paidAt,
      });
    }
  }

  Future<void> _insertBookingDocs(
    Transaction txn,
    int bookingId,
    String unitNo,
    String createdAt, {
    required int tokenAmount,
  }) async {
    final tokenFormatted = _formatPaise(tokenAmount);
    final docs = <(String, String, String)>[
      ('Agreement',  'Booking Confirmation Letter.pdf',          'signed'),
      ('Agreement',  'Agreement of Sale — Draft v1.pdf',         'under_review'),
      ('Plans',      'Unit $unitNo — Floor plan.pdf',            'ready'),
      ('Plans',      'The Vue Residences — Master layout.pdf',     'ready'),
      ('Compliance', 'RERA Certificate — P02400006789.pdf',      'ready'),
      ('Compliance', 'Title deed — Survey 138/2.pdf',            'ready'),
      ('Receipts',   'Receipt — Token Amount $tokenFormatted.pdf', 'ready'),
    ];
    for (final (type, name, status) in docs) {
      await txn.insert('documents', {
        'booking_id': bookingId,
        'type': type,
        'name': name,
        'status': status,
        'file_path': null,
        'created_at': createdAt,
      });
    }
  }

  Future<void> _insertWelcomeNotification(
      Transaction txn, int userId, String unitNo, String createdAt) async {
    await txn.insert('notifications', {
      'user_id': userId,
      'type': 'booking_confirmed',
      'title': 'Booking confirmed',
      'body': 'Your booking for Unit $unitNo has been confirmed. Welcome aboard!',
      'read_at': null,
      'created_at': createdAt,
    });
  }

  String _formatPaise(int paise) => FormatUtils.formatPaise(paise);

  BookingModel _fromRow(Map<String, dynamic> row) => BookingModel(
        id: row['id'] as int,
        unitId: row['unit_id'] as int,
        userId: row['user_id'] as int,
        status: row['status'] as String,
        tokenAmount: row['token_amount'] as int,
        bookedAt: row['booked_at'] as String,
      );
}
