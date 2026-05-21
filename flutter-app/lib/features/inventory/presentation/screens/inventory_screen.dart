import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_empty_state.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/inventory/data/models/project_model.dart';
import 'package:builder_bridge/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:builder_bridge/features/inventory/presentation/widgets/tower_card.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(currentProjectProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Inventory',
            style: AppTypography.labelLarge.copyWith(color: AppColors.ink)),
      ),
      body: projectAsync.when(
        loading: () => const BBLoadingState(),
        error: (e, _) => BBErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(currentProjectProvider),
        ),
        data: (project) {
          if (project == null) {
            return const BBEmptyState(
              icon: Icons.apartment_outlined,
              message: 'No project assigned yet.\nContact your builder.',
            );
          }
          return _ProjectContent(project: project);
        },
      ),
    );
  }
}

class _ProjectContent extends ConsumerWidget {
  final ProjectModel project;
  const _ProjectContent({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final towersAsync = ref.watch(projectTowersProvider(project.id));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProjectCard(project: project),
          const SizedBox(height: AppSpacing.lg),
          Text('SELECT A TOWER',
              style: AppTypography.labelSmall.copyWith(letterSpacing: 0.8)),
          const SizedBox(height: AppSpacing.md),
          towersAsync.when(
            loading: () => const BBLoadingState(itemCount: 2),
            error: (e, _) => BBErrorState(message: e.toString()),
            data: (towers) {
              if (towers.isEmpty) {
                return const BBEmptyState(
                  icon: Icons.domain_outlined,
                  message: 'No towers available yet',
                );
              }
              return Column(
                children: [
                  for (final tower in towers) ...[
                    TowerCard(tower: tower),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLg)),
            ),
            child: const Center(
              child: Icon(Icons.location_city_outlined,
                  size: 40, color: AppColors.accent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name, style: AppTypography.headlineMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(project.builderName,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.accent)),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppColors.inkMute),
                    const SizedBox(width: 4),
                    Text(project.location, style: AppTypography.bodySmall),
                  ],
                ),
                if (project.description != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(project.description!,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.inkMute)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
