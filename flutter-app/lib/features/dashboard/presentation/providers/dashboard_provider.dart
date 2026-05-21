import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';
import 'package:builder_bridge/features/inventory/presentation/providers/inventory_provider.dart';

final dashboardUnitProvider =
    FutureProvider.family<UnitModel?, int>((ref, unitId) async {
  return ref.watch(unitRepositoryProvider).getById(unitId);
});
