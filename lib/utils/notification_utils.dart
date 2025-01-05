import 'package:flutter/material.dart';
import '../core/constants/styles.dart';

class NotificationUtils {
  static void showError({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppStyles.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppStyles.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppStyles.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showAddedToCart({
    required BuildContext context,
    required String itemName,
    required VoidCallback onViewCart,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemName added to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: onViewCart,
          textColor: Colors.white,
        ),
        backgroundColor: AppStyles.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
