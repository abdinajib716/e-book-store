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
      print('Starting login process for email: $email');

      // Attempt login
      final response = await _remoteDataSource.login(email, password);

      print('Processing login response: ${response.toString()}');

      // Extract and validate outer data
      if (response['success'] != true) {
        print('Login failed: ${response.toString()}');
        throw ApiException(message: 'Login failed');
      }

      // Extract and validate inner data
      final responseData = response['data'];
      if (responseData == null || responseData is! Map<String, dynamic>) {
        print('Invalid response structure: $response');
        throw ApiException(message: 'Invalid response format');
      }

      // Extract and validate user data
      final userData = responseData['user'];
      if (userData == null || userData is! Map<String, dynamic>) {
        print('Invalid user data structure: $responseData');
        throw ApiException(message: 'Invalid user data format');
      }

      // Extract and validate token
      final token = responseData['token'];
      final refreshToken = responseData['refreshToken'];
      if (token == null || token is! String || refreshToken == null || refreshToken is! String) {
        print('Invalid token in response: $responseData');
        throw ApiException(message: 'Invalid authentication token');
      }

      // Create user model
      final user = UserModel.fromJson(userData);
      print('User model created successfully: ${user.toString()}');

      // Save authentication data
      await Future.wait([
        _localDataSource.saveUser(user),
        _localDataSource.saveAuthToken(token),
        _localDataSource.saveRefreshToken(refreshToken),
      ]);
      print('User data and tokens saved locally');

      return user;
    } catch (e) {
      print('Error during login process: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: 'Login failed: ${e.toString()}');
    }
  }

  Future<UserModel> register(String email, String password, String fullName) async {
    try {
      final response = await _remoteDataSource.register(email, password, fullName);
      final userData = response['data']['user'] as Map<String, dynamic>;
      final token = response['data']['token'] as String;

      final user = UserModel.fromJson(userData);
      await Future.wait([
        _localDataSource.saveUser(user),
        _localDataSource.saveAuthToken(token),
      ]);

      return user;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: e.toString());
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
      final userData = response['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userData);
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
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: e.toString());
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
      final updatedUserData = response['data'] as Map<String, dynamic>;
      final updatedUser = UserModel.fromJson(updatedUserData);
      await _localDataSource.saveUser(updatedUser);
      return updatedUser;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: e.toString());
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
