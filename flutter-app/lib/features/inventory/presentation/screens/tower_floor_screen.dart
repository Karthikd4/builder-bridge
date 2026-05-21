import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_empty_state.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';
import 'package:builder_bridge/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:builder_bridge/features/inventory/presentation/widgets/unit_detail_sheet.dart';
import 'package:builder_bridge/features/inventory/presentation/widgets/unit_status_cell.dart';

class TowerFloorScreen extends ConsumerWidget {
  final int towerId;
  const TowerFloorScreen({super.key, required this.towerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final towerAsync = ref.watch(towerByIdProvider(towerId));
    final unitsAsync = ref.watch(towerUnitsProvider(towerId));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: towerAsync.maybeWhen(
          data: (t) => Text(t?.name ?? 'Tower',
              style: AppTypography.labelLarge.copyWith(color: AppColors.ink)),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
      body: unitsAsync.when(
        loading: () => const BBLoadingState(),
        error: (e, _) => BBErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(towerUnitsProvider(towerId)),
        ),
        data: (units) {
          if (units.isEmpty) {
            return const BBEmptyState(
              icon: Icons.grid_view_outlined,
              message: 'No units found for this tower',
            );
          }
          return _UnitGrid(
            units: units,
            towerName: towerAsync.valueOrNull?.name ?? 'Tower',
          );
        },
      ),
    );
  }
}

class _UnitGrid extends StatelessWidget {
  final List<UnitModel> units;
  final String towerName;
  const _UnitGrid({required this.units, required this.towerName});

  @override
  Widget build(BuildContext context) {
    // Group by floor, highest first
    final byFloor = <int, List<UnitModel>>{};
    for (final u in units) {
      byFloor.putIfAbsent(u.floor, () => []).add(u);
    }
    final floors = byFloor.keys.toList()..sort((a, b) => b.compareTo(a));

    // Derive column headers from position order on first floor
    final firstFloorUnits = byFloor[floors.last] ?? [];
    final columnHeaders = firstFloorUnits.map((u) => u.type).toList();

    return Column(
      children: [
        _Legend(),
        const Divider(height: 1, color: AppColors.line),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _ColumnHeaders(headers: columnHeaders),
                const SizedBox(height: AppSpacing.sm),
                ...floors.map((floor) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _FloorRow(
                        floor: floor,
                        units: byFloor[floor]!,
                        towerName: towerName,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ColumnHeaders extends StatelessWidget {
  final List<String> headers;
  const _ColumnHeaders({required this.headers});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 44), // floor label width
        ...headers.map(
          (h) => Expanded(
            child: Center(
              child: Text(h,
                  style: AppTypography.labelSmall
                      .copyWith(fontSize: 10, letterSpacing: 0.4)),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloorRow extends StatelessWidget {
  final int floor;
  final List<UnitModel> units;
  final String towerName;
  const _FloorRow(
      {required this.floor, required this.units, required this.towerName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Center(
              child: Text('F$floor',
                  style: AppTypography.labelSmall.copyWith(fontSize: 10)),
            ),
          ),
          ...units.map(
            (unit) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: UnitStatusCell(
                  unit: unit,
                  onTap: () => UnitDetailSheet.show(context, unit, towerName),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(label: 'Available', color: AppColors.ok),
          SizedBox(width: AppSpacing.md),
          _LegendItem(label: 'Reserved', color: AppColors.warn),
          SizedBox(width: AppSpacing.md),
          _LegendItem(label: 'Booked', color: AppColors.danger),
          SizedBox(width: AppSpacing.md),
          _LegendItem(label: 'Sold', color: AppColors.inkFaint),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: AppTypography.labelSmall.copyWith(fontSize: 10)),
      ],
    );
  }
}
