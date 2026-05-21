import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:builder_bridge/core/widgets/bb_badge.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

@freezed
abstract class TicketModel with _$TicketModel {
  const TicketModel._();

  const factory TicketModel({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'booking_id') int? bookingId,
    required String title,
    required String description,
    required String status,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  DateTime get createdDateTime => DateTime.parse(createdAt);
  bool get isOpen => status == 'open';
  bool get isResolved => status == 'resolved';

  (String, BBBadgeStatus) get statusTag => switch (status) {
        'open'        => ('Open',        BBBadgeStatus.warn),
        'in_progress' => ('In Progress', BBBadgeStatus.info),
        'resolved'    => ('Resolved',    BBBadgeStatus.ok),
        'closed'      => ('Closed',      BBBadgeStatus.neutral),
        _             => (status,        BBBadgeStatus.neutral),
      };
}
