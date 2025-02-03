import 'dart:async';
import 'dart:core'; // Added Timer import
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/styles.dart';
import '../../routes/routes.dart';
import '../../../utils/notification_utils.dart';
import '../../../core/exceptions/api_exceptions.dart';
import '../../providers/auth_provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  bool _isResending = false;
  int _resendTimer = 0;
  Timer? _timer;
  late AnimationController _animationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();

    for (var i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 30;
      _isResending = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
          } else {
            _isResending = false;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _handleResendCode() async {
    if (_isResending) return;

    final authProvider = context.read<AuthProvider>();
    try {
      final success = await authProvider.sendVerificationEmail(widget.email);
      if (success && mounted) {
        NotificationUtils.showSuccess(
          context: context,
          message: 'Verification code has been resent to your email',
        );
        _startResendTimer();
      }
    } catch (e) {
      if (!mounted) return;
      NotificationUtils.showError(
        context: context,
        message: 'Failed to resend verification code',
      );
    }
  }

  Future<void> _handleVerification() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      final code = _controllers.map((c) => c.text).join();
      if (code.length != 6) {
        setState(() {
          _isLoading = false;
        });
        NotificationUtils.showError(
          context: context,
          message: 'Please enter the complete verification code',
        );
        return;
      }

      final authProvider = context.read<AuthProvider>();
      try {
        print('🔍 Attempting verification with code: $code');
        final success = await authProvider.verifyEmail(widget.email, code);
        print('✅ Verification result: $success');

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        if (success) {
          NotificationUtils.showSuccess(
            context: context,
            message: 'Email verified successfully',
          );
          Navigator.pushReplacementNamed(context, Routes.home);
        } else {
          NotificationUtils.showError(
            context: context,
            message: 'Invalid verification code. Please try again.',
          );
        }
      } catch (e) {
        print('❌ Verification error caught: $e');
        if (!mounted) return;
        _handleVerificationError(e);
      }
    }
  }

  void _handleVerificationError(dynamic error) {
    setState(() {
      _isLoading = false;
    });

    if (error is ApiException) {
      NotificationUtils.showError(
        context: context,
        message: error.userMessage,
      );
    } else {
      NotificationUtils.showError(
        context: context,
        message: 'Verification failed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.08,
              vertical: screenSize.height * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenSize.height * 0.02),
                // App Logo with Animation
                Center(
                  child: Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                      height: screenSize.height * 0.15,
                    ),
                  )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scaleXY(
                        begin: 0.95,
                        end: 1.05,
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeInOut,
                      ),
                ),
                SizedBox(height: screenSize.height * 0.03),
                // Title with Animation
                Text(
                  'Verify Your Email',
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: screenSize.width * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().slideY(
                      begin: 0.3,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    ),
                SizedBox(height: screenSize.height * 0.02),
                // Description with Animation
                Text(
                  'Enter the verification code sent to:',
                  style: AppStyles.bodyStyle.copyWith(
                    color: AppStyles.subtitleColor,
                    fontSize: screenSize.width * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 500),
                    ),
                SizedBox(height: screenSize.height * 0.01),
                // Email with Animation
                Text(
                  widget.email,
                  style: AppStyles.bodyStyle.copyWith(
                    color: AppStyles.primaryColor,
                    fontSize: screenSize.width * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 500),
                    ),
                SizedBox(height: screenSize.height * 0.04),
                // Code Input Fields with Animation
                Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: screenSize.width * 0.12,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: screenSize.width * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                              ),
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
                      )
                          .animate(
                            delay: Duration(milliseconds: 100 * index),
                          )
                          .slideX(
                            begin: 0.2,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                          )
                          .fadeIn(),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.04),
                // Verify Button with Animation
                ElevatedButton(
                  onPressed: _handleVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ).animate().scale(
                      delay: const Duration(milliseconds: 800),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    ),
                SizedBox(height: screenSize.height * 0.02),
                // Resend Code Section with Animation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Didn\'t receive the code? ',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.035,
                        color: AppStyles.subtitleColor,
                      ),
                    ),
                    TextButton(
                      onPressed: _isResending ? null : _handleResendCode,
                      style: TextButton.styleFrom(
                        foregroundColor: AppStyles.primaryColor,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        _isResending
                            ? 'Resend in ${_resendTimer}s'
                            : 'Resend Code',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.035,
                          fontWeight: FontWeight.w600,
                          color: _isResending
                              ? AppStyles.subtitleColor
                              : AppStyles.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(
                      delay: const Duration(milliseconds: 1000),
                      duration: const Duration(milliseconds: 500),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
