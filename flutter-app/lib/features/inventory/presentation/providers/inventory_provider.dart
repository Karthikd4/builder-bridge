import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:builder_bridge/features/inventory/data/models/project_model.dart';
import 'package:builder_bridge/features/inventory/data/models/tower_model.dart';
import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';
import 'package:builder_bridge/features/inventory/data/repositories/project_repository.dart';
import 'package:builder_bridge/features/inventory/data/repositories/tower_repository.dart';
import 'package:builder_bridge/features/inventory/data/repositories/unit_repository.dart';

part 'inventory_provider.g.dart';

final projectRepositoryProvider =
    Provider<ProjectRepository>((_) => ProjectRepository());

final towerRepositoryProvider =
    Provider<TowerRepository>((_) => TowerRepository());

final unitRepositoryProvider =
    Provider<UnitRepository>((_) => UnitRepository());

@riverpod
Future<ProjectModel?> currentProject(Ref ref) =>
    ref.watch(projectRepositoryProvider).getFirstProject();

@riverpod
Future<List<TowerModel>> projectTowers(Ref ref, int projectId) =>
    ref.watch(towerRepositoryProvider).getTowersForProject(projectId);

@riverpod
Future<Map<String, int>> towerStatusCounts(Ref ref, int towerId) =>
    ref.watch(unitRepositoryProvider).getStatusCountsForTower(towerId);

@riverpod
Future<List<UnitModel>> towerUnits(Ref ref, int towerId) =>
    ref.watch(unitRepositoryProvider).getUnitsForTower(towerId);

@riverpod
Future<TowerModel?> towerById(Ref ref, int towerId) =>
    ref.watch(towerRepositoryProvider).getById(towerId);
