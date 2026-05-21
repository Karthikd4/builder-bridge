import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/booking/data/models/booking_model.dart';
import 'package:builder_bridge/features/booking/presentation/providers/booking_provider.dart';

class DashboardJourneyCard extends ConsumerWidget {
  const DashboardJourneyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(currentUserBookingProvider);
    return bookingAsync.when(
      loading: () => const SizedBox(height: 72, child: BBLoadingState()),
      error: (_, __) => const _JourneyPlaceholder(),
      data: (booking) =>
          booking == null ? const _JourneyPlaceholder() : _JourneySteps(booking: booking),
    );
  }
}

class _JourneyPlaceholder extends StatelessWidget {
  const _JourneyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.line),
      ),
      child: Center(
        child: Text('Book a unit to see your journey',
            style:
                AppTypography.bodySmall.copyWith(color: AppColors.inkFaint)),
      ),
    );
  }
}

class _JourneySteps extends StatelessWidget {
  final BookingModel booking;
  const _JourneySteps({required this.booking});

  @override
  Widget build(BuildContext context) {
    final status = booking.status;
    final confirmedOrLater = status == 'confirmed' || status == 'completed';
    final steps = [
      (label: 'Interest', done: true),
      (label: 'Token', done: booking.tokenAmount > 0),
      (label: 'Agreement', done: confirmedOrLater),
      (label: 'Possession', done: status == 'completed'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                color: steps[i ~/ 2].done ? AppColors.ok : AppColors.line,
              ),
            );
          }
          final step = steps[i ~/ 2];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: step.done ? AppColors.ok : AppColors.line,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step.done ? Icons.check_rounded : Icons.circle_outlined,
                  size: 14,
                  color: step.done ? Colors.white : AppColors.inkFaint,
                ),
              ),
              const SizedBox(height: 4),
              Text(step.label,
                  style: AppTypography.labelSmall.copyWith(fontSize: 10)),
            ],
          );
        }),
      ),
    );
  }
}
