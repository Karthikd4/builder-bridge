import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_model.freezed.dart';
part 'unit_model.g.dart';

@freezed
abstract class UnitModel with _$UnitModel {
  const UnitModel._();

  const factory UnitModel({
    required int id,
    @JsonKey(name: 'tower_id') required int towerId,
    required int floor,
    @JsonKey(name: 'unit_no') required String unitNo,
    required String type,
    @JsonKey(name: 'area_sqft') required double areaSqft,
    required String status,
    @JsonKey(name: 'base_price') required int basePrice,
    // Populated via JOIN queries (e.g. getAllWithTowerName)
    @JsonKey(name: 'tower_name') String? towerName,
  }) = _UnitModel;

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  bool get isAvailable => status == 'available';
  bool get isReserved => status == 'reserved';
  bool get isBooked => status == 'booked';
  bool get isSold => status == 'sold';

  /// Price in rupees.
  double get priceRupees => basePrice / 100;

  String get formattedPrice {
    final r = priceRupees;
    if (r >= 10000000) return '₹${(r / 10000000).toStringAsFixed(2)} Cr';
    return '₹${(r / 100000).toStringAsFixed(2)} L';
  }
}
