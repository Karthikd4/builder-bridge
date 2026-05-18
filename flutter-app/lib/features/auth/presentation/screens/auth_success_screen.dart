import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/features/auth/presentation/providers/auth_provider.dart';

class AuthSuccessScreen extends ConsumerWidget {
  const AuthSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(authProvider.select((s) => s.user?.displayName ?? 'Buyer'));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              _SuccessCircle(),
              const SizedBox(height: AppSpacing.xl),
              Text("You're all set,\n$name.", style: AppTypography.displayLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your home purchase journey is ready to track.',
                style:
                    AppTypography.bodyMedium.copyWith(color: AppColors.inkMute),
              ),
              const Spacer(),
              BBButton(
                label: 'Go to Dashboard',
                onPressed: () => context.go(AppRoutes.dashboard),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: const BoxDecoration(
        color: AppColors.okLight,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.check_rounded, color: AppColors.ok, size: 44),
      ),
    );
  }
}
