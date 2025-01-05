import '../../domain/entities/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import '../../core/exceptions/api_exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      final user = UserModel.fromJson(response['data']['user']);
      final token = response['data']['token'] as String;

      await localDataSource.saveUser(user);
      await localDataSource.saveAuthToken(token);
      return user;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Login failed: ${e.toString()}');
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await remoteDataSource.register(email, password, fullName);
      final user = UserModel.fromJson(response['data']['user']);
      final token = response['data']['token'] as String;

      await localDataSource.saveUser(user);
      await localDataSource.saveAuthToken(token);
      return user;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> sendVerificationEmail(String email) async {
    try {
      await remoteDataSource.sendVerificationEmail(email);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Failed to send verification email: ${e.toString()}');
    }
  }

  @override
  Future<bool> verifyEmail(String email, String code) async {
    try {
      final success = await remoteDataSource.verifyEmail(email, code);
      if (success) {
        final currentUser = await localDataSource.getUser();
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(isEmailVerified: true);
          await localDataSource.saveUser(updatedUser);
        }
      }
      return success;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Email verification failed: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Failed to process forgot password request: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await remoteDataSource.resetPassword(token, newPassword);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<User> updateProfile(User user) async {
    try {
      if (user is! UserModel) {
        throw ApiException(message: 'Invalid user model type');
      }
      final response = await remoteDataSource.updateProfile(user.toJson());
      final updatedUser = UserModel.fromJson(response['data']);
      await localDataSource.saveUser(updatedUser);
      return updatedUser;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Profile update failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.clearUser();
      await localDataSource.clearAuthToken();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final token = await localDataSource.getAuthToken();
      if (token == null) return null;

      final response = await remoteDataSource.getCurrentUser();
      final user = UserModel.fromJson(response['data']);
      await localDataSource.saveUser(user);
      return user;
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) {
        await logout();
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<bool> refreshToken() async {
    try {
      final oldToken = await localDataSource.getAuthToken();
      if (oldToken == null) return false;

      final response = await remoteDataSource.refreshToken(oldToken);
      final newToken = response['data']['token'] as String;
      await localDataSource.saveAuthToken(newToken);
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }
}
