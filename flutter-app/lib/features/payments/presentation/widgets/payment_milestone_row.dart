import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/features/payments/data/models/payment_milestone_model.dart';

class PaymentMilestoneRow extends StatelessWidget {
  final PaymentMilestoneModel milestone;
  final int index;
  final bool showDivider;
  final bool isNextDue;

  const PaymentMilestoneRow({
    required this.milestone,
    required this.index,
    required this.showDivider,
    this.isNextDue = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (status, label) = _statusAndLabel();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            children: [
              _StatusCircle(
                index: index,
                isPaid: milestone.isPaid,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(milestone.label,
                        style: AppTypography.labelLarge),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(milestone.dueDateTime),
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    milestone.formattedAmount,
                    style: AppTypography.labelLarge.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 4),
                  BBBadge(label: label, status: status),
                ],
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.line),
      ],
    );
  }

  (BBBadgeStatus, String) _statusAndLabel() {
    if (milestone.isPaid) return (BBBadgeStatus.ok, 'Paid');
    if (milestone.isOverdue) return (BBBadgeStatus.danger, 'Overdue');
    if (isNextDue) return (BBBadgeStatus.warn, 'Due');
    return (BBBadgeStatus.neutral, 'Upcoming');
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }
}

class _StatusCircle extends StatelessWidget {
  final int index;
  final bool isPaid;
  const _StatusCircle({required this.index, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isPaid ? AppColors.ok : AppColors.bg,
        shape: BoxShape.circle,
        border: isPaid
            ? null
            : Border.all(color: AppColors.lineStrong),
      ),
      alignment: Alignment.center,
      child: isPaid
          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
          : Text(
              '$index',
              style: AppTypography.labelSmall.copyWith(
                  color: AppColors.inkFaint, fontWeight: FontWeight.w700),
            ),
    );
  }
}
