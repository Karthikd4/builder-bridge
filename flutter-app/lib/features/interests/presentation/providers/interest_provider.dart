import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';
import 'package:builder_bridge/features/interests/data/models/interest_model.dart';
import 'package:builder_bridge/features/interests/data/repositories/interest_repository.dart';
import 'package:builder_bridge/features/notifications/presentation/providers/notifications_provider.dart';

part 'interest_provider.g.dart';

@riverpod
InterestRepository interestRepository(Ref ref) => InterestRepository();

@riverpod
Future<InterestModel?> currentUserInterest(Ref ref) async {
  final user = ref.watch(authProvider).user;
  if (user == null) return null;
  return ref
      .watch(interestRepositoryProvider)
      .getLatestForUser(int.parse(user.id));
}

@riverpod
Future<List<InterestModel>> allInterests(Ref ref) {
  return ref.watch(interestRepositoryProvider).getAllInterests();
}

@riverpod
class InterestNotifier extends _$InterestNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> submit({
    required int unitId,
    required int userId,
    required String unitNo,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(interestRepositoryProvider).submitInterest(
            unitId: unitId,
            userId: userId,
            unitNo: unitNo,
          );
      ref.invalidate(currentUserInterestProvider);
      ref.invalidate(userNotificationsProvider);
      ref.invalidate(unreadNotificationCountProvider);
    });
  }
}
