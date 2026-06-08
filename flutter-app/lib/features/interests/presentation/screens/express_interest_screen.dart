import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';
import 'package:builder_bridge/features/interests/presentation/providers/interest_provider.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';

class ExpressInterestScreen extends ConsumerWidget {
  final UnitModel unit;
  final String towerName;

  const ExpressInterestScreen({
    super.key,
    required this.unit,
    required this.towerName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestState = ref.watch(interestNotifierProvider);
    final isLoading = interestState is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Express Interest', style: AppTypography.labelLarge),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _UnitSummaryCard(unit: unit, towerName: towerName),
          const SizedBox(height: AppSpacing.md),
          const _WhatHappensNextCard(),
          const SizedBox(height: AppSpacing.lg),
          BBButton(
            label: isLoading ? 'Submitting…' : 'Confirm Interest',
            isLoading: isLoading,
            onPressed: isLoading
                ? null
                : () async {
                    final user = ref.read(authProvider).user;
                    if (user == null) return;
                    await ref.read(interestNotifierProvider.notifier).submit(
                          unitId: unit.id,
                          userId: int.parse(user.id),
                          unitNo: unit.unitNo,
                        );
                    if (context.mounted &&
                        ref.read(interestNotifierProvider) is! AsyncError) {
                      _showSuccessSheet(context);
                    }
                  },
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Expressing interest does not reserve the unit. '
            'A relationship manager will contact you to discuss next steps.',
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  void _showSuccessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => _InterestSuccessSheet(
        unit: unit,
        towerName: towerName,
        onDone: () {
          Navigator.of(context).pop();
          context.go(AppRoutes.dashboard);
        },
      ),
    );
  }
}

class _UnitSummaryCard extends StatelessWidget {
  final UnitModel unit;
  final String towerName;
  const _UnitSummaryCard({required this.unit, required this.towerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UNIT DETAILS',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.inkFaint,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Unit ${unit.unitNo} · $towerName',
              style: AppTypography.headlineSmall),
          const SizedBox(height: 4),
          Text(
            '${unit.type} · Floor ${unit.floor} · '
            '${unit.areaSqft.toStringAsFixed(0)} sqft',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(unit.formattedPrice,
              style:
                  AppTypography.labelLarge.copyWith(color: AppColors.accent)),
        ],
      ),
    );
  }
}

class _WhatHappensNextCard extends StatelessWidget {
  const _WhatHappensNextCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHAT HAPPENS NEXT',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.inkFaint,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _Step(
              number: '1',
              text: 'Your interest is logged with our team.'),
          const SizedBox(height: AppSpacing.sm),
          const _Step(
              number: '2',
              text:
                  'A relationship manager will call you within 24 hours.'),
          const SizedBox(height: AppSpacing.sm),
          const _Step(
              number: '3',
              text:
                  'Unit gets reserved while you discuss agreement details.'),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String text;
  const _Step({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.accentSoft,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: AppTypography.bodyMedium),
        ),
      ],
    );
  }
}

class _InterestSuccessSheet extends StatelessWidget {
  final UnitModel unit;
  final String towerName;
  final VoidCallback onDone;

  const _InterestSuccessSheet({
    required this.unit,
    required this.towerName,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.okLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded,
                size: 32, color: AppColors.ok),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Interest Registered!', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Unit ${unit.unitNo} · $towerName',
            style:
                AppTypography.bodyMedium.copyWith(color: AppColors.inkMute),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Our team will contact you within 24 hours.',
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          BBButton(
            label: 'Go to Dashboard',
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}
