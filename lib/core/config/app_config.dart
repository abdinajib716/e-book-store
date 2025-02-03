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

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const Duration healthCheckTimeout = Duration(seconds: 5);

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration maxRetryDelay = Duration(seconds: 10);

  // Cache configuration
  static const Duration cacheDuration = Duration(minutes: 5);
  static const int maxCacheItems = 100;

  // Development flags
  static bool get isDevelopment => !const bool.fromEnvironment('dart.vm.product');
  static bool get showDevTools => isDevelopment;
  static bool get enableLogging => isDevelopment;

  // Debug flags
  static bool get verboseLogging => isDevelopment;
  static bool get showNetworkCalls => isDevelopment;
  static bool get showPerformanceOverlay => isDevelopment;

  // Error reporting
  static bool get reportErrors => !isDevelopment;
  static const int maxErrorRetries = 3;
}
