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
      data: (booking) => booking == null
          ? const _JourneyPlaceholder()
          : _JourneySteps(booking: booking),
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

  static const _steps = [
    (label: 'Enquiry',    sub: 'Apr 02'),
    (label: 'Site visit', sub: 'Apr 14'),
    (label: 'Estimate',   sub: 'Apr 22'),
    (label: 'Booked',     sub: 'May 03'),
    (label: 'AOS',        sub: 'May 18'),
    (label: 'Reg.',       sub: 'Jul \'26'),
    (label: 'Handover',   sub: 'Q4 \'27'),
  ];

  int get _currentIdx {
    return switch (booking.status) {
      'reserved'  => 3,
      'confirmed' => 4,
      'completed' => 6,
      _           => 3,
    };
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentIdx;
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md, horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.line),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              final stepIdx = i ~/ 2;
              final done = stepIdx < current;
              return SizedBox(
                width: 24,
                child: Container(
                    height: 2,
                    color: done ? AppColors.ok : AppColors.line),
              );
            }
            final stepIdx = i ~/ 2;
            final step = _steps[stepIdx];
            final done = stepIdx < current;
            final isCurrent = stepIdx == current;
            return _StepDot(
              label: step.label,
              sub: step.sub,
              done: done,
              isCurrent: isCurrent,
            );
          }),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final String label;
  final String sub;
  final bool done;
  final bool isCurrent;

  const _StepDot({
    required this.label,
    required this.sub,
    required this.done,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = done
        ? AppColors.ok
        : isCurrent
            ? AppColors.accent
            : AppColors.line;
    final dotBorder = isCurrent && !done
        ? Border.all(color: AppColors.accent, width: 2)
        : null;
    final iconColor = (done || isCurrent) ? Colors.white : AppColors.inkFaint;

    return SizedBox(
      width: 52,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isCurrent && !done ? AppColors.surface : dotColor,
              shape: BoxShape.circle,
              border: dotBorder,
            ),
            child: done
                ? Icon(Icons.check_rounded, size: 14, color: iconColor)
                : isCurrent
                    ? Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall.copyWith(
              fontSize: 10,
              color: done || isCurrent ? AppColors.ink : AppColors.inkFaint,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 9,
              color: AppColors.inkFaint,
            ),
          ),
        ],
      ),
    );
  }
}
