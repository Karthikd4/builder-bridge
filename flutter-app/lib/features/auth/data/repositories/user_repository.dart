import 'package:builder_bridge/core/database/database_helper.dart';

class UserRepository {
  final _db = DatabaseHelper();

  /// Returns existing user id for [phone], or creates a new record.
  Future<int> findOrCreateUser({
    required String name,
    required String phone,
    String? email,
  }) async {
    final existing = await _db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );
    if (existing.isNotEmpty) return existing.first['id'] as int;
    return createUser(name: name, phone: phone, email: email);
  }

  /// Creates a new user record and returns its generated id.
  Future<int> createUser({
    required String name,
    required String phone,
    String? email,
  }) async {
    final now = DateTime.now().toIso8601String();
    return _db.insert('users', {
      'name': name,
      'phone': phone,
      'email': email,
      'created_at': now,
    });
  }
}
