import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/booking/data/models/booking_model.dart';
import 'package:builder_bridge/features/booking/data/models/estimate_breakdown.dart';
import 'package:builder_bridge/features/booking/presentation/providers/booking_provider.dart';
import 'package:builder_bridge/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:builder_bridge/features/dashboard/presentation/widgets/dashboard_hero_fallback.dart';
import 'package:builder_bridge/features/dashboard/presentation/widgets/dashboard_no_booking_card.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';
import 'package:builder_bridge/features/payments/presentation/providers/payments_provider.dart';

class DashboardHeroCard extends ConsumerWidget {
  const DashboardHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(currentUserBookingProvider);
    return bookingAsync.when(
      loading: () => const SizedBox(height: 200, child: BBLoadingState()),
      error: (_, __) => const DashboardNoBookingCard(),
      data: (booking) => booking == null
          ? const DashboardNoBookingCard()
          : _HeroWithBooking(booking: booking),
    );
  }
}

class _HeroWithBooking extends ConsumerWidget {
  final BookingModel booking;
  const _HeroWithBooking({required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitAsync = ref.watch(dashboardUnitProvider(booking.unitId));
    final summaryAsync = ref.watch(currentPaymentSummaryProvider);

    return unitAsync.when(
      loading: () => const SizedBox(height: 200, child: BBLoadingState()),
      error: (_, __) => DashboardHeroFallback(booking: booking),
      data: (unit) {
        if (unit == null) return DashboardHeroFallback(booking: booking);
        final breakdown = EstimateBreakdown.forUnit(unit);
        final paidPaise =
            summaryAsync.valueOrNull?.paidPaise ?? booking.tokenAmount;

        const divider = SizedBox(
            width: 1, height: 36, child: ColoredBox(color: AppColors.line));
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: [
              _HeroHeader(unit: unit),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                        child: DashboardStatCell(
                            label: 'AGREED PRICE',
                            value: breakdown.formattedTotal)),
                    divider,
                    Expanded(
                        child: DashboardStatCell(
                            label: 'PAID', value: _fmtPaise(paidPaise))),
                    divider,
                    Expanded(
                        child: DashboardStatCell(
                            label: 'STATUS', value: _statusLabel(booking.status))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _fmtPaise(int paise) {
    final r = paise / 100;
    if (r >= 10000000) return '₹${(r / 10000000).toStringAsFixed(2)} Cr';
    if (r >= 100000) return '₹${(r / 100000).toStringAsFixed(2)} L';
    return '₹${r.toStringAsFixed(0)}';
  }

  String _statusLabel(String status) => switch (status) {
        'reserved'  => 'Reserved',
        'confirmed' => 'Confirmed',
        'completed' => 'Completed',
        _           => status,
      };
}

class _HeroHeader extends StatelessWidget {
  final UnitModel unit;
  const _HeroHeader({required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: const BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.apartment_outlined,
                size: 36, color: AppColors.accent),
            const SizedBox(height: 6),
            Text('Unit ${unit.unitNo}',
                style: AppTypography.headlineSmall
                    .copyWith(color: AppColors.accent)),
            Text(unit.type,
                style: AppTypography.bodySmall.copyWith(color: AppColors.accent)),
          ],
        ),
      ),
    );
  }
}

class DashboardStatCell extends StatelessWidget {
  final String label;
  final String value;
  const DashboardStatCell({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(fontSize: 9)),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.labelLarge),
      ],
    );
  }
}


