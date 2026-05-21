import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_comment_model.freezed.dart';
part 'ticket_comment_model.g.dart';

@freezed
abstract class TicketCommentModel with _$TicketCommentModel {
  const TicketCommentModel._();

  const factory TicketCommentModel({
    required int id,
    @JsonKey(name: 'ticket_id') required int ticketId,
    required String author,
    required String body,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _TicketCommentModel;

  factory TicketCommentModel.fromJson(Map<String, dynamic> json) =>
      _$TicketCommentModelFromJson(json);

  DateTime get createdDateTime => DateTime.parse(createdAt);
  bool get isYou => author == 'You' || author.toLowerCase().startsWith('you ');
}
