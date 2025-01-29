import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiTestHelper {
  static Future<void> testApi() async {
    print('\n🔍 Starting API Test...');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ));

      // ✅ Auto-detect API URL for Emulator & Physical Devices
      String apiUrl;
      if (kIsWeb) {
        apiUrl = "http://localhost:5000"; // Web testing
      } else if (Platform.isAndroid) {
        apiUrl = "http://10.0.2.2:5000"; // Android Emulator
      } else {
        apiUrl = "http://192.168.100.229:5000"; // Real Devices
      }

      final String endpoint = "$apiUrl/api/auth/register";

      print('🌐 Connecting to: $endpoint');
      print('📝 Request Headers: ${dio.options.headers}');

      final response = await dio.post(
        endpoint,
        data: {
          "email": "keedso716@gmail.com",
          "password": "Hnajiib12345\$",
          "fullName": "Karshe"
        },
      );

      print('\n✅ Connection Successful!');
      print('📊 Status Code: ${response.statusCode}');
      print('📝 Response Headers: ${response.headers}');
      print('📦 Response Data: ${response.data}');
    } on DioException catch (e) {
      print('\n❌ Connection Failed!');
      print('🔍 Error Type: ${e.type}');
      print('💬 Error Message: ${e.message}');

      if (e.response != null) {
        print('📡 Server Response:');
        print('  Status: ${e.response?.statusCode}');
        print('  Data: ${e.response?.data}');
      }

      // Debugging tips based on error type
      switch (e.type) {
        case DioExceptionType.badResponse:
          print('\n🚨 Server rejected the request! Possible issues:');
          print('• Email already registered?');
          print('• Password still not meeting validation rules?');
          print('• Server-side validation failed for another reason?');
          break;

        case DioExceptionType.connectionTimeout:
          print('\n💡 Debugging Tips:');
          print('• Check if the server is running');
          print('• Verify the IP address is correct');
          print('• Ensure you\'re connected to the right network');
          break;

        case DioExceptionType.connectionError:
          print('\n💡 Debugging Tips:');
          print('• Check your internet connection');
          print('• Verify the server URL is correct');
          print('• Make sure the server port (5000) is open');
          break;

        default:
          print('\n💡 General Tips:');
          print('• Check server logs for more details');
          print('• Verify API endpoint exists and is accessible');
      }
    } catch (e) {
      print('\n❌ Unexpected Error:');
      print('💬 Error Details: $e');
    } finally {
      print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }
}
