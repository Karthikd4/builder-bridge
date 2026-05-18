import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';

class DashboardHomeScreen extends ConsumerWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(authProvider.select((s) => s.user?.displayName ?? 'Buyer'));
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: AppSpacing.md),
          child: Icon(Icons.cottage_outlined, color: AppColors.accent, size: 26),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prestige Heights',
                style: AppTypography.labelLarge.copyWith(color: AppColors.ink)),
            Text('Whitefield, Bangalore',
                style: AppTypography.labelSmall),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.ink),
            onPressed: () {},
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
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.inkMute)),
              const SizedBox(height: AppSpacing.xs),
              Text('Your home, in motion.',
                  style: AppTypography.displayLarge),
              const SizedBox(height: AppSpacing.xl),

              // Hero unit card — data arrives Sprint 3
              _HeroPlaceholder(),
              const SizedBox(height: AppSpacing.lg),

              // Journey section — data arrives Sprint 3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('YOUR JOURNEY',
                      style: AppTypography.labelSmall
                          .copyWith(letterSpacing: 0.8)),
                  Text('See all',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.accent)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _JourneyPlaceholder(),
              const SizedBox(height: AppSpacing.lg),

              // Next up card — data arrives Sprint 4
              _NextUpPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: const BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLg)),
            ),
            child: const Center(
              child: Icon(Icons.apartment_outlined,
                  size: 48, color: AppColors.accent),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: _StatCell(label: 'AGREED PRICE', value: '—'),
                ),
                SizedBox(width: 1, height: 36,
                    child: ColoredBox(color: AppColors.line)),
                Expanded(
                  child: _StatCell(label: 'PAID', value: '—'),
                ),
                SizedBox(width: 1, height: 36,
                    child: ColoredBox(color: AppColors.line)),
                Expanded(
                  child: _StatCell(label: 'POSSESSION', value: '—'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(fontSize: 9)),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.labelLarge),
      ],
    );
  }
}

class _JourneyPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.line),
      ),
      child: Center(
        child: Text('Booking journey available after Sprint 3',
            style: AppTypography.bodySmall.copyWith(color: AppColors.inkFaint)),
      ),
    );
  }
}

class _NextUpPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next up',
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.accent)),
                Text('Payment milestones available after Sprint 4',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.inkFaint)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
