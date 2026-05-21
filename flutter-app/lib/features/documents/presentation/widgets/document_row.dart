import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/features/documents/data/models/document_model.dart';

class DocumentRow extends StatelessWidget {
  final DocumentModel document;
  final bool showDivider;
  final VoidCallback? onTap;

  const DocumentRow({
    required this.document,
    required this.showDivider,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tag = _statusTag(document.status);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                _DocIcon(document: document),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.name,
                        style: AppTypography.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${document.type} · ${_formatDate(document.createdDateTime)}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (tag != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  BBBadge(label: tag.$1, status: tag.$2),
                ],
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.line),
      ],
    );
  }

  (String, BBBadgeStatus)? _statusTag(String status) => switch (status) {
        'signed'       => ('Signed', BBBadgeStatus.ok),
        'under_review' => ('Under review', BBBadgeStatus.warn),
        'new'          => ('New', BBBadgeStatus.info),
        _              => null,
      };

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }
}

class _DocIcon extends StatelessWidget {
  final DocumentModel document;
  const _DocIcon({required this.document});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 38,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.bg,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Icon(document.categoryIcon,
              size: 18, color: AppColors.inkMute),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              document.extension.substring(
                  0, document.extension.length > 3 ? 3 : document.extension.length),
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
