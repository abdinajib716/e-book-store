import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ApiConfig {
  // Development mode detection
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

  // Base URLs for different environments
  static const String productionUrl =
      'https://karshe-bookstore-backend.vercel.app';
  static const String emulatorUrl =
      'http://10.0.2.2:5000/api'; // Android emulator
  static const String defaultPort = '5000';

  // Default headers
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Connection timeouts - reduced for faster error detection
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 10);

  // Server discovery - simplified for faster response
  static Future<String> get apiUrl async {
    // For emulator, always use 10.0.2.2
    if (Platform.isAndroid && !isProduction) {
      print('📱 Using emulator URL: $emulatorUrl');
      return emulatorUrl;
    }

    if (isProduction) {
      print('🌍 Using production URL: $productionUrl');
      return productionUrl;
    }

    // Development fallback
    final devUrl = 'http://localhost:$defaultPort/api';
    print('🔧 Using development URL: $devUrl');
    return devUrl;
  }

  // Auth endpoints
  static String get loginPath => '/auth/login';
  static String get registerPath => '/auth/register';
  static String get forgotPasswordPath => '/auth/forgot-password';
  static String get resetPasswordPath => '/auth/reset-password';
  static String get refreshTokenPath => '/auth/refresh-token';
  static String get logoutPath => '/auth/logout';
  static String get verifyEmailPath => '/auth/verify-email';

  // User endpoints
  static String get profilePath => '/users/profile';
  static String get updateProfilePath => '/users/profile';

  // Book endpoints
  static String get booksPath => '/books';
  static String get categoriesPath => '/categories';

  // Shopping endpoints
  static String get cartPath => '/cart';
  static String get wishlistPath => '/wishlist';

  // Health check endpoint
  static String get healthPath => '/health';
}
