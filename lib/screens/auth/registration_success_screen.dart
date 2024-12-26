import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/styles.dart';
import '../../routes.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppStyles.successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppStyles.successColor,
                  size: 60,
                ),
              ).animate().scale(),
              const SizedBox(height: 32),
              Text(
                'Registration Successful!',
                style: AppStyles.headingStyle.copyWith(
                  color: AppStyles.successColor,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(),
              const SizedBox(height: 16),
              Text(
                'Your account has been created successfully.\nWelcome to Book Store!',
                style: AppStyles.bodyStyle.copyWith(
                  color: AppStyles.subtitleColor,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppStyles.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Explore Books',
                      'Browse through our collection of books',
                      Icons.menu_book_rounded,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    _buildInfoRow(
                      'Read Anywhere',
                      'Access your books on any device',
                      Icons.devices_rounded,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    _buildInfoRow(
                      'Track Progress',
                      'Keep track of your reading progress',
                      Icons.trending_up_rounded,
                    ),
                  ],
                ),
              ).animate().slideY().fadeIn(),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.home,
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Go to Home'),
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
              ).animate().fadeIn().scale(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppStyles.successColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppStyles.successColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.subheadingStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppStyles.bodyStyle.copyWith(
                  color: AppStyles.subtitleColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
