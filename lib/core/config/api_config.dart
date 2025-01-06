class ApiConfig {
  static const bool isProduction = true;
  
  static const String productionUrl = 'https://karshe-bookstore-backend.vercel.app';
  static const String developmentUrl = 'http://10.0.2.2:5000';
  
  static String get baseUrl => isProduction ? productionUrl : developmentUrl;
  
  // Auth Endpoints
  static String get loginEndpoint => '$baseUrl/api/auth/login';
  static String get registerEndpoint => '$baseUrl/api/auth/register';
  static String get forgotPasswordEndpoint => '$baseUrl/api/auth/forgot-password';
  static String get resetPasswordEndpoint => '$baseUrl/api/auth/reset-password';
  static String get verifyEmailEndpoint => '$baseUrl/api/auth/verify-email';
  static String get resendVerificationEndpoint => '$baseUrl/api/auth/resend-verification';
  
  // User Endpoints
  static String get profileEndpoint => '$baseUrl/api/users/profile';
  static String get updateProfileEndpoint => '$baseUrl/api/users/profile';
  
  // Book Endpoints
  static String get booksEndpoint => '$baseUrl/api/books';
  static String get categoriesEndpoint => '$baseUrl/api/categories';
  
  // Shopping Endpoints
  static String get cartEndpoint => '$baseUrl/api/cart';
  static String get wishlistEndpoint => '$baseUrl/api/wishlist';
  
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
