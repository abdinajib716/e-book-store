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
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> clearRefreshToken();
  Future<void> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final sp.SharedPreferences prefs;
  static const String userKey = 'user';
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> saveUser(UserModel user) async {
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getUser() async {
    final userStr = prefs.getString(userKey);
    if (userStr == null) return null;
    
    try {
      return UserModel.fromJson(jsonDecode(userStr));
    } catch (e) {
      print('Error parsing stored user data: $e');
      return null;
    }
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

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await prefs.setString(refreshTokenKey, refreshToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return prefs.getString(refreshTokenKey);
  }

  @override
  Future<void> clearRefreshToken() async {
    await prefs.remove(refreshTokenKey);
  }

  @override
  Future<void> clearAll() async {
    await Future.wait([
      clearUser(),
      clearAuthToken(),
      clearRefreshToken(),
    ]);
  }
}
