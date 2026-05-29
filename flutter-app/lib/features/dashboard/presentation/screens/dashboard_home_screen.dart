import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_logo.dart';
import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';
import 'package:builder_bridge/features/dashboard/presentation/widgets/dashboard_hero_card.dart';
import 'package:builder_bridge/features/dashboard/presentation/widgets/dashboard_journey_card.dart';
import 'package:builder_bridge/features/dashboard/presentation/widgets/dashboard_next_up_card.dart';
import 'package:builder_bridge/features/notifications/data/models/notification_model.dart';
import 'package:builder_bridge/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:builder_bridge/features/notifications/presentation/widgets/notifications_bell.dart';

class DashboardHomeScreen extends ConsumerWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(
        authProvider.select((s) => s.user?.displayName ?? 'Buyer'));
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: AppSpacing.md),
          child: BBLogo(size: 28),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('The Vue Residences',
                style:
                    AppTypography.labelLarge.copyWith(color: AppColors.ink)),
            Text('Puppalaguda, Hyderabad', style: AppTypography.labelSmall),
          ],
        ),
        actions: [
          const NotificationsBell(),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.inkMute),
            tooltip: 'Logout',
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$greeting, $name.',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.inkMute)),
              const SizedBox(height: AppSpacing.xs),
              Text('Your home, in motion.',
                  style: AppTypography.displayLarge),
              const SizedBox(height: AppSpacing.xl),
              const DashboardHeroCard(),
              const SizedBox(height: AppSpacing.lg),
              _SectionHeader(
                label: 'YOUR JOURNEY',
                actionLabel: 'See all',
                onAction: () => context.go(AppRoutes.payments),
              ),
              const SizedBox(height: AppSpacing.md),
              const DashboardJourneyCard(),
              const SizedBox(height: AppSpacing.lg),
              const DashboardNextUpCard(),
              const SizedBox(height: AppSpacing.lg),
              _QuickLinks(),
              const SizedBox(height: AppSpacing.lg),
              const _RecentActivitySection(),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _SectionHeader(
      {required this.label, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTypography.labelSmall.copyWith(letterSpacing: 0.8)),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!,
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.accent)),
          ),
      ],
    );
  }
}

class _QuickLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final links = [
      (
        icon: Icons.apartment_outlined,
        label: 'Browse inventory',
        route: AppRoutes.inventory
      ),
      (
        icon: Icons.layers_outlined,
        label: 'My floor plan',
        route: AppRoutes.documents
      ),
      (
        icon: Icons.receipt_long_outlined,
        label: 'Receipts',
        route: AppRoutes.payments
      ),
      (
        icon: Icons.description_outlined,
        label: 'Documents',
        route: AppRoutes.documents
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      childAspectRatio: 2.6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: links.map((q) {
        return GestureDetector(
          onTap: () => context.go(q.route),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child:
                      Icon(q.icon, size: 18, color: AppColors.accent),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(q.label,
                      style: AppTypography.labelMedium,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RecentActivitySection extends ConsumerWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider);
    return notificationsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (notifications) {
        if (notifications.isEmpty) return const SizedBox.shrink();
        final recent = notifications.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(label: 'RECENT ACTIVITY'),
            const SizedBox(height: AppSpacing.md),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                children: List.generate(recent.length, (i) {
                  final n = recent[i];
                  final isLast = i == recent.length - 1;
                  return _ActivityRow(
                      notification: n, showDivider: !isLast);
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final NotificationModel notification;
  final bool showDivider;
  const _ActivityRow(
      {required this.notification, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = notification.icon;
    final elapsed = _elapsed(notification.createdDateTime);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.title,
                        style: AppTypography.labelMedium
                            .copyWith(fontSize: 13.5)),
                    const SizedBox(height: 2),
                    Text(notification.body,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.inkMute)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(elapsed,
                  style: AppTypography.bodySmall.copyWith(
                      color: AppColors.inkFaint, fontSize: 11)),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: AppSpacing.md, color: AppColors.line),
      ],
    );
  }

  String _elapsed(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }
}
