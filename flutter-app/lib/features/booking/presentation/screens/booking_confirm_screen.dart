import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/utils/format_utils.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';
import 'package:builder_bridge/features/booking/data/models/estimate_breakdown.dart';
import 'package:builder_bridge/features/booking/presentation/providers/booking_provider.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';
import 'package:builder_bridge/features/documents/presentation/providers/documents_provider.dart';
import 'package:builder_bridge/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:builder_bridge/features/payments/presentation/providers/payments_provider.dart';

class BookingConfirmScreen extends ConsumerWidget {
  final UnitModel unit;
  final String towerName;

  const BookingConfirmScreen({
    super.key,
    required this.unit,
    required this.towerName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdown = EstimateBreakdown.forUnit(unit);
    final bookingState = ref.watch(bookingNotifierProvider);
    final isLoading = bookingState is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Confirm Booking', style: AppTypography.labelLarge),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _UnitSummaryCard(unit: unit, towerName: towerName),
          const SizedBox(height: AppSpacing.md),
          _TokenCard(breakdown: breakdown),
          const SizedBox(height: AppSpacing.md),
          _PaymentInfoCard(breakdown: breakdown),
          const SizedBox(height: AppSpacing.lg),
          BBButton(
            label: isLoading ? 'Confirming…' : 'Confirm & Pay Token',
            isLoading: isLoading,
            onPressed: isLoading
                ? null
                : () async {
                    final user = ref.read(authProvider).user;
                    if (user == null) return;
                    try {
                      await ref.read(bookingNotifierProvider.notifier).confirm(
                            unitId: unit.id,
                            userId: int.parse(user.id),
                            tokenAmount: breakdown.suggestedToken,
                            totalPaise: breakdown.total,
                            unitNo: unit.unitNo,
                          );
                      ref.invalidate(currentPaymentSummaryProvider);
                      ref.invalidate(currentBookingDocumentsProvider);
                      ref.invalidate(userNotificationsProvider);
                      ref.invalidate(unreadNotificationCountProvider);
                      if (context.mounted) {
                        _showSuccessSheet(context);
                      }
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking failed. Please try again.'),
                            backgroundColor: AppColors.danger,
                          ),
                        );
                      }
                    }
                  },
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'By confirming, you agree to pay the token amount. '
            'This reserves the unit for 7 days pending agreement.',
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
      builder: (_) => _BookingSuccessSheet(
        unit: unit,
        towerName: towerName,
        onDone: () {
          Navigator.of(context).pop(); // close sheet
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
        ],
      ),
    );
  }
}

class _TokenCard extends StatelessWidget {
  final EstimateBreakdown breakdown;
  const _TokenCard({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final tokenRupees = breakdown.suggestedToken / 100;
    final tokenFormatted = tokenRupees >= 100000
        ? '₹${(tokenRupees / 100000).toStringAsFixed(2)} L'
        : '₹${tokenRupees.toStringAsFixed(0)}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.accent.withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline_rounded,
              size: 28, color: AppColors.accent),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking Token (5%)',
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.accent)),
                const SizedBox(height: 2),
                Text('Refundable within 7 days',
                    style:
                        AppTypography.bodySmall.copyWith(color: AppColors.inkMute)),
              ],
            ),
          ),
          Text(
            tokenFormatted,
            style: AppTypography.headlineSmall.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

class _PaymentInfoCard extends StatelessWidget {
  final EstimateBreakdown breakdown;
  const _PaymentInfoCard({required this.breakdown});

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
        children: [
          _SummaryRow(
            label: 'Agreed Total',
            value: breakdown.formattedTotal,
            bold: false,
          ),
          const Divider(height: AppSpacing.lg, color: AppColors.line),
          _SummaryRow(
            label: 'Token Due Today',
            value: _formatPaise(breakdown.suggestedToken),
            bold: true,
          ),
        ],
      ),
    );
  }

  String _formatPaise(int paise) => FormatUtils.formatPaise(paise);
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow(
      {required this.label, required this.value, required this.bold});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: bold
                ? AppTypography.labelMedium
                : AppTypography.bodyMedium
                    .copyWith(color: AppColors.inkMute),
          ),
        ),
        Text(
          value,
          style: bold
              ? AppTypography.labelLarge
              : AppTypography.bodyMedium,
        ),
      ],
    );
  }
}

class _BookingSuccessSheet extends StatelessWidget {
  final UnitModel unit;
  final String towerName;
  final VoidCallback onDone;

  const _BookingSuccessSheet({
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
            child:
                const Icon(Icons.check_rounded, size: 32, color: AppColors.ok),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Booking Confirmed!', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Unit ${unit.unitNo} · $towerName has been reserved.',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.inkMute),
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
