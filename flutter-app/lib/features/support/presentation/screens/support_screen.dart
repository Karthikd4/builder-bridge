import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';

// TODO Sprint 5: ticket list, create ticket, detail
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text('Support — Sprint 5', style: AppTypography.bodyLarge),
      ),
    );
  }
}
