import 'package:flutter/material.dart';

// Auth Screens
import '../screens/auth/language_selection_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/registration_success_screen.dart';

// Main Screens
import '../screens/main_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/books/book_details_screen.dart';
import '../screens/books/book_preview_screen.dart';
import '../screens/payment/payment_method_screen.dart';
import '../screens/payment/payment_success_screen.dart';

class Routes {
  // Auth Routes
  static const String initial = '/';
  static const String language = '/language';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String emailVerification = '/email-verification';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String registrationSuccess = '/registration-success';

  // Main Routes
  static const String home = '/home';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';
  static const String bookDetails = '/book/details';
  static const String bookPreview = '/book/preview';
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
      emailVerification: (context) {
        final email = ModalRoute.of(context)?.settings.arguments as String?;
        return EmailVerificationScreen(email: email ?? '');
      },
      forgotPassword: (context) => const ForgotPasswordScreen(),
      resetPassword: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return ResetPasswordScreen(token: args?['token']);
      },
      registrationSuccess: (context) {
        final email = ModalRoute.of(context)?.settings.arguments as String?;
        return RegistrationSuccessScreen(email: email ?? '');
      },

      // Main Routes
      home: (context) => const MainScreen(),
      cart: (context) => const CartScreen(),
      wishlist: (context) => const WishlistScreen(),
      profile: (context) => const ProfileScreen(),

      // Book Routes
      bookDetails: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return BookDetailsScreen(book: args['book']);
      },
      bookPreview: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return BookPreviewScreen(book: args['book']);
      },

      // Payment Routes
      paymentMethod: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return PaymentMethodScreen(
          totalAmount: args['totalAmount'],
          onPaymentSuccess: args['onPaymentSuccess'],
        );
      },
      paymentSuccess: (context) => const PaymentSuccessScreen(),
    };
  }

  static bool requiresAuth(String route) {
    return [
      home,
      cart,
      wishlist,
      profile,
      bookDetails,
      bookPreview,
      paymentMethod,
      paymentSuccess,
    ].contains(route);
  }

  static bool isPublicRoute(String route) {
    return [
      initial,
      language,
      onboarding,
      login,
      register,
      emailVerification,
      forgotPassword,
      resetPassword,
      registrationSuccess,
    ].contains(route);
  }
}
