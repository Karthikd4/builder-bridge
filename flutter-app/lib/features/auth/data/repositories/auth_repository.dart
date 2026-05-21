import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/auth/data/models/user_model.dart';

class AuthRepository {
  static const _sessionKey = 'session_user_id';
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<UserModel?> getSessionUser() async {
    final prefs = await _getPrefs();
    final userId = prefs.getString(_sessionKey);
    if (userId == null) return null;

    if (kIsWeb) return _webFakeUser(userId);

    final db = await DatabaseHelper().database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  Future<UserModel> loginWithPhone(String phone) async {
    if (kIsWeb) {
      const userId = 'web-demo';
      final user = _webFakeUser(userId);
      final prefs = await _getPrefs();
      await prefs.setString(_sessionKey, userId);
      return user;
    }

    final db = await DatabaseHelper().database;
    final rows = await db.query('users', where: 'phone = ?', whereArgs: [phone]);

    late UserModel user;
    if (rows.isNotEmpty) {
      user = _fromRow(rows.first);
    } else {
      final now = DateTime.now().toIso8601String();
      final id = await db.insert('users', {
        'phone': phone,
        'name': '',
        'email': '',
        'created_at': now,
      });
      user = UserModel(
        id: id.toString(),
        phone: phone,
        name: '',
        email: '',
        createdAt: now,
      );
    }

    final prefs = await _getPrefs();
    await prefs.setString(_sessionKey, user.id);
    return user;
  }

  Future<void> logout() async {
    final prefs = await _getPrefs();
    await prefs.remove(_sessionKey);
  }

  /// Maps a SQLite row (snake_case keys) to UserModel.
  UserModel _fromRow(Map<String, dynamic> row) => UserModel(
        id: row['id'].toString(),
        phone: row['phone'] as String,
        name: (row['name'] as String?) ?? '',
        email: (row['email'] as String?) ?? '',
        createdAt: row['created_at'] as String,
      );

  UserModel _webFakeUser(String id) => UserModel(
        id: id,
        phone: '9999999999',
        name: 'Demo Buyer',
        email: '',
        createdAt: DateTime.now().toIso8601String(),
      );
}
