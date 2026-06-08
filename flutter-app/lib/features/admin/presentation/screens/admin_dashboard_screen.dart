import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_card.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/admin/presentation/providers/admin_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminDashboardStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Dashboard', style: AppTypography.labelLarge),
      ),
      body: statsAsync.when(
        loading: () => const BBLoadingState(),
        error: (_, __) => BBErrorState(
          message: 'Could not load dashboard',
          onRetry: () => ref.invalidate(adminDashboardStatsProvider),
        ),
        data: (stats) => _DashboardBody(stats: stats),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final AdminDashboardStats stats;
  const _DashboardBody({required this.stats});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          const _SectionLabel('UNITS'),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total Units',
                  value: '${stats.totalUnits}',
                  icon: Icons.apartment_rounded,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  label: 'Available',
                  value: '${stats.availableUnits}',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.ok,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Reserved',
                  value: '${stats.reservedUnits}',
                  icon: Icons.schedule_rounded,
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  label: 'Booked',
                  value: '${stats.bookedUnits}',
                  icon: Icons.lock_rounded,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const _SectionLabel('BUYER INTERESTS'),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total Interests',
                  value: '${stats.totalInterests}',
                  icon: Icons.star_rounded,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  label: 'Needs Follow-up',
                  value: '${stats.newInterests}',
                  icon: Icons.notifications_active_outlined,
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.labelSmall.copyWith(
        color: AppColors.inkFaint,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BBCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: AppSpacing.sm),
          Text(value,
              style: AppTypography.headlineMedium.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label,
              style:
                  AppTypography.bodySmall.copyWith(color: AppColors.inkMute)),
        ],
      ),
    );
  }
}
