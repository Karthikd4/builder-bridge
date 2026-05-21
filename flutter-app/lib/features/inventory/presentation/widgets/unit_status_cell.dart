import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';

class UnitStatusCell extends StatelessWidget {
  final UnitModel unit;
  final VoidCallback onTap;

  const UnitStatusCell({super.key, required this.unit, required this.onTap});

  static Color colorFor(String status) => switch (status) {
        'available' => AppColors.okLight,
        'reserved'  => AppColors.warnLight,
        'booked'    => AppColors.dangerLight,
        _           => const Color(0xFFE5E7EB),
      };

  static Color borderFor(String status) => switch (status) {
        'available' => AppColors.ok,
        'reserved'  => AppColors.warn,
        'booked'    => AppColors.danger,
        _           => AppColors.inkFaint,
      };

  @override
  Widget build(BuildContext context) {
    final bg = colorFor(unit.status);
    final border = borderFor(unit.status);
    final canTap = unit.isAvailable || unit.isReserved;

    return GestureDetector(
      onTap: canTap ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: border, width: 1),
        ),
        child: Center(
          child: Text(
            unit.unitNo,
            style: AppTypography.labelSmall.copyWith(
              color: canTap ? AppColors.ink : AppColors.inkFaint,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
