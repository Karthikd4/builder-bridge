import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
abstract class BookingModel with _$BookingModel {
  const BookingModel._();

  const factory BookingModel({
    required int id,
    @JsonKey(name: 'unit_id') required int unitId,
    @JsonKey(name: 'user_id') required int userId,
    required String status,
    @JsonKey(name: 'token_amount') required int tokenAmount,
    @JsonKey(name: 'booked_at') required String bookedAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  bool get isConfirmed => status == 'confirmed';
  bool get isReserved => status == 'reserved';
}
