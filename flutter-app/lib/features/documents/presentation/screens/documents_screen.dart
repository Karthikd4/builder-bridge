import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';

// TODO Sprint 5: AOS list, document viewer
class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text('Documents — Sprint 5', style: AppTypography.bodyLarge),
      ),
    );
  }
}
