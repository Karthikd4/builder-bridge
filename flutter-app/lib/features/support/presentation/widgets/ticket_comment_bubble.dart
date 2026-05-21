import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/support/data/models/ticket_comment_model.dart';

class TicketCommentBubble extends StatelessWidget {
  final TicketCommentModel comment;
  const TicketCommentBubble({required this.comment, super.key});

  @override
  Widget build(BuildContext context) {
    final isYou = comment.isYou;
    final align = isYou ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isYou ? AppColors.accent : AppColors.surface;
    final textColor = isYou ? Colors.white : AppColors.ink;

    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          comment.author,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.inkFaint,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: isYou ? null : Border.all(color: AppColors.line),
          ),
          child: Text(
            comment.body,
            style: AppTypography.bodyMedium.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}
