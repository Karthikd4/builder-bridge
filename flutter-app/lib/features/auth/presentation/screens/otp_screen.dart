import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/core/widgets/bb_logo.dart';
import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';
import 'package:builder_bridge/features/auth/presentation/widgets/otp_input_row.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpScreen({required this.phone, super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String _otp = '';
  int _resendSeconds = 30;
  Timer? _timer;

  bool get _canResend => _resendSeconds == 0;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        t.cancel();
      }
    });
  }

  Future<void> _verify() async {
    if (_otp.length != 6) return;
    await ref.read(authProvider.notifier).verifyOtp(widget.phone, _otp);
  }

  Future<void> _resend() async {
    setState(() => _resendSeconds = 30);
    await ref.read(authProvider.notifier).sendOtp(widget.phone);
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isAuthenticated && mounted) {
        context.go(AppRoutes.authSuccess);
      } else if (next.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(next.error!),
              backgroundColor: AppColors.danger),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    final isLoading = ref.watch(authProvider).isLoading;
    final otpComplete = _otp.length == 6;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  const BBLogo(size: 28),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Enter the 6-digit code',
                      style: AppTypography.displayLarge),
                  const SizedBox(height: AppSpacing.sm),
                  // Inline "Sent to · Resend in Xs" — matches design
                  _ResendSubtitle(
                    phone: widget.phone,
                    seconds: _resendSeconds,
                    canResend: _canResend,
                    onResend: _resend,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  OtpInputRow(
                    onChange: (otp) => setState(() => _otp = otp),
                    onCompleted: (otp) => setState(() => _otp = otp),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BBButton(
                    label: 'Verify',
                    isLoading: isLoading,
                    onPressed: otpComplete && !isLoading ? _verify : null,
                  ),
                ],
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

class _ResendSubtitle extends StatelessWidget {
  final String phone;
  final int seconds;
  final bool canResend;
  final VoidCallback onResend;

  const _ResendSubtitle({
    required this.phone,
    required this.seconds,
    required this.canResend,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTypography.bodyMedium.copyWith(color: AppColors.inkMute),
        children: [
          const TextSpan(text: 'Sent to +91 '),
          TextSpan(
            text: phone,
            style: AppTypography.bodyMedium.copyWith(
                color: AppColors.ink, fontWeight: FontWeight.w600),
          ),
          const TextSpan(text: ' · '),
          if (canResend)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: onResend,
                child: Text('Resend',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.accent)),
              ),
            )
          else
            TextSpan(text: 'Resend in ${seconds}s'),
        ],
      ),
    );
  }
}
