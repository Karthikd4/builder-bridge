import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/admin/presentation/providers/admin_providers.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';

class UnitAvailabilityScreen extends ConsumerStatefulWidget {
  const UnitAvailabilityScreen({super.key});

  @override
  ConsumerState<UnitAvailabilityScreen> createState() =>
      _UnitAvailabilityScreenState();
}

class _UnitAvailabilityScreenState
    extends ConsumerState<UnitAvailabilityScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(allUnitsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Unit Availability', style: AppTypography.labelLarge),
      ),
      body: Column(
        children: [
          _FilterBar(
            selected: _filter,
            onChanged: (f) => setState(() => _filter = f),
            units: unitsAsync.valueOrNull ?? [],
          ),
          Expanded(
            child: unitsAsync.when(
              loading: () => const BBLoadingState(),
              error: (_, __) => BBErrorState(
                message: 'Could not load units',
                onRetry: () => ref.invalidate(allUnitsProvider),
              ),
              data: (units) {
                final filtered = _filter == 'all'
                    ? units
                    : units.where((u) => u.status == _filter).toList();
                if (filtered.isEmpty) {
                  return Center(
                    child: Text('No $_filter units.',
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.inkMute)),
                  );
                }
                return _UnitList(units: filtered);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  final List<UnitModel> units;

  const _FilterBar({
    required this.selected,
    required this.onChanged,
    required this.units,
  });

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final u in units) {
      counts[u.status] = (counts[u.status] ?? 0) + 1;
    }

    final filters = [
      ('all', 'All', units.length),
      ('available', 'Available', counts['available'] ?? 0),
      ('reserved', 'Reserved', counts['reserved'] ?? 0),
      ('booked', 'Booked', counts['booked'] ?? 0),
      ('sold', 'Sold', counts['sold'] ?? 0),
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

class _UnitList extends ConsumerWidget {
  final List<UnitModel> units;
  const _UnitList({required this.units});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = <int, List<UnitModel>>{};
    for (final u in units) {
      grouped.putIfAbsent(u.towerId, () => []).add(u);
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: grouped.entries.map((entry) {
        final towerUnits = entry.value;
        return _TowerSection(units: towerUnits);
      }).toList(),
    );
  }
}

class _TowerSection extends StatelessWidget {
  final List<UnitModel> units;
  const _TowerSection({required this.units});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            units.first.towerName ?? 'Tower ${units.first.towerId}',
            style:
                AppTypography.labelMedium.copyWith(color: AppColors.inkMute),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: List.generate(units.length, (i) {
              return _UnitRow(
                unit: units[i],
                showDivider: i < units.length - 1,
              );
            }),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _UnitRow extends ConsumerWidget {
  final UnitModel unit;
  final bool showDivider;
  const _UnitRow({required this.unit, required this.showDivider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Unit ${unit.unitNo}',
                        style: AppTypography.labelLarge),
                    Text(
                      '${unit.type} · Floor ${unit.floor} · '
                      '${unit.areaSqft.toStringAsFixed(0)} sqft · '
                      '${unit.formattedPrice}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              _StatusDropdown(unit: unit),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AppColors.line),
      ],
    );
  }
}

class _StatusDropdown extends ConsumerWidget {
  final UnitModel unit;
  const _StatusDropdown({required this.unit});

  static const _statuses = ['available', 'reserved', 'booked', 'sold'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: unit.status,
        isDense: true,
        items: _statuses
            .map((s) => DropdownMenuItem(
                  value: s,
                  child: BBBadge(
                    label: _capitalize(s),
                    status: _badgeStatus(s),
                  ),
                ))
            .toList(),
        onChanged: (newStatus) {
          if (newStatus == null || newStatus == unit.status) return;
          ref
              .read(unitStatusNotifierProvider.notifier)
              .updateStatus(unit.id, newStatus);
        },
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  BBBadgeStatus _badgeStatus(String s) => switch (s) {
        'available' => BBBadgeStatus.ok,
        'reserved' => BBBadgeStatus.warn,
        'booked' => BBBadgeStatus.danger,
        _ => BBBadgeStatus.neutral,
      };
}
