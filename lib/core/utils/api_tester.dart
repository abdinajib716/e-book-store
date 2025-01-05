import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiTester {
  static Future<void> testAuthEndpoints() async {
    try {
      print('🔍 Testing API Endpoints...\n');

      // Test 1: Health Check
      print('Test 1: Health Check');
      final healthResponse = await http.get(Uri.parse('${ApiConfig.baseUrl}/health'));
      print('Status: ${healthResponse.statusCode}');
      print('Response: ${healthResponse.body}\n');

      // Test 2: Registration
      print('Test 2: Registration');
      final registrationResponse = await http.post(
        Uri.parse(ApiConfig.registerEndpoint),
        headers: ApiConfig.headers,
        body: json.encode({
          'email': 'test${DateTime.now().millisecondsSinceEpoch}@example.com',
          'password': 'Test123!@#',
          'fullName': 'Test User',
        }),
      );
      print('Status: ${registrationResponse.statusCode}');
      print('Response: ${registrationResponse.body}\n');

      // Test 3: Login with wrong password
      print('Test 3: Login with wrong password');
      final wrongLoginResponse = await http.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: ApiConfig.headers,
        body: json.encode({
          'email': 'test@example.com',
          'password': 'wrongpassword',
        }),
      );
      print('Status: ${wrongLoginResponse.statusCode}');
      print('Response: ${wrongLoginResponse.body}\n');

      // Test 4: Login with correct credentials
      print('Test 4: Login with correct credentials');
      final loginResponse = await http.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: ApiConfig.headers,
        body: json.encode({
          'email': 'test@example.com',
          'password': 'Test123!@#',
        }),
      );
      print('Status: ${loginResponse.statusCode}');
      print('Response: ${loginResponse.body}\n');

      if (loginResponse.statusCode == 200) {
        final token = json.decode(loginResponse.body)['data']['token'];

        // Test 5: Get Profile with token
        print('Test 5: Get Profile');
        final profileResponse = await http.get(
          Uri.parse(ApiConfig.profileEndpoint),
          headers: ApiConfig.authHeaders(token),
        );
        print('Status: ${profileResponse.statusCode}');
        print('Response: ${profileResponse.body}\n');
      }

      print('✅ API Test Complete!\n');
    } catch (e) {
      print('❌ Error during API test: $e');
    }
  }

  static Future<Map<String, dynamic>> checkApiStatus() async {
    final results = <String, dynamic>{};
    
    try {
      // Check Base URL
      results['baseUrl'] = ApiConfig.baseUrl;
      
      // Check Health Endpoint
      try {
        final response = await http.get(
          Uri.parse('${ApiConfig.baseUrl}/health'),
          headers: ApiConfig.headers,
        ).timeout(const Duration(seconds: 5));
        
        results['health'] = {
          'status': response.statusCode,
          'response': json.decode(response.body),
        };
      } catch (e) {
        results['health'] = {'error': e.toString()};
      }
      
      // Check Auth Endpoints
      results['endpoints'] = {
        'login': ApiConfig.loginEndpoint,
        'register': ApiConfig.registerEndpoint,
        'forgotPassword': ApiConfig.forgotPasswordEndpoint,
        'verifyEmail': ApiConfig.verifyEmailEndpoint,
      };
      
    } catch (e) {
      results['error'] = e.toString();
    }
    
    return results;
  }
}
