import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/documents/data/models/document_model.dart';
import 'package:builder_bridge/features/documents/presentation/providers/documents_provider.dart';

class DocumentCategoryChips extends ConsumerWidget {
  const DocumentCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(documentCategoryFilterProvider);
    final notifier = ref.read(documentCategoryFilterProvider.notifier);

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DocumentCategory.list.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final cat = DocumentCategory.list[i];
          final isOn = cat == selected;
          return _Chip(
            label: cat,
            isOn: isOn,
            onTap: () => notifier.select(cat),
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isOn;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.isOn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isOn ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: isOn ? AppColors.accent : AppColors.line),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isOn ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
