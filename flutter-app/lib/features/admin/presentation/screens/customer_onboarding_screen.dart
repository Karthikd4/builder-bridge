import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/core/widgets/bb_card.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/admin/presentation/providers/admin_providers.dart';
import 'package:builder_bridge/features/auth/data/repositories/user_repository.dart';
import 'package:builder_bridge/features/booking/data/models/estimate_breakdown.dart';
import 'package:builder_bridge/features/booking/data/repositories/booking_repository.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';

class CustomerOnboardingScreen extends ConsumerStatefulWidget {
  const CustomerOnboardingScreen({super.key});

  @override
  ConsumerState<CustomerOnboardingScreen> createState() =>
      _CustomerOnboardingScreenState();
}

class _CustomerOnboardingScreenState
    extends ConsumerState<CustomerOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  UnitModel? _selectedUnit;
  bool _isSubmitting = false;
  String? _successMessage;

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

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Onboard Customer', style: AppTypography.labelLarge),
      ),
      body: unitsAsync.when(
        loading: () => const BBLoadingState(),
        error: (_, __) =>
            const BBErrorState(message: 'Could not load units'),
        data: (units) {
          final available =
              units.where((u) => u.status == 'available').toList();
          return _buildForm(available);
        },
      ),
    );
  }

  Widget _buildForm(List<UnitModel> availableUnits) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_successMessage != null) ...[
              _SuccessBanner(message: _successMessage!),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text('Customer Details', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            const _FieldLabel('FULL NAME'),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: 'e.g. Rahul Sharma'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            const _FieldLabel('PHONE NUMBER'),
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
            const _FieldLabel('EMAIL (OPTIONAL)'),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'e.g. rahul@example.com'),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Assign Unit', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            const _FieldLabel('AVAILABLE UNIT'),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<UnitModel>(
              value: _selectedUnit,
              decoration:
                  const InputDecoration(hintText: 'Select a unit'),
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
              validator: (v) => v == null ? 'Please select a unit' : null,
            ),
            if (availableUnits.isEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No available units. Update unit availability first.',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.danger),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            BBButton(
              label: _isSubmitting ? 'Onboarding…' : 'Onboard Customer',
              isLoading: _isSubmitting,
              onPressed:
                  (_isSubmitting || availableUnits.isEmpty) ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    try {
      final userId = await UserRepository().createUser(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
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

      if (mounted) {
        setState(() {
          _successMessage =
              '${_nameCtrl.text.trim()} has been onboarded for Unit ${unit.unitNo}.';
          _nameCtrl.clear();
          _phoneCtrl.clear();
          _emailCtrl.clear();
          _selectedUnit = null;
          _isSubmitting = false;
        });
      }
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.labelSmall.copyWith(
        color: AppColors.inkFaint,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  final String message;
  const _SuccessBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return BBCard(
      backgroundColor: AppColors.okLight,
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded,
              color: AppColors.ok, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(message,
                style:
                    AppTypography.bodyMedium.copyWith(color: AppColors.ink)),
          ),
        ],
      ),
    );
  }
}
