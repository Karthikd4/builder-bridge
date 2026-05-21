import 'package:freezed_annotation/freezed_annotation.dart';

part 'tower_model.freezed.dart';
part 'tower_model.g.dart';

@freezed
abstract class TowerModel with _$TowerModel {
  const factory TowerModel({
    required int id,
    @JsonKey(name: 'project_id') required int projectId,
    required String name,
    @JsonKey(name: 'total_floors') required int totalFloors,
  }) = _TowerModel;

  factory TowerModel.fromJson(Map<String, dynamic> json) =>
      _$TowerModelFromJson(json);
}
