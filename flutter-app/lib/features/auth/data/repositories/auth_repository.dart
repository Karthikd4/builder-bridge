import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/features/auth/data/models/user_model.dart';

class AuthRepository {
  static const _sessionKey = 'session_user_id';
  final _uuid = const Uuid();
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
    return UserModel.fromJson(rows.first);
  }

  Future<UserModel> loginWithPhone(String phone) async {
    if (kIsWeb) {
      final user = UserModel(
        id: _uuid.v4(),
        phone: phone,
        name: 'Demo Buyer',
        email: '',
        createdAt: DateTime.now().toIso8601String(),
      );
      final prefs = await _getPrefs();
      await prefs.setString(_sessionKey, user.id);
      return user;
    }

    final db = await DatabaseHelper().database;
    final rows = await db.query('users', where: 'phone = ?', whereArgs: [phone]);

    late UserModel user;
    if (rows.isNotEmpty) {
      user = UserModel.fromJson(rows.first);
    } else {
      user = UserModel(
        id: _uuid.v4(),
        phone: phone,
        name: '',
        email: '',
        createdAt: DateTime.now().toIso8601String(),
      );
      await db.insert('users', user.toJson());
    }

    final prefs = await _getPrefs();
    await prefs.setString(_sessionKey, user.id);
    return user;
  }

  Future<void> logout() async {
    final prefs = await _getPrefs();
    await prefs.remove(_sessionKey);
  }

  UserModel _webFakeUser(String id) => UserModel(
        id: id,
        phone: '9999999999',
        name: 'Demo Buyer',
        email: '',
        createdAt: DateTime.now().toIso8601String(),
      );
}
