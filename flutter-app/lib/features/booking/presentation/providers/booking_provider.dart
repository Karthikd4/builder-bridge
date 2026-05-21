import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';
import 'package:builder_bridge/features/booking/data/models/booking_model.dart';
import 'package:builder_bridge/features/booking/data/repositories/booking_repository.dart';

part 'booking_provider.g.dart';

@riverpod
BookingRepository bookingRepository(Ref ref) => BookingRepository();

@riverpod
Future<BookingModel?> currentUserBooking(Ref ref) async {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  if (user == null) return null;
  final repo = ref.watch(bookingRepositoryProvider);
  return repo.getLatestForUser(int.parse(user.id));
}

/// True if the current user already has a booking — used to lock further
/// bookings (one booking per account).
@riverpod
Future<bool> currentUserHasBooking(Ref ref) async {
  final booking = await ref.watch(currentUserBookingProvider.future);
  return booking != null;
}

@riverpod
class BookingNotifier extends _$BookingNotifier {
  @override
  AsyncValue<BookingModel?> build() => const AsyncValue.data(null);

  Future<BookingModel> confirm({
    required int unitId,
    required int userId,
    required int tokenAmount,
    required int totalPaise,
    required String unitNo,
  }) async {
    state = const AsyncValue.loading();
    final repo = ref.read(bookingRepositoryProvider);
    try {
      final booking = await repo.createBooking(
        unitId: unitId,
        userId: userId,
        tokenAmount: tokenAmount,
        totalPaise: totalPaise,
        unitNo: unitNo,
      );
      state = AsyncValue.data(booking);
      ref.invalidate(currentUserBookingProvider);
      ref.invalidate(currentUserHasBookingProvider);
      return booking;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
