class ApiConstants {
  static const String baseUrl = 'https://karshe-bookstore.kokapk.com';
  static const String apiUrl = '$baseUrl/api';
  
  // Auth endpoints
  static const String login = '$apiUrl/auth/login';
  static const String register = '$apiUrl/auth/register';
  static const String forgotPassword = '$apiUrl/auth/forgot-password';
  static const String resetPassword = '$apiUrl/auth/reset-password';
  static const String verifyEmail = '$apiUrl/auth/verify-email';
  
  // User endpoints
  static const String profile = '$apiUrl/users/profile';
  static const String updateProfile = '$apiUrl/users/profile';
  
  // Book endpoints
  static const String books = '$apiUrl/books';
  static const String categories = '$apiUrl/categories';
  
  // Cart endpoints
  static const String cart = '$apiUrl/cart';
  
  // Wishlist endpoints
  static const String wishlist = '$apiUrl/wishlist';
}
