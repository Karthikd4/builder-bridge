import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';
import 'package:builder_bridge/features/notifications/data/models/notification_model.dart';
import 'package:builder_bridge/features/notifications/data/repositories/notification_repository.dart';

part 'notifications_provider.g.dart';

@riverpod
NotificationRepository notificationRepository(Ref ref) =>
    NotificationRepository();

@riverpod
Future<List<NotificationModel>> userNotifications(Ref ref) async {
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref
      .watch(notificationRepositoryProvider)
      .getForUser(int.parse(user.id));
}

@riverpod
Future<int> unreadNotificationCount(Ref ref) async {
  final user = ref.watch(authProvider).user;
  if (user == null) return 0;
  return ref
      .watch(notificationRepositoryProvider)
      .unreadCount(int.parse(user.id));
}

@riverpod
class NotificationsActionsNotifier extends _$NotificationsActionsNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> markRead(int id) async {
    await ref.read(notificationRepositoryProvider).markRead(id);
    ref.invalidate(userNotificationsProvider);
    ref.invalidate(unreadNotificationCountProvider);
  }

  Future<void> markAllRead() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;
    await ref
        .read(notificationRepositoryProvider)
        .markAllRead(int.parse(user.id));
    ref.invalidate(userNotificationsProvider);
    ref.invalidate(unreadNotificationCountProvider);
  }
}
