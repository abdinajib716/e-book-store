class ApiConfig {
  // Development mode detection
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  
  // Base URLs for different environments
  static const String productionUrl = 'https://karshe-bookstore-backend.vercel.app';
  static const String emulatorUrl = 'http://10.0.2.2:5000';  // Android emulator
  static const String localDeviceUrl = 'http://192.168.100.229:5000';  // Local network
  
  // Base URL selection based on environment
  static String get baseUrl {
    if (isProduction) return productionUrl;
    
    // For development, try to determine if running on emulator or real device
    bool isEmulator = false;  // You need to implement proper emulator detection
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
