import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/support/data/models/ticket_model.dart';
import 'package:builder_bridge/features/support/presentation/providers/support_provider.dart';
import 'package:builder_bridge/features/support/presentation/widgets/ticket_comment_bubble.dart';
import 'package:builder_bridge/features/support/presentation/widgets/ticket_composer_bar.dart';

class TicketDetailScreen extends ConsumerStatefulWidget {
  final int ticketId;
  const TicketDetailScreen({required this.ticketId, super.key});

  @override
  ConsumerState<TicketDetailScreen> createState() =>
      _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  final _commentController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _commentController.text.trim();
    if (body.isEmpty) return;
    _commentController.clear();
    await ref
        .read(addCommentNotifierProvider.notifier)
        .submit(ticketId: widget.ticketId, body: body);
  }

  @override
  Widget build(BuildContext context) {
    final ticketAsync = ref.watch(ticketByIdProvider(widget.ticketId));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Ticket', style: AppTypography.labelLarge),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ticketAsync.when(
        loading: () => const BBLoadingState(),
        error: (_, __) => BBErrorState(
          message: 'Could not load ticket',
          onRetry: () =>
              ref.invalidate(ticketByIdProvider(widget.ticketId)),
        ),
        data: (ticket) {
          if (ticket == null) {
            return const Center(child: Text('Ticket not found'));
          }
          return Column(
            children: [
              Expanded(child: _Thread(ticket: ticket)),
              TicketComposerBar(
                controller: _commentController,
                focusNode: _focusNode,
                onSend: _send,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Thread extends ConsumerWidget {
  final TicketModel ticket;
  const _Thread({required this.ticket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync =
        ref.watch(ticketCommentsProvider(ticket.id));
    final (label, status) = ticket.statusTag;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(ticket.title,
                        style: AppTypography.headlineSmall),
                  ),
                  BBBadge(label: label, status: status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(ticket.description, style: AppTypography.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('CONVERSATION',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.inkFaint,
              letterSpacing: 0.6,
            )),
        const SizedBox(height: AppSpacing.sm),
        commentsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => Text('Could not load comments',
              style: AppTypography.bodySmall),
          data: (comments) {
            if (comments.isEmpty) {
              return Text('No replies yet — our team will respond soon.',
                  style: AppTypography.bodySmall);
            }
            return Column(
              children: [
                for (final c in comments) ...[
                  TicketCommentBubble(comment: c),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

