import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/config/api_config.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      print('Attempting registration with endpoint: ${ApiConfig.registerEndpoint}');
      
      final body = {
        'name': name,
        'email': email,
        'password': password,
      };
      print('Request body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(ApiConfig.registerEndpoint),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        await storage.write(key: 'token', value: data['token']);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false, 
          'message': data['message'] ?? 'Registration failed',
          'statusCode': response.statusCode,
          'error': data
        };
      }
    } catch (e, stackTrace) {
      print('Registration error: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false, 
        'message': 'Network error: $e',
        'error': e.toString(),
        'stackTrace': stackTrace.toString()
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Attempting login with endpoint: ${ApiConfig.loginEndpoint}');
      
      final body = {
        'email': email,
        'password': password,
      };
      print('Request body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await storage.write(key: 'token', value: data['token']);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false, 
          'message': data['message'] ?? 'Login failed',
          'statusCode': response.statusCode,
          'error': data
        };
      }
    } catch (e, stackTrace) {
      print('Login error: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false, 
        'message': 'Network error: $e',
        'error': e.toString(),
        'stackTrace': stackTrace.toString()
      };
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      print('Attempting forgot password with endpoint: ${ApiConfig.forgotPasswordEndpoint}');
      
      final body = {
        'email': email,
      };
      print('Request body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(ApiConfig.forgotPasswordEndpoint),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'Password reset request failed',
        'statusCode': response.statusCode,
        'error': data
      };
    } catch (e, stackTrace) {
      print('Forgot password error: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false, 
        'message': 'Network error: $e',
        'error': e.toString(),
        'stackTrace': stackTrace.toString()
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword(String token, String password) async {
    try {
      print('Attempting reset password with endpoint: ${ApiConfig.resetPasswordEndpoint}');
      
      final body = {
        'token': token,
        'password': password,
      };
      print('Request body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(ApiConfig.resetPasswordEndpoint),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'Password reset failed',
        'statusCode': response.statusCode,
        'error': data
      };
    } catch (e, stackTrace) {
      print('Reset password error: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false, 
        'message': 'Network error: $e',
        'error': e.toString(),
        'stackTrace': stackTrace.toString()
      };
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
}
