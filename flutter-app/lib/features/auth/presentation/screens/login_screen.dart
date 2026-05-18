import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/core/widgets/bb_logo.dart';
import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authProvider.notifier).sendOtp(_phoneController.text.trim());
    if (!mounted) return;
    context.push(AppRoutes.otp, extra: _phoneController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider.select((s) => s.isLoading));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    const BBLogo(size: 28),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Your phone number',
                        style: AppTypography.displayLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                        "We'll send a one-time code to verify your identity.",
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.inkMute)),
                    const SizedBox(height: AppSpacing.xl),
                    _PhoneField(controller: _phoneController),
                    const SizedBox(height: AppSpacing.xl),
                    BBButton(
                      label: 'Send OTP',
                      isLoading: isLoading,
                      onPressed: _sendOtp,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Center(
                      child: Text(
                        '© All data encrypted · IT Act 2000 compliant',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.inkFaint),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.md,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.dashboard),
                child: Text('Skip',
                    style: AppTypography.labelMedium
                        .copyWith(color: AppColors.inkMute)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      autofocus: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      style: AppTypography.bodyLarge,
      decoration: InputDecoration(
        hintText: '98480 12211',
        prefixText: '+91  ',
        prefixStyle: AppTypography.bodyLarge.copyWith(color: AppColors.inkMute),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
      validator: (v) {
        if (v == null || v.trim().length != 10) {
          return 'Enter a valid 10-digit mobile number';
        }
        return null;
      },
    );
  }
}
