import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String type,
    required String title,
    required String body,
    @JsonKey(name: 'read_at') String? readAt,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  bool get isUnread => readAt == null;
  DateTime get createdDateTime => DateTime.parse(createdAt);

  (IconData, Color) get icon => switch (type) {
        'payment_due'       => (Icons.currency_rupee,           AppColors.warn),
        'document_ready'    => (Icons.description_outlined,     AppColors.accent),
        'ticket_updated'    => (Icons.support_agent_outlined,   AppColors.info),
        'booking_confirmed' => (Icons.check_circle_outline,     AppColors.ok),
        _                   => (Icons.notifications_outlined,   AppColors.inkMute),
      };

  /// Deep link route — matches AppRoutes when possible.
  String? get deepLink => switch (type) {
        'payment_due'       => '/payments',
        'document_ready'    => '/documents',
        'ticket_updated'    => '/support',
        'booking_confirmed' => '/dashboard',
        _                   => null,
      };
}
