import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';

enum BBBadgeStatus { ok, warn, danger, neutral, info }

class BBBadge extends StatelessWidget {
  final String label;
  final BBBadgeStatus status;

  const BBBadge({
    required this.label,
    this.status = BBBadgeStatus.neutral,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      BBBadgeStatus.ok      => (AppColors.okLight, AppColors.ok),
      BBBadgeStatus.warn    => (AppColors.warnLight, AppColors.warn),
      BBBadgeStatus.danger  => (AppColors.dangerLight, AppColors.danger),
      BBBadgeStatus.info    => (AppColors.accentSoft, AppColors.accent),
      BBBadgeStatus.neutral => (AppColors.bg, AppColors.inkMute),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style: AppTypography.labelSmall.copyWith(color: fg)),
    );
  }
}
