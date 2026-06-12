import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';

class BBLoadingState extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const BBLoadingState({
    this.itemCount = 5,
    this.itemHeight = 80,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.line,
        highlightColor: AppColors.surface,
        child: Container(
          height: itemHeight,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
    );
  }
}
