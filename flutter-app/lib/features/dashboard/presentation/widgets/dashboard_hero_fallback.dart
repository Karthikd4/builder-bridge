import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/booking/data/models/booking_model.dart';

class DashboardHeroFallback extends StatelessWidget {
  final BookingModel booking;
  const DashboardHeroFallback({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(children: [
        const Icon(Icons.apartment_outlined, color: AppColors.accent, size: 32),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text('Unit #${booking.unitId} · ${booking.status}',
              style: AppTypography.labelLarge),
        ),
      ]),
    );
  }
}
