import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/booking/presentation/providers/booking_provider.dart';
import 'package:builder_bridge/features/payments/presentation/providers/payments_provider.dart';

class DashboardNextUpCard extends ConsumerWidget {
  const DashboardNextUpCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(currentUserBookingProvider).valueOrNull;
    final summary = ref.watch(currentPaymentSummaryProvider).valueOrNull;
    if (booking == null || summary == null) return const SizedBox.shrink();

    // All paid → celebration tile.
    if (booking.status == 'completed') {
      return _Tile(
        accent: AppColors.ok,
        eyebrow: '🎉 All payments complete',
        body: 'Your unit is ready for possession.',
        onTap: () => context.go(AppRoutes.dashboard),
      );
    }

    final nextDue = summary.nextDue;
    if (nextDue == null) return const SizedBox.shrink();
    return _Tile(
      accent: AppColors.accent,
      eyebrow: 'Next up',
      body: '${nextDue.label} · ${nextDue.formattedAmount}',
      onTap: () => context.go(AppRoutes.payments),
    );
  }
}

class _Tile extends StatelessWidget {
  final Color accent;
  final String eyebrow;
  final String body;
  final VoidCallback onTap;

  const _Tile({
    required this.accent,
    required this.eyebrow,
    required this.body,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: onTap,
      child: Container(
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
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eyebrow,
                      style: AppTypography.labelSmall.copyWith(color: accent)),
                  Text(body, style: AppTypography.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.inkFaint, size: 20),
          ],
        ),
      ),
    );
  }
}
