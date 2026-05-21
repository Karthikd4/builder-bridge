import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:builder_bridge/features/booking/data/models/estimate_breakdown.dart';
import 'package:builder_bridge/features/booking/presentation/providers/booking_provider.dart';
import 'package:builder_bridge/features/documents/presentation/providers/documents_provider.dart';
import 'package:builder_bridge/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:builder_bridge/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:builder_bridge/features/payments/data/models/payment_milestone_model.dart';
import 'package:builder_bridge/features/payments/data/models/payment_summary.dart';
import 'package:builder_bridge/features/payments/data/repositories/payment_repository.dart';

part 'payments_provider.g.dart';

@riverpod
PaymentRepository paymentRepository(Ref ref) => PaymentRepository();

@riverpod
Future<List<PaymentMilestoneModel>> bookingMilestones(
    Ref ref, int bookingId) {
  return ref.watch(paymentRepositoryProvider).getForBooking(bookingId);
}

@riverpod
Future<PaymentSummary?> currentPaymentSummary(Ref ref) async {
  final booking = await ref.watch(currentUserBookingProvider.future);
  if (booking == null) return null;

  final paymentRepo = ref.watch(paymentRepositoryProvider);
  var milestones = await paymentRepo.getForBooking(booking.id);

  // Self-heal: booking exists but no milestones (legacy or new-flow bookings
  // created before milestone generation was added).
  if (milestones.isEmpty) {
    final unit =
        await ref.read(unitRepositoryProvider).getById(booking.unitId);
    if (unit != null) {
      final total = EstimateBreakdown.forUnit(unit).total;
      final created = await paymentRepo.ensureMilestonesFor(
        bookingId: booking.id,
        totalPaise: total,
        bookedAt: booking.bookedAt,
      );
      if (created) {
        milestones = await paymentRepo.getForBooking(booking.id);
      }
    }
  }

  return PaymentSummary.from(milestones);
}

@riverpod
class MilestonePaymentNotifier extends _$MilestonePaymentNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> markPaid(int milestoneId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(paymentRepositoryProvider).markPaid(milestoneId);
      // markPaid touches: milestones, booking.status, documents, notifications.
      // Invalidate every dependent provider so all tabs re-read in sync.
      ref.invalidate(currentPaymentSummaryProvider);
      ref.invalidate(currentUserBookingProvider);
      ref.invalidate(currentBookingDocumentsProvider);
      ref.invalidate(userNotificationsProvider);
      ref.invalidate(unreadNotificationCountProvider);
    });
  }
}
