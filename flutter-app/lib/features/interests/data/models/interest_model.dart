import 'package:freezed_annotation/freezed_annotation.dart';

part 'interest_model.freezed.dart';
part 'interest_model.g.dart';

@freezed
abstract class InterestModel with _$InterestModel {
  const factory InterestModel({
    required int id,
    @JsonKey(name: 'unit_id') required int unitId,
    @JsonKey(name: 'user_id') required int userId,
    required String status,
    @JsonKey(name: 'created_at') required String createdAt,
    // Populated via JOIN queries
    @JsonKey(name: 'user_name') String? userName,
    String? phone,
    String? email,
    @JsonKey(name: 'unit_no') String? unitNo,
    @JsonKey(name: 'tower_name') String? towerName,
    @JsonKey(name: 'unit_type') String? unitType,
    @JsonKey(name: 'unit_floor') int? unitFloor,
  }) = _InterestModel;

  factory InterestModel.fromJson(Map<String, dynamic> json) =>
      _$InterestModelFromJson(json);
}
