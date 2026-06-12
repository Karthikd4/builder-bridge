import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/admin/data/models/admin_user_model.dart';

class AdminUserRepository {
  final _db = DatabaseHelper();

  Future<List<AdminUserModel>> getAll() async {
    final rows = await _db.query('admin_users', orderBy: 'name ASC');
    return rows.map(AdminUserModel.fromRow).toList();
  }

  Future<AdminUserModel?> getByEmail(String email) async {
    final rows = await _db.query(
      'admin_users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (rows.isEmpty) return null;
    return AdminUserModel.fromRow(rows.first);
  }

  Future<int> create({
    required String name,
    required String email,
    String phone = '',
    String role = 'viewer',
  }) async {
    return _db.insert('admin_users', {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> update(int id, {
    String? name,
    String? email,
    String? phone,
    String? role,
    bool? isActive,
  }) async {
    final values = <String, dynamic>{};
    if (name != null) values['name'] = name;
    if (email != null) values['email'] = email;
    if (phone != null) values['phone'] = phone;
    if (role != null) values['role'] = role;
    if (isActive != null) values['is_active'] = isActive ? 1 : 0;
    if (values.isEmpty) return;
    await _db.update('admin_users', values,
        where: 'id = ?', whereArgs: [id]);
  }
}
