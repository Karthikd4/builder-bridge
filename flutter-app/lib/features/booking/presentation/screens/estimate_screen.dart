import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/features/booking/data/models/estimate_breakdown.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';

class EstimateScreen extends StatelessWidget {
  final UnitModel unit;
  final String towerName;

  const EstimateScreen({
    super.key,
    required this.unit,
    required this.towerName,
  });

  @override
  Widget build(BuildContext context) {
    final breakdown = EstimateBreakdown.forUnit(unit);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Cost Estimate', style: AppTypography.labelLarge),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _HeaderCard(unit: unit, towerName: towerName),
          const SizedBox(height: AppSpacing.md),
          _BreakdownCard(breakdown: breakdown),
          const SizedBox(height: AppSpacing.md),
          _DiscountNote(breakdown: breakdown),
          const SizedBox(height: AppSpacing.lg),
          BBButton(
            label: 'Express Interest',
            onPressed: () => context.push(
              AppRoutes.expressInterest,
              extra: {'unit': unit, 'towerName': towerName},
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final UnitModel unit;
  final String towerName;
  const _HeaderCard({required this.unit, required this.towerName});

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COST ESTIMATE · FINAL',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.inkFaint,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Unit ${unit.unitNo} · $towerName',
                  style: AppTypography.headlineMedium,
                ),
                const SizedBox(height: 2),
                Text(unit.type, style: AppTypography.bodySmall),
              ],
            ),
          ),
          const BBBadge(label: 'Agreed', status: BBBadgeStatus.ok),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final EstimateBreakdown breakdown;
  const _BreakdownCard({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
            child: Text(
              'BREAKDOWN',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.inkFaint,
                letterSpacing: 0.6,
              ),
            ),
          ),
          ...List.generate(breakdown.items.length, (i) {
            final item = breakdown.items[i];
            final isLast = i == breakdown.items.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: _LineItemRow(item: item),
                ),
                if (!isLast)
                  const Divider(height: 1, color: AppColors.line),
              ],
            );
          }),
          // Total row
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF0EFE9),
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(AppSpacing.radiusMd)),
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    'AGREED TOTAL',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.inkMute,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(
                  breakdown.formattedTotal,
                  style: AppTypography.headlineMedium.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
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

class _LineItemRow extends StatelessWidget {
  final EstimateLineItem item;
  const _LineItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(item.label, style: AppTypography.bodyMedium),
        ),
        Text(
          item.formattedAmount,
          style: AppTypography.labelMedium.copyWith(
            color: item.isDiscount ? AppColors.ok : AppColors.ink,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _DiscountNote extends StatelessWidget {
  final EstimateBreakdown breakdown;
  const _DiscountNote({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final discountItems =
        breakdown.items.where((i) => i.isDiscount).toList();
    if (discountItems.isEmpty) return const SizedBox.shrink();

    final totalDiscount =
        discountItems.fold<int>(0, (sum, i) => sum + i.amount).abs();
    final discountFormatted = EstimateLineItem('', -totalDiscount).formattedAmount;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.okLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.ok.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded,
              size: 18, color: AppColors.ok),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$discountFormatted discount applied',
                  style: AppTypography.labelMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  'Pre-launch incentive · approved by builder.',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
