import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/styles.dart';
import '../../providers/auth_provider.dart';
import '../../routes/routes.dart';
import '../../../utils/notification_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = ModalRoute.of(context)?.settings.arguments as String?;
      if (email != null) {
        _emailController.text = email;
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      try {
        final success = await authProvider.login(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;

        if (success && authProvider.currentUser != null) {
          NotificationUtils.showSuccess(
            context: context,
            message: 'Login successful!',
          );
          
          // Wait for the success message to show
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (!mounted) return;
          
          // Navigate to home screen
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.home,
            (route) => false, // Clear the navigation stack
          );
        } else {
          // Login failed but no exception was thrown
          NotificationUtils.showError(
            context: context,
            message: authProvider.error ?? 'Login failed. Please try again.',
          );
        }
      } catch (e) {
        if (!mounted) return;

        final message = e.toString();

        if (message.contains('not registered')) {
          NotificationUtils.showError(
            context: context,
            message: message,
          );
          await Future.delayed(const Duration(milliseconds: 1500));
          
          if (!mounted) return;
          
          Navigator.pushNamed(
            context,
            Routes.register,
            arguments: _emailController.text,
          );
        } else if (message.contains('incorrect password')) {
          NotificationUtils.showError(
            context: context,
            message: message,
          );
          _passwordController.clear();
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        } else {
          NotificationUtils.showError(
            context: context,
            message: 'An error occurred. Please try again.',
          );
        }
      }
    }
  }

  Widget _buildLoginButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppStyles.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
              'Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) => CheckboxListTile(
        value: auth.rememberMe,
        onChanged: (value) => auth.setRememberMe(value ?? false),
        title: Text(
          'Remember me',
          style: AppStyles.bodyStyle.copyWith(
            fontSize: 14,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final authProvider = context.watch<AuthProvider>();
    
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.08,
              vertical: screenSize.height * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenSize.height * 0.04),
                // App Logo with Animation
                Center(
                  child: Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                      height: screenSize.height * 0.15,
                    ),
                  ).animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  ).scaleXY(
                    begin: 0.95,
                    end: 1.05,
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.04),
                // Welcome Text with Animation
                Text(
                  'Welcome Back!',
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
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  'Sign in to continue your reading journey',
                  style: AppStyles.bodyStyle.copyWith(
                    color: AppStyles.subtitleColor,
                    fontSize: screenSize.width * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 500),
                ),
                SizedBox(height: screenSize.height * 0.06),
                // Login Form with Animations
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppStyles.primaryColor,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.red[400]!,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ).animate().slideX(
                        begin: -0.2,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                      ).fadeIn(),
                      SizedBox(height: screenSize.height * 0.02),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppStyles.primaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppStyles.primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.red[400]!,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ).animate().slideX(
                        begin: -0.2,
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                      ).fadeIn(),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildRememberMeCheckbox().animate().fadeIn(
                        delay: const Duration(milliseconds: 400),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.forgotPassword);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppStyles.primaryColor,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(
                        delay: const Duration(milliseconds: 600),
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      _buildLoginButton(authProvider.isLoading).animate().scale(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.035,
                              color: AppStyles.subtitleColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _animationController.reverse().then((_) {
                                Navigator.pushReplacementNamed(context, Routes.register);
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppStyles.primaryColor,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.035,
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
      ),
    );
  }
}
