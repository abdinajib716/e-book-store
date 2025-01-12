class ApiConfig {
  // Automatically switches between development and production
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  
  // URLs for Android Emulator
  static const String productionUrl = 'https://karshe-bookstore-backend.vercel.app';
  // Use 10.0.2.2 for Android Emulator (maps to localhost on host machine)
  static const String developmentUrl = 'http://10.0.2.2:5000';
  
  // Base URL will automatically switch based on build mode
  static String get baseUrl => isProduction ? productionUrl : developmentUrl;
  
  // API URL with proper slash handling
  static String get apiUrl {
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    return '$base/api';
  }
  
  // Helper to create endpoint paths
  static String _endpoint(String path) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$apiUrl$cleanPath';
  }
  
  // Auth Endpoints
  static String get login => _endpoint('/auth/login');
  static String get register => _endpoint('/auth/register');
  static String get forgotPassword => _endpoint('/auth/forgot-password');
  static String get resetPassword => _endpoint('/auth/reset-password');
  static String get verifyEmail => _endpoint('/auth/verify-email');
  static String get resendVerification => _endpoint('/auth/resend-verification');
  
  // For backward compatibility
  static String get loginEndpoint => login;
  static String get registerEndpoint => register;
  static String get forgotPasswordEndpoint => forgotPassword;
  static String get resetPasswordEndpoint => resetPassword;
  static String get verifyEmailEndpoint => verifyEmail;
  static String get resendVerificationEndpoint => resendVerification;
  
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
