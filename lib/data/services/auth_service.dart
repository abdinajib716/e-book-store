import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import '../../core/exceptions/api_exceptions.dart';

class AuthService {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  AuthService({
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);
      final user = UserModel.fromJson(response['data']['user']);
      final token = response['data']['token'] as String;

      await _localDataSource.saveUser(user);
      await _localDataSource.saveAuthToken(token);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> register(String email, String password, String fullName) async {
    try {
      final response = await _remoteDataSource.register(email, password, fullName);
      final user = UserModel.fromJson(response['data']['user']);
      final token = response['data']['token'] as String;

      await _localDataSource.saveUser(user);
      await _localDataSource.saveAuthToken(token);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _localDataSource.clearUser();
    await _localDataSource.clearAuthToken();
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await _localDataSource.getAuthToken();
      if (token == null) return null;

      final response = await _remoteDataSource.getCurrentUser();
      final user = UserModel.fromJson(response['data']);
      await _localDataSource.saveUser(user);
      return user;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await logout();
      }
      return null;
    }
  }

  Future<bool> verifyEmail(String email, String code) async {
    try {
      final success = await _remoteDataSource.verifyEmail(email, code);
      if (success) {
        final currentUser = await _localDataSource.getUser();
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(isEmailVerified: true);
          await _localDataSource.saveUser(updatedUser);
        }
      }
      return success;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendVerificationEmail(String email) async {
    await _remoteDataSource.sendVerificationEmail(email);
  }

  Future<void> forgotPassword(String email) async {
    await _remoteDataSource.forgotPassword(email);
  }

  Future<void> resetPassword(String token, String newPassword) async {
    await _remoteDataSource.resetPassword(token, newPassword);
  }

  Future<UserModel> updateProfile(Map<String, dynamic> userData) async {
    try {
      final response = await _remoteDataSource.updateProfile(userData);
      final updatedUser = UserModel.fromJson(response['data']);
      await _localDataSource.saveUser(updatedUser);
      return updatedUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final oldToken = await _localDataSource.getAuthToken();
      if (oldToken == null) return false;

      final response = await _remoteDataSource.refreshToken(oldToken);
      final newToken = response['data']['token'] as String;
      await _localDataSource.saveAuthToken(newToken);
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }
}
