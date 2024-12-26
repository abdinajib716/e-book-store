import 'package:flutter/material.dart';

// Auth Screens
import 'screens/auth/language_selection_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/email_verification_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/registration_success_screen.dart';

// Payment Screens
import 'screens/payment/payment_method_screen.dart';
import 'screens/payment/payment_success_screen.dart';

// Library Screens
import 'screens/library/my_books_screen.dart';
import 'screens/library/book_reader_screen.dart';
import 'screens/library/downloads_screen.dart';

// Main Screens
import 'screens/main_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/profile_screen.dart';

class Routes {
  // Auth Routes
  static const String initial = '/';
  static const String language = '/language';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String emailVerification = '/auth/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String registrationSuccess = '/registration-success';

  // Main Routes
  static const String home = '/home';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';

  // Library Routes
  static const String library = '/library';
  static const String bookReader = '/library/reader';
  static const String downloads = '/library/downloads';

  // Payment Routes
  static const String paymentMethod = '/payment/method';
  static const String paymentSuccess = '/payment/success';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Auth Routes
      initial: (context) => const LanguageSelectionScreen(),
      language: (context) => const LanguageSelectionScreen(),
      onboarding: (context) => const OnboardingScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      emailVerification: (context) => const EmailVerificationScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      registrationSuccess: (context) => const RegistrationSuccessScreen(),

      // Main Routes
      home: (context) => const MainScreen(),
      cart: (context) => const CartScreen(),
      wishlist: (context) => const WishlistScreen(),
      profile: (context) => const ProfileScreen(),

      // Payment Routes
      paymentMethod: (context) => const PaymentMethodScreen(),
      paymentSuccess: (context) => const PaymentSuccessScreen(),

      // Library Routes
      library: (context) => const MyBooksScreen(),
      bookReader: (context) => const BookReaderScreen(),
      downloads: (context) => const DownloadsScreen(),
    };
  }

  // Helper method to check if a route requires authentication
  static bool requiresAuth(String route) {
    return route.startsWith('/auth/') ||
        route.startsWith('/library/') ||
        route.startsWith('/payment/') ||
        route == home ||
        route == cart ||
        route == wishlist ||
        route == profile;
  }

  // Helper method to check if a route is public
  static bool isPublicRoute(String route) {
    return route == initial ||
        route == language ||
        route == onboarding ||
        route == login ||
        route == register ||
        route == forgotPassword;
  }
}
