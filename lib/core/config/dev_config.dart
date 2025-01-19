import 'package:flutter/foundation.dart';

class DevConfig {
  // Check if running on real device
  static bool get isRealDevice => !kDebugMode;

  // Get correct localhost URL based on platform
  static const String localHostUrl = 'http://192.168.100.229:3000';

  // Add other development configuration as needed
  static const bool enableLogging = true;
  static const bool showDevTools = true;

  // Development API configuration
  static String get devApiUrl {
    if (isRealDevice) {
      return localHostUrl;
    }
    return 'http://10.0.2.2:5000'; // Default emulator configuration
  }

  // Connection test endpoints
  static final List<String> connectionTestUrls = [
    'https://www.google.com',       // Most reliable
    'https://www.cloudflare.com',   // Secondary reliable
    'https://www.apple.com',        // Tertiary reliable
  ];

  // Connection timeout durations
  static const connectionTimeout = Duration(seconds: 15);
  static const apiTimeout = Duration(seconds: 30);
}
