import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_milestone_model.freezed.dart';
part 'payment_milestone_model.g.dart';

@freezed
abstract class PaymentMilestoneModel with _$PaymentMilestoneModel {
  const PaymentMilestoneModel._();

  const factory PaymentMilestoneModel({
    required int id,
    @JsonKey(name: 'booking_id') required int bookingId,
    required String label,
    required int amount,
    @JsonKey(name: 'due_date') required String dueDate,
    @JsonKey(name: 'paid_at') String? paidAt,
  }) = _PaymentMilestoneModel;

  factory PaymentMilestoneModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMilestoneModelFromJson(json);

  bool get isPaid => paidAt != null;

  /// "due" = next unpaid milestone (caller marks one); "upcoming" = unpaid + later.
  /// Status is derived in the repository for the soonest unpaid item.
  bool get isOverdue {
    if (isPaid) return false;
    return DateTime.parse(dueDate).isBefore(DateTime.now());
  }

  String get formattedAmount {
    final r = amount / 100;
    if (r >= 10000000) return '₹${(r / 10000000).toStringAsFixed(2)} Cr';
    if (r >= 100000) return '₹${(r / 100000).toStringAsFixed(2)} L';
    return '₹${r.toStringAsFixed(0)}';
  }

  DateTime get dueDateTime => DateTime.parse(dueDate);
}
