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
import 'package:builder_bridge/features/payments/data/models/payment_summary.dart';
import 'package:builder_bridge/features/payments/presentation/providers/payments_provider.dart';
import 'package:builder_bridge/features/payments/presentation/widgets/payment_due_banner.dart';
import 'package:builder_bridge/features/payments/presentation/widgets/payment_milestone_row.dart';
import 'package:builder_bridge/features/payments/presentation/widgets/payment_summary_card.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(currentPaymentSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Payments', style: AppTypography.labelLarge),
      ),
      body: summaryAsync.when(
        loading: () => const BBLoadingState(),
        error: (_, __) => BBErrorState(
          message: 'Could not load payment schedule',
          onRetry: () => ref.invalidate(currentPaymentSummaryProvider),
        ),
        data: (summary) {
          if (summary == null) {
            return BBEmptyState(
              icon: Icons.receipt_long_outlined,
              message: 'Express interest in a unit to view your payment schedule.',
              ctaLabel: 'Browse Inventory',
              onCta: () => context.go(AppRoutes.inventory),
            );
          }
          return _PaymentsBody(summary: summary);
        },
      ),
    );
  }
}

class _PaymentsBody extends StatelessWidget {
  final PaymentSummary summary;
  const _PaymentsBody({required this.summary});

  @override
  Widget build(BuildContext context) {
    final nextDue = summary.nextDue;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxl + bottomInset,
      ),
      children: [
        _SectionHeader(
          eyebrow: 'PAYMENT SCHEDULE',
          title: '${summary.totalCount} milestones',
        ),
        const SizedBox(height: AppSpacing.sm),
        _PaymentInfoNote(),
        const SizedBox(height: AppSpacing.md),
        PaymentSummaryCard(summary: summary),
        if (nextDue != null) ...[
          const SizedBox(height: AppSpacing.md),
          PaymentDueBanner(milestone: nextDue),
        ],
        const SizedBox(height: AppSpacing.lg),
        const _SectionHeader(eyebrow: 'ALL MILESTONES'),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: List.generate(summary.milestones.length, (i) {
              final m = summary.milestones[i];
              return PaymentMilestoneRow(
                milestone: m,
                index: i + 1,
                showDivider: i < summary.milestones.length - 1,
                isNextDue: nextDue?.id == m.id,
              );
            }),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _PaymentInfoNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.accent.withAlpha(60)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 18, color: AppColors.accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Payments are processed via cheque or NEFT. '
              'Contact your relationship manager to make a payment.',
              style:
                  AppTypography.bodySmall.copyWith(color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String? title;
  const _SectionHeader({required this.eyebrow, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.inkFaint,
              letterSpacing: 0.6,
            )),
        if (title != null) ...[
          const SizedBox(height: 2),
          Text(title!, style: AppTypography.headlineMedium),
        ],
      ],
    );
  }
}
