import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiTester {
  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<void> testConnection() async {
    try {
      print('\n🔍 Testing API Connection');
      print('Environment: ${kDebugMode ? "Development" : "Production"}');
      print('Base URL: ${ApiConfig.baseUrl}');
      print('API URL: ${ApiConfig.apiUrl}\n');

      // Test health endpoint
      await _testEndpoint(
        name: 'Health Check',
        method: 'GET',
        url: '${ApiConfig.baseUrl}/api/health',
      );

      // Test registration endpoint
      final testEmail = 'test${DateTime.now().millisecondsSinceEpoch}@example.com';
      await _testEndpoint(
        name: 'Registration',
        method: 'POST',
        url: '${ApiConfig.apiUrl}${ApiConfig.auth.register}',
        body: {
          'email': testEmail,
          'password': 'Test123!@#',
          'fullName': 'Test User',
        },
      );

      // Test login endpoint
      await _testEndpoint(
        name: 'Login',
        method: 'POST',
        url: '${ApiConfig.apiUrl}${ApiConfig.auth.login}',
        body: {
          'email': testEmail,
          'password': 'Test123!@#',
        },
      );

    } catch (e) {
      print('❌ Overall test failed: $e\n');
    }
  }

  static Future<void> _testEndpoint({
    required String name,
    required String method,
    required String url,
    Map<String, dynamic>? body,
  }) async {
    print('Testing $name endpoint...');
    try {
      late http.Response response;
      
      if (method == 'GET') {
        response = await http.get(
          Uri.parse(url),
          headers: _headers,
        ).timeout(const Duration(seconds: 5));
      } else if (method == 'POST') {
        response = await http.post(
          Uri.parse(url),
          headers: _headers,
          body: json.encode(body),
        ).timeout(const Duration(seconds: 5));
      }

      print('✅ $name endpoint responding');
      print('URL: $url');
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}\n');
    } catch (e) {
      print('❌ $name test failed');
      print('URL: $url');
      print('Error: $e\n');
    }
  }
}
