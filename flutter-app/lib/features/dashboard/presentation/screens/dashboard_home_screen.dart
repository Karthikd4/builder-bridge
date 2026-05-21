import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';
import 'package:builder_bridge/features/dashboard/presentation/widgets/dashboard_hero_card.dart';
import 'package:builder_bridge/features/dashboard/presentation/widgets/dashboard_journey_card.dart';
import 'package:builder_bridge/features/dashboard/presentation/widgets/dashboard_next_up_card.dart';
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
          child: Icon(Icons.cottage_outlined,
              color: AppColors.accent, size: 26),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prestige Heights',
                style:
                    AppTypography.labelLarge.copyWith(color: AppColors.ink)),
            Text('Whitefield, Bangalore', style: AppTypography.labelSmall),
          ],
        ),
        actions: const [NotificationsBell()],
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
              Text('Your home, in motion.', style: AppTypography.displayLarge),
              const SizedBox(height: AppSpacing.xl),
              const DashboardHeroCard(),
              const SizedBox(height: AppSpacing.lg),
              _JourneySectionHeader(
                onSeeAll: () => context.go(AppRoutes.payments),
              ),
              const SizedBox(height: AppSpacing.md),
              const DashboardJourneyCard(),
              const SizedBox(height: AppSpacing.lg),
              const DashboardNextUpCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneySectionHeader extends StatelessWidget {
  final VoidCallback onSeeAll;
  const _JourneySectionHeader({required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('YOUR JOURNEY',
            style: AppTypography.labelSmall.copyWith(letterSpacing: 0.8)),
        GestureDetector(
          onTap: onSeeAll,
          child: Text('See all',
              style:
                  AppTypography.labelSmall.copyWith(color: AppColors.accent)),
        ),
      ],
    );
  }
}
