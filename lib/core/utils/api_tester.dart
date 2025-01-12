import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiTester {
  static Future<void> testConnection() async {
    try {
      print('\n🔍 Testing API Connection');
      print('Environment: ${kDebugMode ? "Development (Local)" : "Production (Vercel)"}');
      print('Base URL: ${ApiConfig.baseUrl}\n');

      // Test basic connection
      print('Testing basic connection...');
      try {
        final response = await http.get(
          Uri.parse('${ApiConfig.baseUrl}/health'),
          headers: ApiConfig.headers,
        ).timeout(const Duration(seconds: 5));
        
        print('✓ Connection successful');
        print('Status: ${response.statusCode}');
        print('Response: ${response.body}\n');
      } catch (e) {
        print('✗ Connection failed: $e\n');
        return;
      }

      // Test registration endpoint
      print('Testing registration endpoint...');
      try {
        final testEmail = 'test${DateTime.now().millisecondsSinceEpoch}@example.com';
        final response = await http.post(
          Uri.parse(ApiConfig.registerEndpoint),
          headers: ApiConfig.headers,
          body: json.encode({
            'email': testEmail,
            'password': 'Test123!@#',
            'fullName': 'Test User',
          }),
        ).timeout(const Duration(seconds: 5));

        print('✓ Registration endpoint responding');
        print('Status: ${response.statusCode}');
        print('Response: ${response.body}\n');
      } catch (e) {
        print('✗ Registration test failed: $e\n');
      }

    } catch (e) {
      print('❌ Test failed: $e\n');
    }
  }
}
