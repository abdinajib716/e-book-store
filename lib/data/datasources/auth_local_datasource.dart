import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart' as sp;
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> clearAuthToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final sp.SharedPreferences prefs;
  static const String userKey = 'user';
  static const String tokenKey = 'auth_token';

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> saveUser(UserModel user) async {
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getUser() async {
    final userStr = prefs.getString(userKey);
    if (userStr != null) {
      return UserModel.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await prefs.remove(userKey);
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await prefs.setString(tokenKey, token);
  }

  @override
  Future<String?> getAuthToken() async {
    return prefs.getString(tokenKey);
  }

  @override
  Future<void> clearAuthToken() async {
    await prefs.remove(tokenKey);
  }
}
