import 'package:dio/dio.dart';
import '../../core/exceptions/api_exceptions.dart';
import '../services/api_client.dart';

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

      final responseData = response.data as Map<String, dynamic>;
      print('Login response data: $responseData');
      
      // Validate response structure
      if (!responseData.containsKey('success') || !responseData.containsKey('data')) {
        print('Invalid response structure: $responseData');
        throw ApiException(message: 'Invalid response format');
      }

      return responseData;
    } catch (e) {
      print('Error during login: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: e.toString());
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

      final data = response.data;
      if (data == null) {
        throw ApiException(message: 'Invalid response from server');
      }

      // Ensure we return a Map<String, dynamic>
      if (data is! Map<String, dynamic>) {
        return {'data': data};
      }

      return data;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/auth/me');
      final data = response.data as Map<String, dynamic>;
      return {'data': data};
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<bool> verifyEmail(String email, String code) async {
    try {
      print('📧 Verifying email: $email with code: $code');
      
      final response = await _apiClient.post(
        '/auth/verify-email',
        body: {
          'email': email,
          'code': code,
        },
      );

      final data = response.data;
      print('📧 Verification response: $data');
      
      if (data == null) {
        throw ApiException(message: 'Invalid response from server');
      }

      if (data is Map<String, dynamic>) {
        // Check for any error response
        if (data['error'] != null) {
          throw ApiException(
            message: data['message'] ?? 'Verification failed',
            statusCode: response.statusCode,
            data: data
          );
        }

        return data['success'] == true;
      }

      throw ApiException(message: 'Invalid response format from server');
    } catch (e) {
      print('❌ Email verification error: $e');
      if (e is ApiException) {
        rethrow;
      }
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
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
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
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
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
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
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

      final data = response.data as Map<String, dynamic>;
      return {'data': data};
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
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

      final data = response.data as Map<String, dynamic>;
      return {'data': data};
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: e.toString());
    }
  }
}
