import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

@freezed
abstract class DocumentModel with _$DocumentModel {
  const DocumentModel._();

  const factory DocumentModel({
    required int id,
    @JsonKey(name: 'booking_id') required int bookingId,
    required String type,
    required String name,
    required String status,
    @JsonKey(name: 'file_path') String? filePath,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  DateTime get createdDateTime => DateTime.parse(createdAt);

  /// Three-letter extension shown on the doc icon (PDF, MP4, JPG…).
  String get extension {
    final i = name.lastIndexOf('.');
    if (i < 0 || i == name.length - 1) return 'DOC';
    return name.substring(i + 1).toUpperCase();
  }

  IconData get categoryIcon => switch (type) {
        'Agreement'  => Icons.description_outlined,
        'Plans'      => Icons.layers_outlined,
        'Receipts'   => Icons.receipt_long_outlined,
        'Compliance' => Icons.shield_outlined,
        'Estimate'   => Icons.currency_rupee,
        _            => Icons.insert_drive_file_outlined,
      };
}

/// Filter chip values used by DocumentsScreen.
abstract final class DocumentCategory {
  static const all = 'All';
  static const list = [all, 'Agreement', 'Plans', 'Receipts', 'Compliance'];
}
