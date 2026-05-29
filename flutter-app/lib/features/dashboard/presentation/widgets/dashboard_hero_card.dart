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
        final summary = summaryAsync.valueOrNull;
        final paidPaise = summary?.paidPaise ?? booking.tokenAmount;
        final totalPaise = summary?.totalPaise ?? breakdown.total;
        final paidPct = totalPaise > 0
            ? '${(paidPaise / totalPaise * 100).round()}%'
            : _fmtPaise(paidPaise);
        final possessionLabel = summary?.possession?.dueDate != null
            ? _fmtPossession(summary!.possession!.dueDate)
            : 'Dec \'27';

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
                            label: 'PAID',
                            value: paidPct,
                            sub: _fmtPaise(paidPaise))),
                    divider,
                    Expanded(
                        child: DashboardStatCell(
                            label: 'POSSESSION',
                            value: possessionLabel)),
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

  String _fmtPossession(String isoDate) {
    final dt = DateTime.parse(isoDate);
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month - 1]} \'${dt.year.toString().substring(2)}';
  }
}

class _HeroHeader extends StatelessWidget {
  final UnitModel unit;
  const _HeroHeader({required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent, AppColors.accentDark],
        ),
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: Stack(
        children: [
          // Decorative building motif
          const Positioned(
            right: -12,
            top: -10,
            child: Opacity(
              opacity: 0.14,
              child: Icon(Icons.domain_rounded,
                  size: 180, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // RERA chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(46),
                        borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_outlined,
                              size: 11, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'RERA · P02400006789',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'VUE CONSTRUCTIONS',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white.withAlpha(204),
                        fontSize: 10,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'THE VUE RESIDENCES',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white.withAlpha(191),
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Unit ${unit.unitNo}',
                      style: AppTypography.headlineMedium.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        letterSpacing: -0.5,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      unit.type,
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white.withAlpha(216),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Floor ${unit.floor} · Block A · Puppalaguda, Hyderabad',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardStatCell extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  const DashboardStatCell(
      {required this.label, required this.value, this.sub, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: AppTypography.labelSmall.copyWith(
                fontSize: 9,
                color: AppColors.inkFaint,
                letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.labelLarge),
        if (sub != null)
          Text(sub!,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.inkMute, fontSize: 11)),
      ],
    );
  }
}


