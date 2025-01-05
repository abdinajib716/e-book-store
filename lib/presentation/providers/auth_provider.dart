import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../domain/entities/models/user.dart';
import '../../core/exceptions/api_exceptions.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  Timer? _tokenRefreshTimer;
  Timer? _sessionTimer;
  static const sessionTimeout = Duration(hours: 24);
  static const tokenRefreshInterval = Duration(minutes: 30);

  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _error;
  bool _isLoading = false;
  bool _rememberMe = false;

  AuthProvider({
    required AuthService authService,
  }) : _authService = authService {
    _init();
  }

  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get rememberMe => _rememberMe;

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> _init() async {
    _setLoading(true);
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        _status = AuthStatus.authenticated;
        _startTokenRefresh();
        _startSessionTimer();
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _startTokenRefresh() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = Timer.periodic(tokenRefreshInterval, (_) async {
      await _refreshToken();
    });
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    if (!_rememberMe) {
      _sessionTimer = Timer(sessionTimeout, () {
        logout();
      });
    }
  }

  Future<void> _refreshToken() async {
    try {
      final newToken = await _authService.refreshToken();
      // Handle new token
      _startTokenRefresh();
    } catch (e) {
      _error = e.toString();
      await logout();
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = null;
    try {
      final user = await _authService.login(email, password);
      _currentUser = user;
      _status = AuthStatus.authenticated;
      _startTokenRefresh();
      _startSessionTimer();
      notifyListeners();
      return true;
    } catch (e) {
      if (e is ApiException) {
        _error = e.message;
        _status = AuthStatus.error;
        notifyListeners();
        rethrow;
      }
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      throw ApiException(
        message: _error!,
        statusCode: 500,
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String email, String password, String fullName) async {
    _setLoading(true);
    _error = null;
    try {
      final user = await _authService.register(email, password, fullName);
      _currentUser = user;
      _status = AuthStatus.authenticated;
      _startTokenRefresh();
      _startSessionTimer();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyEmail(String email, String code) async {
    _setLoading(true);
    _error = null;
    try {
      final success = await _authService.verifyEmail(email, code);
      if (success) {
        _status = AuthStatus.authenticated;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _error = null;
    try {
      await _authService.forgotPassword(email);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e is ApiException ? e.message : e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
      _tokenRefreshTimer?.cancel();
      _sessionTimer?.cancel();
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> sendVerificationEmail(String email) async {
    _setLoading(true);
    try {
      await _authService.sendVerificationEmail(email);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    _setLoading(true);
    _error = null;
    try {
      await _authService.resetPassword(token, newPassword);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    _setLoading(true);
    try {
      final updatedUser = await _authService.updateProfile(userData);
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _tokenRefreshTimer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }
}
