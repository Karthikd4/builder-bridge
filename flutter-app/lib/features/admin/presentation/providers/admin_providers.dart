import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:builder_bridge/features/interests/data/repositories/interest_repository.dart';
import 'package:builder_bridge/features/interests/presentation/providers/interest_provider.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';
import 'package:builder_bridge/features/inventory/presentation/providers/inventory_provider.dart';

part 'admin_providers.g.dart';

// ── Dashboard summary ────────────────────────────────────────────────────────

class AdminDashboardStats {
  final int totalUnits;
  final int availableUnits;
  final int reservedUnits;
  final int bookedUnits;
  final int totalInterests;
  final int newInterests;

  const AdminDashboardStats({
    required this.totalUnits,
    required this.availableUnits,
    required this.reservedUnits,
    required this.bookedUnits,
    required this.totalInterests,
    required this.newInterests,
  });
}

@riverpod
Future<AdminDashboardStats> adminDashboardStats(Ref ref) async {
  // Fetch units and interests in parallel — independent DB queries.
  final (units, interests) = await (
    ref.watch(allUnitsProvider.future),
    ref.watch(allInterestsProvider.future),
  ).wait;

  return AdminDashboardStats(
    totalUnits:     units.length,
    availableUnits: units.where((u) => u.status == 'available').length,
    reservedUnits:  units.where((u) => u.status == 'reserved').length,
    bookedUnits:    units.where((u) => u.status == 'booked').length,
    totalInterests: interests.length,
    newInterests:   interests.where((i) => i.status == InterestStatus.newInterest).length,
  );
}

// ── All units (flat list across all towers) ──────────────────────────────────

@riverpod
Future<List<UnitModel>> allUnits(Ref ref) {
  return ref.watch(unitRepositoryProvider).getAllWithTowerName();
}

// ── Unit status update ───────────────────────────────────────────────────────

@riverpod
class UnitStatusNotifier extends _$UnitStatusNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> updateStatus(int unitId, String status) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(unitRepositoryProvider).updateStatus(unitId, status);
      ref.invalidate(allUnitsProvider);
      ref.invalidate(adminDashboardStatsProvider);
    });
  }
}

// ── Interest status update ───────────────────────────────────────────────────

@riverpod
class AdminInterestNotifier extends _$AdminInterestNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> markContacted(int interestId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(interestRepositoryProvider)
          .updateStatus(interestId, InterestStatus.contacted);
      ref.invalidate(allInterestsProvider);
      ref.invalidate(adminDashboardStatsProvider);
    });
  }
}
