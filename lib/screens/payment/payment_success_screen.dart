import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/styles.dart';
import '../../providers/cart_provider.dart';
import '../../routes.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  String _getPaymentMethodName(String methodId) {
    switch (methodId) {
      case 'evc':
        return 'EVC PLUS';
      case 'zaad':
        return 'ZAAD SERVICE';
      case 'sahal':
        return 'SAHAL';
      default:
        return 'UNKNOWN';
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final methodId = args['methodId'] as String;
    final amount = args['amount'] as double;
    final phone = args['phone'] as String;

    // Clear the cart after successful payment
    Future.microtask(() {
      Provider.of<CartProvider>(context, listen: false).clear();
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppStyles.successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppStyles.successColor,
                  size: 48,
                ),
              ).animate(delay: 300.ms).scale(),
              const SizedBox(height: 24),
              Text(
                'Payment Successful!',
                style: AppStyles.headingStyle.copyWith(
                  color: AppStyles.successColor,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 400.ms).fadeIn(),
              const SizedBox(height: 8),
              Text(
                'Thank you for your purchase',
                style: AppStyles.bodyStyle.copyWith(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 500.ms).fadeIn(),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Payment Method',
                      _getPaymentMethodName(methodId),
                      AppStyles.successColor,
                      Icons.credit_card_outlined,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    _buildDetailRow(
                      'Amount Paid',
                      '\$${amount.toStringAsFixed(2)}',
                      AppStyles.successColor,
                      Icons.attach_money_rounded,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    _buildDetailRow(
                      'Phone Number',
                      '+252 $phone',
                      AppStyles.successColor,
                      Icons.phone_outlined,
                    ),
                  ],
                ),
              ).animate(delay: 600.ms)
                .slideY(begin: 0.3, duration: 500.ms)
                .fadeIn(duration: 500.ms),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.library,
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.menu_book_rounded),
                  label: const Text('Go to Library'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.successColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate(delay: 800.ms)
                .fadeIn(duration: 300.ms)
                .scale(duration: 300.ms),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.home,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text('Back to Home'),
                style: TextButton.styleFrom(
                  foregroundColor: AppStyles.successColor,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).animate(delay: 900.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
