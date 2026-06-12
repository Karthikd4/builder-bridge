import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/utils/format_utils.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/core/widgets/bb_card.dart';
import 'package:builder_bridge/core/widgets/bb_empty_state.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/admin/presentation/providers/admin_providers.dart';

class AdminTicketsScreen extends ConsumerStatefulWidget {
  const AdminTicketsScreen({super.key});

  @override
  ConsumerState<AdminTicketsScreen> createState() =>
      _AdminTicketsScreenState();
}

class _AdminTicketsScreenState extends ConsumerState<AdminTicketsScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final ticketsAsync = ref.watch(adminTicketsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Support Tickets', style: AppTypography.labelLarge),
      ),
      body: Column(
        children: [
          _FilterChips(
            selected: _filter,
            onChanged: (f) => setState(() => _filter = f),
          ),
          Expanded(
            child: ticketsAsync.when(
              loading: () => const BBLoadingState(),
              error: (_, __) =>
                  const BBErrorState(message: 'Could not load tickets'),
              data: (tickets) {
                final filtered = _filter == 'all'
                    ? tickets
                    : tickets
                        .where((t) => t.ticket.status == _filter)
                        .toList();
                if (filtered.isEmpty) {
                  return const BBEmptyState(
                    icon: Icons.confirmation_number_outlined,
                    message: 'No tickets found.',
                  );
                }
                return _TicketList(tickets: filtered);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _FilterChips({required this.selected, required this.onChanged});

  static const _filters = [
    ('all', 'All'),
    ('open', 'Open'),
    ('in_progress', 'In Progress'),
    ('resolved', 'Resolved'),
    ('closed', 'Closed'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: _filters
            .map((f) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(f.$2, style: AppTypography.labelSmall),
                    selected: selected == f.$1,
                    onSelected: (_) => onChanged(f.$1),
                    selectedColor: AppColors.accentSoft,
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.line),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  final List<AdminTicket> tickets;
  const _TicketList({required this.tickets});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: tickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) => _TicketCard(item: tickets[i]),
    );
  }
}

class _TicketCard extends ConsumerWidget {
  final AdminTicket item;
  const _TicketCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticket = item.ticket;
    final (statusLabel, statusBadge) = ticket.statusTag;
    final createdDate = DateTime.tryParse(ticket.createdAt);
    final dateStr =
        createdDate != null ? FormatUtils.formatDate(createdDate) : '';

    return BBCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ticket.title, style: AppTypography.labelLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      ticket.description,
                      style: AppTypography.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              BBBadge(label: statusLabel, status: statusBadge),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 16, color: AppColors.inkMute),
              const SizedBox(width: AppSpacing.xs),
              Text(item.customerName, style: AppTypography.bodySmall),
              const SizedBox(width: AppSpacing.md),
              const Icon(Icons.phone_outlined,
                  size: 16, color: AppColors.inkMute),
              const SizedBox(width: AppSpacing.xs),
              Text(item.customerPhone, style: AppTypography.bodySmall),
              const Spacer(),
              Text(dateStr,
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.inkFaint)),
              const SizedBox(width: AppSpacing.sm),
              _StatusMenu(
                currentStatus: ticket.status,
                onChanged: (status) => ref
                    .read(adminTicketNotifierProvider.notifier)
                    .updateStatus(ticket.id, status),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusMenu extends StatelessWidget {
  final String currentStatus;
  final ValueChanged<String> onChanged;

  const _StatusMenu(
      {required this.currentStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20, color: AppColors.inkMute),
      tooltip: 'Change status',
      onSelected: onChanged,
      itemBuilder: (_) => [
        if (currentStatus != 'in_progress')
          const PopupMenuItem(
              value: 'in_progress', child: Text('Mark In Progress')),
        if (currentStatus != 'resolved')
          const PopupMenuItem(
              value: 'resolved', child: Text('Mark Resolved')),
        if (currentStatus != 'closed')
          const PopupMenuItem(
              value: 'closed', child: Text('Close Ticket')),
        if (currentStatus != 'open')
          const PopupMenuItem(value: 'open', child: Text('Reopen')),
      ],
    );
  }
}
