import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';

// TODO Sprint 2: tower/floor/unit browse
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text('Inventory — Sprint 2', style: AppTypography.bodyLarge),
      ),
    );
  }
}
