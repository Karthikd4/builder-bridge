import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/inventory/data/models/tower_model.dart';
import 'package:builder_bridge/features/inventory/presentation/providers/inventory_provider.dart';

class TowerCard extends ConsumerWidget {
  final TowerModel tower;
  const TowerCard({super.key, required this.tower});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countsAsync = ref.watch(towerStatusCountsProvider(tower.id));

    return GestureDetector(
      onTap: () => context.push(AppRoutes.towerFloor(tower.id)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TowerHeader(tower: tower),
            const Divider(height: 1, color: AppColors.line),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: countsAsync.when(
                loading: () => const SizedBox(height: 28),
                error: (_, __) => const SizedBox(height: 28),
                data: (counts) => _StatusRow(counts: counts),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TowerHeader extends StatelessWidget {
  final TowerModel tower;
  const _TowerHeader({required this.tower});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(Icons.apartment_outlined,
                color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tower.name, style: AppTypography.labelLarge),
                Text('${tower.totalFloors} floors',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.inkMute)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: AppColors.inkFaint, size: 20),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final Map<String, int> counts;
  const _StatusRow({required this.counts});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatusDot(label: 'Available', count: counts['available'] ?? 0, color: AppColors.ok),
        const SizedBox(width: AppSpacing.md),
        _StatusDot(label: 'Reserved', count: counts['reserved'] ?? 0, color: AppColors.warn),
        const SizedBox(width: AppSpacing.md),
        _StatusDot(label: 'Booked', count: counts['booked'] ?? 0, color: AppColors.danger),
        const SizedBox(width: AppSpacing.md),
        _StatusDot(label: 'Sold', count: counts['sold'] ?? 0, color: AppColors.inkFaint),
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatusDot({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text('$count $label',
            style: AppTypography.labelSmall.copyWith(color: AppColors.inkMute)),
      ],
    );
  }
}
