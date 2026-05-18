import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';

// TODO Sprint 4: payment timeline, milestones, receipts
class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text('Payments — Sprint 4', style: AppTypography.bodyLarge),
      ),
    );
  }
}
