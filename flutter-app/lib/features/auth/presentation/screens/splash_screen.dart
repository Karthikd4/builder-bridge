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

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _sessionChecked = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), _tryAutoNavigate);
  }

  void _tryAutoNavigate() {
    if (!mounted || _navigated) return;
    final auth = ref.read(authProvider);
    if (!auth.isLoading) _handleSession(auth);
  }

  void _handleSession(AuthState auth) {
    if (!mounted) return;
    if (auth.isAuthenticated) {
      _navigated = true;
      context.go(AppRoutes.dashboard);
    } else {
      setState(() => _sessionChecked = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (_, next) {
      if (!next.isLoading && !_navigated) _handleSession(next);
    });

    if (!_sessionChecked) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: BBLogo(size: 64)),
      );
    }

    // No session — show Welcome screen
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const BBLogo(size: 64),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Welcome to\nBuilderBridge.',
                    textAlign: TextAlign.center,
                    style: AppTypography.displayLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'One trusted home for your booking, payments,\nagreement and construction journey.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.inkMute),
                  ),
                  const Spacer(),
                  BBButton(
                    label: '→  Continue',
                    onPressed: () => context.go(AppRoutes.login),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    '© All data encrypted · IT Act 2000 compliant',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.inkFaint,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.md,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.login),
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
