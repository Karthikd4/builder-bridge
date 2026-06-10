import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/core/utils/format_utils.dart';
import 'package:builder_bridge/features/payments/data/models/payment_milestone_model.dart';

class PaymentRepository {
  final _db = DatabaseHelper();

  Future<List<PaymentMilestoneModel>> getForBooking(int bookingId) async {
    final rows = await _db.query(
      'payment_milestones',
      where: 'booking_id = ?',
      whereArgs: [bookingId],
      orderBy: 'due_date ASC',
    );
    return rows.map(PaymentMilestoneModel.fromJson).toList();
  }

  /// Marks a milestone as paid, atomically:
  /// - flips paid_at on the milestone
  /// - recomputes booking.status (reserved → confirmed at ≥20% paid → completed at 100%)
  /// - inserts a Receipt document for the milestone
  /// - inserts a "Payment received" notification for the user
  /// - if status crossed to confirmed/completed, inserts a status notification
  Future<void> markPaid(int milestoneId) async {
    final paidAt = DateTime.now().toIso8601String();

    await _db.transaction(() async {
      // 1. Mark the milestone paid
      await _db.update(
        'payment_milestones',
        {'paid_at': paidAt},
        where: 'id = ?',
        whereArgs: [milestoneId],
      );

      // 2. Look up milestone details
      final milestoneRows = await _db.query(
        'payment_milestones',
        where: 'id = ?',
        whereArgs: [milestoneId],
      );
      if (milestoneRows.isEmpty) return;
      final milestone = milestoneRows.first;
      final bookingId = milestone['booking_id'] as int;
      final label = milestone['label'] as String;
      final amount = milestone['amount'] as int;

      // 3. Look up booking
      final bookingRows = await _db.query(
          'bookings', where: 'id = ?', whereArgs: [bookingId]);
      if (bookingRows.isEmpty) return;
      final booking = bookingRows.first;
      final userId = booking['user_id'] as int;
      final currentStatus = booking['status'] as String;

      // 4. Compute new status from milestone progress
      final allRows = await _db.query(
        'payment_milestones',
        where: 'booking_id = ?',
        whereArgs: [bookingId],
      );
      var paid = 0;
      var total = 0;
      for (final m in allRows) {
        final a = m['amount'] as int;
        total += a;
        if (m['paid_at'] != null) paid += a;
      }
      final progress = total > 0 ? paid / total : 0.0;
      final newStatus = progress >= 1.0
          ? 'completed'
          : progress >= 0.20
              ? 'confirmed'
              : 'reserved';
      final statusChanged = newStatus != currentStatus;

      if (statusChanged) {
        await _db.update(
          'bookings',
          {'status': newStatus},
          where: 'id = ?',
          whereArgs: [bookingId],
        );
      }

      final formattedAmount = _formatPaise(amount);

      // 5. Insert receipt document
      await _db.insert('documents', {
        'booking_id': bookingId,
        'type': 'Receipts',
        'name': 'Receipt — $label $formattedAmount.pdf',
        'status': 'ready',
        'file_path': null,
        'created_at': paidAt,
      });

      // 6. Payment-received notification
      await _db.insert('notifications', {
        'user_id': userId,
        'type': 'payment_due',
        'title': 'Payment received',
        'body': '$label — $formattedAmount received.',
        'read_at': null,
        'created_at': paidAt,
      });

      // 7. Status transition notification
      if (statusChanged && newStatus == 'completed') {
        await _db.insert('notifications', {
          'user_id': userId,
          'type': 'booking_confirmed',
          'title': 'All payments complete!',
          'body': 'Your unit is ready for possession. Congratulations!',
          'read_at': null,
          'created_at': paidAt,
        });
      } else if (statusChanged && newStatus == 'confirmed') {
        await _db.insert('notifications', {
          'user_id': userId,
          'type': 'booking_confirmed',
          'title': 'Booking confirmed',
          'body': 'Agreement payment received. Your unit moves into construction.',
          'read_at': null,
          'created_at': paidAt,
        });
      }
    });
  }

  /// Idempotent: if a booking has no milestones (legacy), generate
  /// the 5%/15%/20%/20%/40% schedule with the token marked paid.
  Future<bool> ensureMilestonesFor({
    required int bookingId,
    required int totalPaise,
    required String bookedAt,
  }) async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(*) FROM payment_milestones WHERE booking_id = ?',
      [bookingId],
    );
    final existing = rows.first.values.first as int? ?? 0;
    if (existing > 0) return false;

    final dt = DateTime.parse(bookedAt);
    final schedule = <(String, int, int, String?)>[
      ('Token Amount',       (totalPaise * 0.05).round(), 0,   bookedAt),
      ('On Agreement',       (totalPaise * 0.15).round(), 30,  null),
      ('On Foundation',      (totalPaise * 0.20).round(), 120, null),
      ('On Slab — 5th Flr',  (totalPaise * 0.20).round(), 240, null),
      ('On Completion',      (totalPaise * 0.40).round(), 540, null),
    ];

    await _db.transaction(() async {
      for (final (label, amount, daysOffset, paidAt) in schedule) {
        await _db.insert('payment_milestones', {
          'booking_id': bookingId,
          'label': label,
          'amount': amount,
          'due_date': dt.add(Duration(days: daysOffset)).toIso8601String(),
          'paid_at': paidAt,
        });
      }
    });
    return true;
  }

  String _formatPaise(int paise) => FormatUtils.formatPaise(paise);
}
