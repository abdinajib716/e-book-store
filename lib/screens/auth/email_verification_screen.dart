import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/styles.dart';
import '../../routes.dart';
import '../../utils/notification_utils.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        setState(() {});
      });
    }
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _handleVerification() {
    if (_formKey.currentState!.validate()) {
      final code = _controllers.map((c) => c.text).join();
      if (code.length != 6) {
        NotificationUtils.showError(
          context: context,
          message: 'Please enter the complete verification code',
        );
        return;
      }

      // TODO: Implement verification logic
      NotificationUtils.showSuccess(
        context: context,
        message: 'Email verified successfully!',
      );
      Navigator.pushReplacementNamed(context, Routes.registrationSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = args?['email'] ?? 'your email';

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // App Logo
              Image.asset(
                'assets/icons/app_icon.png',
                height: 100,
                width: 100,
              ).animate().scale(),
              const SizedBox(height: 40),
              // Title
              Text(
                'Verify Your Email',
                style: AppStyles.headingStyle.copyWith(
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(),
              const SizedBox(height: 8),
              Text(
                'We\'ve sent a verification code to\n$email',
                style: AppStyles.bodyStyle.copyWith(
                  color: AppStyles.subtitleColor,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(),
              const SizedBox(height: 48),
              // Verification Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: 50,
                          height: 60,
                          child: TextFormField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: _focusNodes[index].hasFocus
                                  ? AppStyles.primaryColor.withOpacity(0.1)
                                  : AppStyles.surfaceColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppStyles.primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) => _onCodeChanged(value, index),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ).animate().slideX(),
                    const SizedBox(height: 32),
                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleVerification,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Verify Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).animate().fadeIn().scale(),
                    const SizedBox(height: 24),
                    // Resend Code
                    TextButton.icon(
                      onPressed: () {
                        NotificationUtils.showSuccess(
                          context: context,
                          message: 'Verification code resent!',
                        );
                      },
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: AppStyles.primaryColor,
                      ),
                      label: Text(
                        'Resend Code',
                        style: TextStyle(
                          color: AppStyles.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Help Text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppStyles.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppStyles.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Check your spam folder if you haven\'t received the code',
                        style: TextStyle(
                          color: AppStyles.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
