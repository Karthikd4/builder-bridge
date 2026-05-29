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

    if (booking.status == 'completed') {
      return _CompletedBanner();
    }

    final nextDue = summary.nextDue;
    if (nextDue == null) return const SizedBox.shrink();

    final daysUntil =
        nextDue.dueDateTime.difference(DateTime.now()).inDays;
    final daysLabel = daysUntil <= 0
        ? 'overdue'
        : daysUntil == 1
            ? 'due tomorrow'
            : 'due in $daysUntil days';
    final daysColor =
        daysUntil <= 0 ? AppColors.danger : AppColors.inkMute;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.accent),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _NextUpPill(),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Due ${_fmtDate(nextDue.dueDate)}',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.inkMute),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  nextDue.label,
                  style: AppTypography.headlineSmall.copyWith(
                      fontSize: 17, letterSpacing: -0.2),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      nextDue.formattedAmount,
                      style: AppTypography.headlineMedium.copyWith(
                          fontSize: 22, letterSpacing: -0.3),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(daysLabel,
                        style: AppTypography.bodySmall
                            .copyWith(color: daysColor)),
                  ],
                ),
              ],
            ),
          ),
          // Bottom CTA — flat top, rounded bottom
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppSpacing.radiusMd - 1)),
            child: Material(
              color: AppColors.accent,
              child: InkWell(
                onTap: () => context.go(AppRoutes.payments),
                child: Container(
                  height: 52,
                  alignment: Alignment.center,
                  child: Text(
                    'Pay ${nextDue.formattedAmount}',
                    style: AppTypography.labelLarge
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtDate(String isoDate) {
    final dt = DateTime.parse(isoDate);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

class _NextUpPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome_rounded,
              size: 11, color: AppColors.accent),
          const SizedBox(width: 4),
          Text('Next up',
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.accent)),
        ],
      ),
    );
  }
}

class _CompletedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.okSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.ok.withAlpha(80)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.ok, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('All payments complete',
                    style: AppTypography.labelMedium),
                Text('Your unit is ready for possession.',
                    style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
