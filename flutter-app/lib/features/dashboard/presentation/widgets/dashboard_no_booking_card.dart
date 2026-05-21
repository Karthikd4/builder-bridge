import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';

class DashboardNoBookingCard extends StatelessWidget {
  const DashboardNoBookingCard({super.key});

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
          const Icon(Icons.search_rounded, size: 40, color: AppColors.accent),
          const SizedBox(height: AppSpacing.md),
          Text("You haven't booked a unit yet.",
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Browse available units in your project.',
              style: AppTypography.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          BBButton(
            label: 'Browse Inventory',
            fullWidth: false,
            onPressed: () => context.go(AppRoutes.inventory),
          ),
        ],
      ),
    );
  }
}
