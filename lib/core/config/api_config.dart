import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  // Development mode detection
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

  // Base URLs for different environments
  static const String productionUrl = 'https://karshe-bookstore-backend.vercel.app';
  static const String emulatorUrl = 'http://10.0.2.2:5000';  // Android emulator
  static const String localDeviceUrl = 'http://192.168.100.229:5000';  // Local network

  // ✅ Automatic detection of Emulator vs. Real Device
  static String get baseUrl {
    if (isProduction) return productionUrl;

    bool isEmulator = _isRunningOnEmulator();
    return isEmulator ? emulatorUrl : localDeviceUrl;
  }

  // API URL with proper slash handling
  static String get apiUrl {
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    print('🌍 Using API URL: $base/api');  // Debug log
    return '$base/api';
  }

  // Auth endpoints
  static final auth = _AuthEndpoints();

  // Helper to create endpoint paths
  static String _endpoint(String path) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$apiUrl$cleanPath';
  }

  // User Endpoints
  static String get profile => _endpoint('/users/profile');
  static String get updateProfile => _endpoint('/users/profile');

  // Book Endpoints
  static String get books => _endpoint('/books');
  static String get categories => _endpoint('/categories');

  // Shopping Endpoints
  static String get cart => _endpoint('/cart');
  static String get wishlist => _endpoint('/wishlist');

  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Retry Configuration
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // 1 second

  /// ✅ **Automatic Emulator Detection for Android & iOS**
  static bool _isRunningOnEmulator() {
    if (kIsWeb) return false; // Web doesn't need this

    try {
      if (Platform.isAndroid) {
        return _androidIsEmulator();
      } else if (Platform.isIOS) {
        return _iosIsSimulator();
      }
    } catch (e) {
      print("⚠️ Error detecting emulator: $e");
    }
    return false;
  }

  /// ✅ **Detects Android Emulator**
  static bool _androidIsEmulator() {
    const emulatorIdentifiers = [
      "generic", "unknown", "emulator", "sdk_gphone",
      "sdk_google", "sdk", "goldfish", "ranchu"
    ];

    return emulatorIdentifiers.any((identifier) =>
        (Platform.environment["ANDROID_BOOTLOADER"]?.toLowerCase().contains(identifier) ?? false) ||
        (Platform.environment["ANDROID_BUILD"]?.toLowerCase().contains(identifier) ?? false) ||
        (Platform.environment["ANDROID_PRODUCT"]?.toLowerCase().contains(identifier) ?? false));
  }

  /// ✅ **Detects iOS Simulator**
  static bool _iosIsSimulator() {
    return Platform.environment["SIMULATOR_DEVICE_NAME"] != null;
  }
}

class _AuthEndpoints {
  final String base = '/auth';

  String get login => '$base/login';
  String get register => '$base/register';
  String get forgotPassword => '$base/forgot-password';
  String get resetPassword => '$base/reset-password';
  String get verifyEmail => '$base/verify-email';
  String get refreshToken => '$base/refresh-token';
}
