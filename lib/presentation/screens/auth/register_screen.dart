import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/styles.dart';
import '../../providers/auth_provider.dart';
import '../../routes/routes.dart';
import '../../../utils/notification_utils.dart';
import 'mixins/connectivity_mixin.dart';

class RegisterScreen extends StatefulWidget {
  final String? initialEmail;
  const RegisterScreen({super.key, this.initialEmail});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin, ConnectivityMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.08,
                      vertical: screenSize.height * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App Logo with Animation
                        Center(
                          child: Hero(
                            tag: 'app_logo',
                            child: Image.asset(
                              'assets/icons/app_icon.png',
                              height: screenSize.height * 0.15,
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
                        ),

                        const SizedBox(height: 24),

                        // Title with Animation
                        Text(
                          'Create Account',
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

                        const SizedBox(height: 8),

                        Text(
                          'Join our community of book lovers',
                          style: AppStyles.bodyStyle.copyWith(
                            color: AppStyles.subtitleColor,
                            fontSize: screenSize.width * 0.04,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(
                              delay: const Duration(milliseconds: 300),
                              duration: const Duration(milliseconds: 500),
                            ),

                        const SizedBox(height: 32),

                        // Form with Staggered Animations
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              ...[
                                _buildTextField(
                                  controller: _nameController,
                                  label: 'Full Name',
                                  hint: 'Enter your full name',
                                  icon: Icons.person_outline,
                                  validator: _validateFullName,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hint: 'Enter your email',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  validator: _validatePassword,
                                  onChanged: (value) => setState(() {}),
                                ),
                                if (_passwordController.text.isNotEmpty)
                                  _buildPasswordStrengthIndicator(
                                      _passwordController.text),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: _confirmPasswordController,
                                  label: 'Confirm Password',
                                  hint: 'Confirm your password',
                                  icon: Icons.lock_outline,
                                  isConfirmPassword: true,
                                  validator: _validateConfirmPassword,
                                ),
                              ]
                                  .animate(
                                    interval: const Duration(milliseconds: 100),
                                  )
                                  .slideX(
                                    begin: -0.2,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                  )
                                  .fadeIn(),

                              const SizedBox(height: 32),

                              // Register Button with Animation
                              _buildRegisterButton(authProvider.isLoading)
                                  .animate()
                                  .scale(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  ),

                              const SizedBox(height: 24),

                              // Login Link with Animation
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: AppStyles.bodyStyle.copyWith(
                                      color: AppStyles.subtitleColor,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _animationController.reverse().then((_) {
                                        Navigator.pushReplacementNamed(
                                            context, Routes.login);
                                      });
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: AppStyles.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ).animate().fadeIn(
                                    delay: const Duration(milliseconds: 800),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                buildRetryButton(
                  onRetry: () => setState(() {}),
                  text: 'Retry Connection',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    FocusNode? focusNode,
    bool isPassword = false,
    bool isConfirmPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                color: AppStyles.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              obscureText: isPassword
                  ? _obscurePassword
                  : (isConfirmPassword ? _obscureConfirmPassword : false),
              keyboardType: keyboardType,
              validator: validator,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 15,
                color: AppStyles.textColor,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: AppStyles.subtitleColor,
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  icon,
                  color: AppStyles.primaryColor,
                  size: 20,
                ),
                suffixIcon: (isPassword || isConfirmPassword)
                    ? IconButton(
                        icon: Icon(
                          isPassword
                              ? (_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility)
                              : (_obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                          color: AppStyles.primaryColor,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isPassword) {
                              _obscurePassword = !_obscurePassword;
                            } else {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            }
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppStyles.primaryColor,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppStyles.errorColor,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppStyles.errorColor,
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(String password) {
    if (password.isEmpty) return const SizedBox.shrink();

    int strength = 0;
    String message = 'Very Weak';
    Color color = AppStyles.errorColor;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    switch (strength) {
      case 0:
      case 1:
        message = 'Very Weak';
        color = AppStyles.errorColor;
        break;
      case 2:
        message = 'Weak';
        color = Colors.orange;
        break;
      case 3:
        message = 'Medium';
        color = Colors.yellow[700]!;
        break;
      case 4:
        message = 'Strong';
        color = Colors.lightGreen;
        break;
      case 5:
        message = 'Very Strong';
        color = AppStyles.successColor;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4),
      child: Row(
        children: [
          Icon(
            strength > 2 ? Icons.check_circle_outline : Icons.info_outline,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            message,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyles.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!await checkConnectivity()) return;

    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      try {
        await authProvider.register(
              _emailController.text,
              _passwordController.text,
              _nameController.text,
            );
        if (mounted) {
          NotificationUtils.showSuccess(
            context: context,
            message: 'Registration successful! Please verify your email.',
          );
          Navigator.pushReplacementNamed(
            context,
            Routes.emailVerification,
            arguments: _emailController.text,
          );
        }
      } catch (e) {
        if (!mounted) return;

        final message = e.toString();

        if (message.contains('already registered')) {
          NotificationUtils.showInfo(
            context: context,
            message: message,
          );
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              Navigator.pushReplacementNamed(
                context,
                Routes.login,
                arguments: _emailController.text,
              );
            }
          });
        } else {
          NotificationUtils.showError(
            context: context,
            message: message,
          );
        }
      } finally {
        setState(() {
          _animationController.forward();
        });
      }
    }
  }
}
