import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_user_model.freezed.dart';
part 'admin_user_model.g.dart';

enum AdminRole { owner, manager, sales, viewer }

@freezed
abstract class AdminUserModel with _$AdminUserModel {
  const AdminUserModel._();

  const factory AdminUserModel({
    required int id,
    required String name,
    required String email,
    @Default('') String phone,
    @Default('viewer') String role,
    @Default(true) bool isActive,
    required String createdAt,
  }) = _AdminUserModel;

  factory AdminUserModel.fromJson(Map<String, dynamic> json) =>
      _$AdminUserModelFromJson(json);

  factory AdminUserModel.fromRow(Map<String, dynamic> row) => AdminUserModel(
        id: row['id'] as int,
        name: row['name'] as String,
        email: row['email'] as String,
        phone: (row['phone'] as String?) ?? '',
        role: (row['role'] as String?) ?? 'viewer',
        isActive: (row['is_active'] as int?) == 1,
        createdAt: row['created_at'] as String,
      );

  AdminRole get adminRole => AdminRole.values.firstWhere(
        (r) => r.name == role,
        orElse: () => AdminRole.viewer,
      );

  String get roleLabel => switch (adminRole) {
        AdminRole.owner => 'Owner',
        AdminRole.manager => 'Manager',
        AdminRole.sales => 'Sales',
        AdminRole.viewer => 'Viewer',
      };
}
