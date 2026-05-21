import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:builder_bridge/core/navigation/app_routes.dart';
import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_empty_state.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/documents/data/models/document_model.dart';
import 'package:builder_bridge/features/documents/presentation/providers/documents_provider.dart';
import 'package:builder_bridge/features/documents/presentation/widgets/document_category_chips.dart';
import 'package:builder_bridge/features/documents/presentation/widgets/document_row.dart';

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(currentBookingDocumentsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Documents', style: AppTypography.labelLarge),
      ),
      body: docsAsync.when(
        loading: () => const BBLoadingState(),
        error: (_, __) => BBErrorState(
          message: 'Could not load documents',
          onRetry: () => ref.invalidate(currentBookingDocumentsProvider),
        ),
        data: (docs) {
          if (docs.isEmpty) {
            return BBEmptyState(
              icon: Icons.folder_outlined,
              message: 'Documents will appear once your booking is processed.',
              ctaLabel: 'Browse Inventory',
              onCta: () => context.go(AppRoutes.inventory),
            );
          }
          return _DocumentsBody(docs: docs);
        },
      ),
    );
  }
}

class _DocumentsBody extends ConsumerWidget {
  final List<DocumentModel> docs;
  const _DocumentsBody({required this.docs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(documentCategoryFilterProvider);
    final filtered = category == DocumentCategory.all
        ? docs
        : docs.where((d) => d.type == category).toList();
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md, AppSpacing.md,
        AppSpacing.md, AppSpacing.xxl + bottomInset,
      ),
      children: [
        _Header(totalCount: docs.length),
        const SizedBox(height: AppSpacing.md),
        const DocumentCategoryChips(),
        const SizedBox(height: AppSpacing.md),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Text('No documents in this category yet.',
                  style: AppTypography.bodySmall),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: List.generate(filtered.length, (i) {
                final doc = filtered[i];
                return DocumentRow(
                  document: doc,
                  showDivider: i < filtered.length - 1,
                  onTap: () => _showSnackBar(context, doc.name),
                );
              }),
            ),
          ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preview not available in MVP: $name')),
    );
  }
}

class _Header extends StatelessWidget {
  final int totalCount;
  const _Header({required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DOCUMENTS VAULT',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.inkFaint,
              letterSpacing: 0.6,
            )),
        const SizedBox(height: 2),
        Text('$totalCount file${totalCount == 1 ? '' : 's'}',
            style: AppTypography.headlineMedium),
      ],
    );
  }
}
