import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/utils/format_utils.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/core/widgets/bb_card.dart';
import 'package:builder_bridge/core/widgets/bb_empty_state.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/admin/presentation/providers/admin_providers.dart';
import 'package:builder_bridge/features/admin/presentation/widgets/onboard_customer_dialog.dart';

class AdminCustomersScreen extends ConsumerStatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  ConsumerState<AdminCustomersScreen> createState() =>
      _AdminCustomersScreenState();
}

class _AdminCustomersScreenState
    extends ConsumerState<AdminCustomersScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(onboardedCustomersProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Customers', style: AppTypography.labelLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: BBButton(
              label: 'Onboard Customer',
              leadingIcon: Icons.person_add_outlined,
              fullWidth: false,
              onPressed: () => _showOnboardDialog(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            selected: _filter,
            onChanged: (f) => setState(() => _filter = f),
            customers: customersAsync.valueOrNull ?? [],
          ),
          Expanded(
            child: customersAsync.when(
              loading: () => const BBLoadingState(),
              error: (_, __) =>
                  const BBErrorState(message: 'Could not load customers'),
              data: (customers) {
                final filtered = _filter == 'all'
                    ? customers
                    : customers
                        .where((c) => c.status == _filter)
                        .toList();
                if (filtered.isEmpty) {
                  return BBEmptyState(
                    icon: Icons.people_outline,
                    message: _filter == 'all'
                        ? 'No customers onboarded yet.'
                        : 'No $_filter customers.',
                    ctaLabel:
                        _filter == 'all' ? 'Onboard Customer' : null,
                    onCta: _filter == 'all'
                        ? () => _showOnboardDialog()
                        : null,
                  );
                }
                return _CustomerList(customers: filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showOnboardDialog() {
    showDialog(
      context: context,
      builder: (_) => OnboardCustomerDialog(
        onSuccess: () => ref.invalidate(onboardedCustomersProvider),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  final List<OnboardedCustomer> customers;

  const _FilterBar({
    required this.selected,
    required this.onChanged,
    required this.customers,
  });

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final c in customers) {
      counts[c.status] = (counts[c.status] ?? 0) + 1;
    }

    final filters = [
      ('all', 'All', customers.length),
      ('confirmed', 'Confirmed', counts['confirmed'] ?? 0),
      ('reserved', 'Reserved', counts['reserved'] ?? 0),
      ('cancelled', 'Cancelled', counts['cancelled'] ?? 0),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: filters
            .map((f) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text('${f.$2} (${f.$3})',
                        style: AppTypography.labelSmall),
                    selected: selected == f.$1,
                    onSelected: (_) => onChanged(f.$1),
                    selectedColor: AppColors.accentSoft,
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.line),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _CustomerList extends StatelessWidget {
  final List<OnboardedCustomer> customers;
  const _CustomerList({required this.customers});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: customers.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) => _CustomerCard(customer: customers[i]),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final OnboardedCustomer customer;
  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    final statusBadge = switch (customer.status) {
      'confirmed' => (BBBadgeStatus.ok, 'Confirmed'),
      'reserved' => (BBBadgeStatus.warn, 'Reserved'),
      'cancelled' => (BBBadgeStatus.danger, 'Cancelled'),
      _ => (BBBadgeStatus.neutral, customer.status),
    };

    final bookedDate = DateTime.tryParse(customer.bookedAt);
    final dateStr =
        bookedDate != null ? FormatUtils.formatDate(bookedDate) : '';

    return BBCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.accentSoft,
                child: Text(
                  customer.customerName.isNotEmpty
                      ? customer.customerName[0].toUpperCase()
                      : '?',
                  style: AppTypography.labelLarge
                      .copyWith(color: AppColors.accent),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.customerName,
                        style: AppTypography.labelLarge),
                    const SizedBox(height: 2),
                    Text(customer.phone, style: AppTypography.bodySmall),
                    if (customer.email != null &&
                        customer.email!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(customer.email!,
                          style: AppTypography.bodySmall),
                    ],
                  ],
                ),
              ),
              BBBadge(label: statusBadge.$2, status: statusBadge.$1),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _Detail(
                  label: 'Unit',
                  value: '${customer.towerName} · ${customer.unitNo}'),
              _Detail(label: 'Type', value: customer.unitType),
              _Detail(
                  label: 'Token',
                  value: FormatUtils.formatPaise(customer.tokenAmount)),
              _Detail(label: 'Booked', value: dateStr),
            ],
          ),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final String label;
  final String value;
  const _Detail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.inkFaint)),
          const SizedBox(height: 2),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
