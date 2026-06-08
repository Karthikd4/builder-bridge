import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/core/utils/format_utils.dart';
import 'package:builder_bridge/features/support/data/models/ticket_model.dart';

class TicketRow extends StatelessWidget {
  final TicketModel ticket;
  final bool showDivider;
  final VoidCallback? onTap;

  const TicketRow({
    required this.ticket,
    required this.showDivider,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (label, status) = ticket.statusTag;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(ticket.title,
                          style: AppTypography.labelLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    BBBadge(label: label, status: status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ticket.description,
                  style: AppTypography.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(ticket.createdDateTime),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.inkFaint,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.line),
      ],
    );
  }

  String _formatDate(DateTime d) => FormatUtils.formatDate(d);
}
