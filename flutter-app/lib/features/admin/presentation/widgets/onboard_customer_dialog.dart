import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/features/admin/presentation/providers/admin_providers.dart';
import 'package:builder_bridge/features/auth/data/repositories/user_repository.dart';
import 'package:builder_bridge/features/booking/data/models/estimate_breakdown.dart';
import 'package:builder_bridge/features/booking/data/repositories/booking_repository.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';

class OnboardCustomerDialog extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;
  const OnboardCustomerDialog({required this.onSuccess, super.key});

  @override
  ConsumerState<OnboardCustomerDialog> createState() =>
      _OnboardCustomerDialogState();
}

class _OnboardCustomerDialogState
    extends ConsumerState<OnboardCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  UnitModel? _selectedUnit;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(allUnitsProvider);

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Onboard Customer', style: AppTypography.headlineSmall),
      content: SizedBox(
        width: 440,
        child: unitsAsync.when(
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const Text('Could not load units'),
          data: (units) {
            final available =
                units.where((u) => u.status == 'available').toList();
            return _buildForm(available);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: Text('Cancel',
              style: AppTypography.labelMedium
                  .copyWith(color: AppColors.inkMute)),
        ),
        BBButton(
          label: _isSubmitting ? 'Onboarding…' : 'Onboard',
          isLoading: _isSubmitting,
          fullWidth: false,
          onPressed: _isSubmitting ? null : _submit,
        ),
      ],
    );
  }

  Widget _buildForm(List<UnitModel> availableUnits) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('FULL NAME'),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _nameCtrl,
              decoration:
                  const InputDecoration(hintText: 'e.g. Rahul Sharma'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _label('PHONE NUMBER'),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(hintText: 'e.g. 9876543210'),
              validator: (v) => (v == null || v.trim().length < 10)
                  ? 'Enter valid phone'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _label('EMAIL (OPTIONAL)'),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'e.g. rahul@example.com'),
            ),
            const SizedBox(height: AppSpacing.md),
            _label('AVAILABLE UNIT'),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<UnitModel>(
              value: _selectedUnit,
              decoration:
                  const InputDecoration(hintText: 'Select a unit'),
              isExpanded: true,
              items: availableUnits
                  .map((u) => DropdownMenuItem(
                        value: u,
                        child: Text(
                          'Unit ${u.unitNo} · ${u.type} · Floor ${u.floor} · ${u.formattedPrice}',
                          style: AppTypography.bodyMedium,
                        ),
                      ))
                  .toList(),
              onChanged: (u) => setState(() => _selectedUnit = u),
              validator: (v) =>
                  v == null ? 'Please select a unit' : null,
            ),
            if (availableUnits.isEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No available units.',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.danger),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.inkFaint,
          letterSpacing: 0.6,
        ),
      );

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    try {
      final userId = await UserRepository().findOrCreateUser(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email:
            _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      );

      final unit = _selectedUnit!;
      final breakdown = EstimateBreakdown.forUnit(unit);

      await BookingRepository().createBooking(
        unitId: unit.id,
        userId: userId,
        tokenAmount: breakdown.suggestedToken,
        totalPaise: breakdown.total,
        unitNo: unit.unitNo,
      );

      ref.invalidate(allUnitsProvider);
      ref.invalidate(adminDashboardStatsProvider);
      widget.onSuccess();

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }
}
