import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/core/widgets/bb_empty_state.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/admin/presentation/providers/admin_providers.dart';
import 'package:builder_bridge/core/utils/format_utils.dart';
import 'package:builder_bridge/features/interests/data/models/interest_model.dart';
import 'package:builder_bridge/features/interests/data/repositories/interest_repository.dart';
import 'package:builder_bridge/features/interests/presentation/providers/interest_provider.dart';

class AdminInterestsScreen extends ConsumerWidget {
  const AdminInterestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestsAsync = ref.watch(allInterestsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Expressed Interests', style: AppTypography.labelLarge),
      ),
      body: interestsAsync.when(
        loading: () => const BBLoadingState(),
        error: (err, st) => BBErrorState(
          message: 'Error: $err',
          onRetry: () => ref.invalidate(allInterestsProvider),
        ),
        data: (interests) {
          if (interests.isEmpty) {
            return const BBEmptyState(
              icon: Icons.star_border_rounded,
              message: 'No interests expressed yet.',
            );
          }
          return _InterestsList(interests: interests);
        },
      ),
    );
  }
}

class _InterestsList extends ConsumerWidget {
  final List<InterestModel> interests;
  const _InterestsList({required this.interests});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: interests.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) => _InterestCard(
        interest: interests[i],
        onMarkContacted: () => ref
            .read(adminInterestNotifierProvider.notifier)
            .markContacted(interests[i].id),
      ),
    );
  }
}

class _InterestCard extends StatelessWidget {
  final InterestModel interest;
  final VoidCallback onMarkContacted;

  const _InterestCard({
    required this.interest,
    required this.onMarkContacted,
  });

  @override
  Widget build(BuildContext context) {
    final isNew = interest.status == InterestStatus.newInterest;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isNew ? AppColors.accent.withAlpha(80) : AppColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interest.userName ?? 'Unknown Buyer',
                      style: AppTypography.labelLarge,
                    ),
                    if (interest.phone != null) ...[
                      const SizedBox(height: 2),
                      Text(interest.phone!,
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.inkMute)),
                    ],
                    if (interest.email != null)
                      Text(interest.email!,
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.inkMute)),
                  ],
                ),
              ),
              BBBadge(
                label: isNew ? 'New' : 'Contacted',
                status: isNew ? BBBadgeStatus.warn : BBBadgeStatus.ok,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.apartment_outlined,
                  size: 14, color: AppColors.inkMute),
              const SizedBox(width: 4),
              Text(
                _unitLabel,
                style:
                    AppTypography.bodySmall.copyWith(color: AppColors.inkMute),
              ),
              const Spacer(),
              Text(
                _formatDate(interest.createdAt),
                style:
                    AppTypography.bodySmall.copyWith(color: AppColors.inkFaint),
              ),
            ],
          ),
          if (isNew) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onMarkContacted,
                icon: const Icon(Icons.phone_outlined, size: 16),
                label: const Text('Mark as Contacted'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: BorderSide(color: AppColors.accent.withAlpha(120)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String get _unitLabel {
    final parts = <String>[];
    if (interest.towerName != null) parts.add(interest.towerName!);
    if (interest.unitNo != null) parts.add('Unit ${interest.unitNo}');
    if (interest.unitFloor != null) parts.add('Floor ${interest.unitFloor}');
    if (interest.unitType != null) parts.add(interest.unitType!);
    return parts.isEmpty ? 'Unit #${interest.unitId}' : parts.join(' · ');
  }

  String _formatDate(String iso) => FormatUtils.formatDate(DateTime.parse(iso));
}
