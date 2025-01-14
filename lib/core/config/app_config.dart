class AppConfig {
  // API URLs
  static const String emulatorUrl = 'http://10.0.2.2:5000';
  static const String localDeviceUrl = 'http://192.168.100.229:5000';
  static const String productionUrl = 'https://karshe-bookstore-backend.vercel.app';

  // Environment names
  static const String local = 'local';
  static const String dev = 'dev';
  static const String prod = 'prod';

  // Get current environment
  static String get environment => const String.fromEnvironment(
        'ENVIRONMENT',
        defaultValue: dev,
      );

  // Get API URL based on environment
  static String get baseUrl {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return productionUrl;
    }
    
    // For development, determine if running on emulator or real device
    bool isEmulator = true; // TODO: Implement proper emulator detection
    return isEmulator ? emulatorUrl : localDeviceUrl;
  }

  // API version
  static const String apiVersion = 'v1';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 5);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  // Development flags
  static bool get isDevelopment => !const bool.fromEnvironment('dart.vm.product');
  static bool get showDevTools => isDevelopment;
  static bool get enableLogging => isDevelopment;
}
