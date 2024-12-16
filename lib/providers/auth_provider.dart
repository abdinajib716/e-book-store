import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuthStatus() async {
    // Add your authentication logic here
    await Future.delayed(const Duration(seconds: 2)); // Simulated delay
    _isAuthenticated = false; // Set based on your auth logic
    notifyListeners();
  }
}
