import '../services/api_client.dart';
import '../../core/exceptions/api_exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(String email, String password, String fullName);
  Future<Map<String, dynamic>> getCurrentUser();
  Future<bool> verifyEmail(String email, String code);
  Future<void> sendVerificationEmail(String email);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<Map<String, dynamic>> refreshToken(String oldToken);
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> userData);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Attempting login for email: $email');
      
      final response = await _apiClient.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      // Check for success flag
      if (response['success'] != true) {
        print('Login failed: success flag is false');
        throw ApiException(
          message: response['message'] ?? 'Login failed',
        );
      }

      // Validate user and token
      final user = response['user'];
      final token = response['token'];

      if (user == null || token == null) {
        print('Login failed: missing user or token');
        throw ApiException(message: 'Invalid response: missing user or token');
      }

      // Return response in the expected format
      return {
        'data': {
          'user': user,
          'token': token,
        }
      };
    } on ApiException {
      print('API Exception during login');
      rethrow;
    } catch (e) {
      print('Unexpected error during login: $e');
      throw ApiException(message: 'Login failed: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> register(String email, String password, String fullName) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        body: {
          'email': email,
          'password': password,
          'fullName': fullName,
        },
      );
      return response;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/auth/me');
      return response;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<bool> verifyEmail(String email, String code) async {
    try {
      final response = await _apiClient.post(
        '/auth/verify-email',
        body: {
          'email': email,
          'code': code,
        },
      );
      return response['success'] as bool;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> sendVerificationEmail(String email) async {
    try {
      await _apiClient.post(
        '/auth/resend-verification',
        body: {'email': email},
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _apiClient.post(
        '/auth/forgot-password',
        body: {'email': email},
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _apiClient.post(
        '/auth/reset-password',
        body: {
          'token': token,
          'password': newPassword,
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String oldToken) async {
    try {
      final response = await _apiClient.post(
        '/auth/refresh-token',
        headers: {'Authorization': 'Bearer $oldToken'},
      );
      return response;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> userData) async {
    try {
      final response = await _apiClient.put(
        '/auth/me',
        body: userData,
      );
      return response;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
