import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/payments/data/models/payment_summary.dart';
import 'package:builder_bridge/features/payments/presentation/widgets/payment_ring.dart';

class PaymentSummaryCard extends StatelessWidget {
  final PaymentSummary summary;
  const PaymentSummaryCard({required this.summary, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          PaymentRing(summary: summary, size: 180),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: 'MILESTONES',
                  value: '${summary.paidCount} / ${summary.totalCount}',
                  sub: 'paid',
                ),
              ),
              Expanded(
                child: _Stat(
                  label: 'NEXT DUE',
                  value: summary.nextDue != null
                      ? _shortDate(summary.nextDue!.dueDateTime)
                      : '—',
                  sub: summary.nextDue?.formattedAmount ?? 'all paid',
                ),
              ),
              Expanded(
                child: _Stat(
                  label: 'POSSESSION',
                  value: summary.possession != null
                      ? _shortDate(summary.possession!.dueDateTime)
                      : '—',
                  sub: 'final',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _shortDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _Stat({required this.label, required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.inkFaint,
              fontSize: 10,
              letterSpacing: 0.5,
            )),
        const SizedBox(height: 4),
        Text(value,
            style: AppTypography.labelLarge.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            )),
        Text(sub,
            style: AppTypography.bodySmall.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            )),
      ],
    );
  }
}
