import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/styles.dart';
import '../../routes/routes.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  final String email;

  const RegistrationSuccessScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.08,
            vertical: screenSize.height * 0.04,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Icon(
                Icons.check_circle_outline,
                size: screenSize.width * 0.3,
                color: AppStyles.successColor,
              ).animate().scale(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                  ),
              SizedBox(height: screenSize.height * 0.04),

              // Success Title
              Text(
                'Registration Successful!',
                style: AppStyles.headingStyle.copyWith(
                  color: AppStyles.successColor,
                  fontSize: screenSize.width * 0.07,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn().slideY(
                    begin: 0.3,
                    curve: Curves.easeOut,
                  ),
              SizedBox(height: screenSize.height * 0.02),

              // Success Message
              Text(
                'We\'ve sent a verification code to:',
                style: AppStyles.bodyStyle.copyWith(
                  fontSize: screenSize.width * 0.04,
                  color: AppStyles.subtitleColor,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),
              SizedBox(height: screenSize.height * 0.01),

              // Email
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.04,
                  vertical: screenSize.height * 0.015,
                ),
                decoration: BoxDecoration(
                  color: AppStyles.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  email,
                  style: AppStyles.subheadingStyle.copyWith(
                    color: AppStyles.primaryColor,
                    fontSize: screenSize.width * 0.045,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideX(),
              SizedBox(height: screenSize.height * 0.04),

              // Instructions
              Text(
                'Please check your email and enter the verification code to complete your registration.',
                style: AppStyles.bodyStyle.copyWith(
                  fontSize: screenSize.width * 0.04,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms),
              SizedBox(height: screenSize.height * 0.06),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.emailVerification,
                      arguments: email,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue to Verification',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
