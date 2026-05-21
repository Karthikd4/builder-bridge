import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';
import 'package:builder_bridge/features/booking/presentation/providers/booking_provider.dart';
import 'package:builder_bridge/features/support/data/models/ticket_comment_model.dart';
import 'package:builder_bridge/features/support/data/models/ticket_model.dart';
import 'package:builder_bridge/features/support/data/repositories/support_repository.dart';

part 'support_provider.g.dart';

@riverpod
SupportRepository supportRepository(Ref ref) => SupportRepository();

@riverpod
Future<List<TicketModel>> userTickets(Ref ref) async {
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(supportRepositoryProvider).getForUser(int.parse(user.id));
}

@riverpod
Future<TicketModel?> ticketById(Ref ref, int ticketId) {
  return ref.watch(supportRepositoryProvider).getById(ticketId);
}

@riverpod
Future<List<TicketCommentModel>> ticketComments(Ref ref, int ticketId) {
  return ref.watch(supportRepositoryProvider).getComments(ticketId);
}

@riverpod
class CreateTicketNotifier extends _$CreateTicketNotifier {
  @override
  AsyncValue<TicketModel?> build() => const AsyncValue.data(null);

  Future<TicketModel?> submit({
    required String title,
    required String description,
  }) async {
    final user = ref.read(authProvider).user;
    if (user == null) return null;
    final booking = await ref.read(currentUserBookingProvider.future);

    state = const AsyncValue.loading();
    try {
      final ticket = await ref.read(supportRepositoryProvider).createTicket(
            userId: int.parse(user.id),
            bookingId: booking?.id,
            title: title,
            description: description,
          );
      state = AsyncValue.data(ticket);
      ref.invalidate(userTicketsProvider);
      return ticket;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

@riverpod
class AddCommentNotifier extends _$AddCommentNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> submit({required int ticketId, required String body}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(supportRepositoryProvider).addComment(
            ticketId: ticketId,
            author: 'You',
            body: body,
          );
      ref.invalidate(ticketCommentsProvider(ticketId));
    });
  }
}
