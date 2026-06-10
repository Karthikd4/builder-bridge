import 'package:builder_bridge/core/database/database_helper.dart';

class UserRepository {
  final _db = DatabaseHelper();

  /// Creates a new user record and returns its generated id.
  /// Used by admin onboarding to register a buyer before creating a booking.
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
