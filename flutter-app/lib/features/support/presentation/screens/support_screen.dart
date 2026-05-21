import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_empty_state.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/support/data/models/ticket_model.dart';
import 'package:builder_bridge/features/support/presentation/providers/support_provider.dart';
import 'package:builder_bridge/features/support/presentation/widgets/ticket_row.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(userTicketsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Support', style: AppTypography.labelLarge),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        onPressed: () => context.push(AppRoutes.supportNew),
        icon: const Icon(Icons.add),
        label: const Text('New Ticket'),
      ),
      body: ticketsAsync.when(
        loading: () => const BBLoadingState(),
        error: (_, __) => BBErrorState(
          message: 'Could not load tickets',
          onRetry: () => ref.invalidate(userTicketsProvider),
        ),
        data: (tickets) {
          if (tickets.isEmpty) {
            return BBEmptyState(
              icon: Icons.support_agent_outlined,
              message: 'No support tickets yet.\nNeed help? Open a new ticket.',
              ctaLabel: 'New Ticket',
              onCta: () => context.push(AppRoutes.supportNew),
            );
          }
          return _TicketsList(tickets: tickets);
        },
      ),
    );
  }
}

class _TicketsList extends StatelessWidget {
  final List<TicketModel> tickets;
  const _TicketsList({required this.tickets});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md, AppSpacing.md,
        AppSpacing.md, AppSpacing.xxl + bottomInset + 60,
      ),
      children: [
        _Header(total: tickets.length),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: List.generate(tickets.length, (i) {
              final t = tickets[i];
              return TicketRow(
                ticket: t,
                showDivider: i < tickets.length - 1,
                onTap: () => context.push(AppRoutes.supportDetail(t.id)),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final int total;
  const _Header({required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SUPPORT TICKETS',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.inkFaint,
              letterSpacing: 0.6,
            )),
        const SizedBox(height: 2),
        Text('$total ticket${total == 1 ? '' : 's'}',
            style: AppTypography.headlineMedium),
      ],
    );
  }
}
