import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_empty_state.dart';
import 'package:builder_bridge/features/notifications/data/models/notification_model.dart';
import 'package:builder_bridge/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:builder_bridge/features/notifications/presentation/widgets/notification_row.dart';

class NotificationsSheet extends ConsumerWidget {
  const NotificationsSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const NotificationsSheet(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg)),
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
            _Header(
              onMarkAllRead: () => ref
                  .read(notificationsActionsNotifierProvider.notifier)
                  .markAllRead(),
            ),
            const Divider(height: 1, color: AppColors.line),
            Expanded(
              child: notificationsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, __) => Center(
                  child: Text('Could not load notifications',
                      style: AppTypography.bodySmall),
                ),
                data: (items) => items.isEmpty
                    ? const BBEmptyState(
                        icon: Icons.notifications_none_outlined,
                        message: "You're all caught up.",
                      )
                    : _NotificationList(
                        items: items,
                        scrollController: scrollCtrl,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onMarkAllRead;
  const _Header({required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.sm, AppSpacing.sm, AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text('Notifications', style: AppTypography.headlineSmall),
          ),
          TextButton(
            onPressed: onMarkAllRead,
            child: Text('Mark all read',
                style: AppTypography.labelMedium
                    .copyWith(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

class _NotificationList extends ConsumerWidget {
  final List<NotificationModel> items;
  final ScrollController scrollController;
  const _NotificationList(
      {required this.items, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      controller: scrollController,
      itemCount: items.length,
      itemBuilder: (_, i) {
        final n = items[i];
        return NotificationRow(
          notification: n,
          showDivider: i < items.length - 1,
          onTap: () async {
            if (n.isUnread) {
              await ref
                  .read(notificationsActionsNotifierProvider.notifier)
                  .markRead(n.id);
            }
            if (!context.mounted) return;
            final link = n.deepLink;
            if (link != null) {
              Navigator.of(context).pop();
              context.go(link);
            }
          },
        );
      },
    );
  }
}
