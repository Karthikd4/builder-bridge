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

    return const _WelcomeView();
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/vue_building.jpg',
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.85),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: const SizedBox.expand(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Image.asset(
                      'assets/images/vue_logo.png',
                      width: 220,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'A joint venture by',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall
                        .copyWith(color: Colors.white60),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Image.asset(
                          'assets/images/raghuram_logo.png',
                          height: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Image.asset(
                          'assets/images/pradeep_logo.png',
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'TS RERA : P02400007083',
                    textAlign: TextAlign.center,
                    style: AppTypography.labelSmall
                        .copyWith(color: Colors.white38),
                  ),
                  const Spacer(),
                  const _ContinueButton(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Powered by BuilderBridge',
                    style: AppTypography.labelSmall
                        .copyWith(color: Colors.white38),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.sm,
            right: AppSpacing.md,
            child: TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: Text('Skip',
                  style: AppTypography.labelMedium
                      .copyWith(color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton();

  @override
  Widget build(BuildContext context) {
    return BBButton(
      label: 'Continue',
      leadingIcon: Icons.arrow_forward,
      onPressed: () => context.go(AppRoutes.login),
    );
  }
}
