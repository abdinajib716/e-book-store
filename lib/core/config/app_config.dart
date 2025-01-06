class AppConfig {
  static const String localApiUrl = 'http://10.0.2.2:5000/api';
  static const String devApiUrl = 'https://karshe-bookstore-backend.vercel.app/api';
  static const String prodApiUrl = 'https://karshe-bookstore-backend.vercel.app/api';

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
  static String get apiBaseUrl {
    switch (environment) {
      case local:
        return localApiUrl;
      case prod:
        return prodApiUrl;
      case dev:
      default:
        return devApiUrl;
    }
  }

  // Is development mode
  static bool get isDevelopment => environment != prod;

  // Is production mode
  static bool get isProduction => environment == prod;

  // Is local mode
  static bool get isLocal => environment == local;
}
