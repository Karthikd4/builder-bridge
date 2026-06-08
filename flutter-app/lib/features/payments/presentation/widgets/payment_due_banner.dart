import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/payments/data/models/payment_milestone_model.dart';

class PaymentDueBanner extends StatelessWidget {
  final PaymentMilestoneModel milestone;

  const PaymentDueBanner({
    required this.milestone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final days = milestone.dueDateTime.difference(DateTime.now()).inDays;
    final tone = days < 0 ? AppColors.danger : AppColors.warn;
    final toneLight = days < 0 ? AppColors.dangerLight : AppColors.warnLight;
    final dueText = days < 0
        ? 'Overdue by ${-days} day${-days == 1 ? '' : 's'}'
        : days == 0
            ? 'Due today'
            : 'Due in $days day${days == 1 ? '' : 's'}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: toneLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: tone.withAlpha(80)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: tone,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.schedule_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${milestone.label} · $dueText',
                    style: AppTypography.labelMedium),
                const SizedBox(height: 2),
                Text(milestone.formattedAmount,
                    style: AppTypography.bodySmall),
                const SizedBox(height: 4),
                Text(
                  'Pay via cheque / NEFT — contact your RM',
                  style: AppTypography.bodySmall.copyWith(
                    color: tone,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
