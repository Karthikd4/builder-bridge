import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/features/booking/data/models/booking_model.dart';
import 'package:builder_bridge/features/booking/presentation/providers/booking_provider.dart';
import 'package:builder_bridge/features/interests/data/models/interest_model.dart';
import 'package:builder_bridge/features/interests/presentation/providers/interest_provider.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';

class UnitDetailSheet extends ConsumerWidget {
  final UnitModel unit;
  final String towerName;

  const UnitDetailSheet({
    super.key,
    required this.unit,
    required this.towerName,
  });

  static void show(BuildContext context, UnitModel unit, String towerName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UnitDetailSheet(unit: unit, towerName: towerName),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final existingBookingAsync = ref.watch(currentUserBookingProvider);
    final existingInterestAsync = ref.watch(currentUserInterestProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  BBBadge(label: _statusLabel, status: _badgeStatus),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Unit ${unit.unitNo} · $towerName',
                      style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Floor ${unit.floor}',
                      style: AppTypography.bodySmall),
                  const SizedBox(height: AppSpacing.lg),
                  _InfoGrid(unit: unit),
                  const SizedBox(height: AppSpacing.lg),
                  _ActionArea(
                    unit: unit,
                    towerName: towerName,
                    existingBooking: existingBookingAsync.valueOrNull,
                    existingInterest: existingInterestAsync.valueOrNull,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _statusLabel => switch (unit.status) {
        'available' => 'Available',
        'reserved'  => 'Reserved',
        'booked'    => 'Booked',
        _           => 'Sold',
      };

  BBBadgeStatus get _badgeStatus => switch (unit.status) {
        'available' => BBBadgeStatus.ok,
        'reserved'  => BBBadgeStatus.warn,
        'booked'    => BBBadgeStatus.danger,
        _           => BBBadgeStatus.neutral,
      };
}

class _ActionArea extends StatelessWidget {
  final UnitModel unit;
  final String towerName;
  final BookingModel? existingBooking;
  final InterestModel? existingInterest;

  const _ActionArea({
    required this.unit,
    required this.towerName,
    required this.existingBooking,
    required this.existingInterest,
  });

  @override
  Widget build(BuildContext context) {
    // 1. User already expressed interest → prevent duplicate.
    if (existingInterest != null) {
      return _LockedBanner(
        message: 'You\'ve already expressed interest in a unit. '
            'Our team will be in touch soon.',
        onView: () {
          Navigator.of(context).pop();
          context.go(AppRoutes.dashboard);
        },
      );
    }

    // 2. User has an active booking (seeded/admin-created) → lock.
    if (existingBooking != null) {
      final isThisUnit = existingBooking!.unitId == unit.id;
      return _LockedBanner(
        message: isThisUnit
            ? 'This is your booked unit.'
            : 'You already have an active booking.',
        onView: () {
          Navigator.of(context).pop();
          context.go(AppRoutes.dashboard);
        },
      );
    }

    // 3. Unit not available → disabled button with status label.
    if (!unit.isAvailable) {
      return BBButton(
        label: _unavailableLabel,
        onPressed: null,
        variant: BBButtonVariant.secondary,
      );
    }

    // 4. User free, unit available → express interest flow.
    return BBButton(
      label: 'Express Interest',
      onPressed: () {
        Navigator.of(context).pop();
        context.push(
          AppRoutes.estimate,
          extra: {'unit': unit, 'towerName': towerName},
        );
      },
    );
  }

  String get _unavailableLabel => switch (unit.status) {
        'reserved' => 'Unit Reserved',
        'booked'   => 'Unit Booked',
        _          => 'Unit Sold',
      };
}

class _LockedBanner extends StatelessWidget {
  final String message;
  final VoidCallback onView;
  const _LockedBanner({required this.message, required this.onView});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.accentSoft,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.accent.withAlpha(60)),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline_rounded,
                  size: 20, color: AppColors.accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(message,
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.ink)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        BBButton(
          label: 'View Dashboard',
          variant: BBButtonVariant.secondary,
          onPressed: onView,
        ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final UnitModel unit;
  const _InfoGrid({required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _InfoCell(label: 'TYPE', value: unit.type),
            _InfoCell(label: 'CARPET AREA',
                value: '${unit.areaSqft.toStringAsFixed(0)} sqft'),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _InfoCell(label: 'FLOOR', value: 'Floor ${unit.floor}'),
            _InfoCell(label: 'ALL-IN PRICE', value: unit.formattedPrice),
          ],
        ),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTypography.labelSmall.copyWith(
                  color: AppColors.inkFaint, fontSize: 10, letterSpacing: 0.6)),
          const SizedBox(height: 2),
          Text(value, style: AppTypography.labelLarge),
        ],
      ),
    );
  }
}
