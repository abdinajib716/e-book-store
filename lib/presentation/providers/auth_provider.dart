import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../domain/entities/models/user.dart';
import '../../core/exceptions/api_exceptions.dart';
import '../../core/services/connectivity_service.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final ConnectivityService _connectivityService;
  Timer? _tokenRefreshTimer;
  Timer? _sessionTimer;
  static const sessionTimeout = Duration(hours: 24);
  static const tokenRefreshInterval = Duration(minutes: 30);

  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _error;
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _isOnline = true;

  AuthProvider({
    required AuthService authService,
    ConnectivityService? connectivityService,
  })  : _authService = authService,
        _connectivityService = connectivityService ?? ConnectivityService() {
    _connectivityService.onlineStatus.listen((isOnline) {
      _isOnline = isOnline;
      notifyListeners();
    });
    _init();
  }

  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get rememberMe => _rememberMe;
  bool get isOnline => _isOnline;

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
    if (!_isOnline) {
      _setError('No internet connection. Please check your network settings.');
      return false;
    }

    _setLoading(true);
    _error = null;
    _status = AuthStatus.authenticating;

    try {
      final user = await _authService.login(email, password);

      // Update state in a consistent order
      _currentUser = user;
      _status = AuthStatus.authenticated;

      // Start timers after successful authentication
      _startTokenRefresh();
      _startSessionTimer();

      // Notify listeners of state change
      notifyListeners();

      return true;
    } on ApiException catch (e) {
      String errorMessage = e.message;

      if (e.isConnectionError) {
        errorMessage =
            'Connection error. Please check your internet and try again.';
      } else if (e.isUnauthorized) {
        errorMessage = 'Invalid email or password';
      } else if (e.isForbidden) {
        errorMessage = 'Please verify your email before logging in';
      }

      _setError(errorMessage);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password, String fullName) async {
    if (!_isOnline) {
      _setError('No internet connection. Please check your network settings.');
      return false;
    }

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
    } on ApiException catch (e) {
      String errorMessage = e.message;

      if (e.isConnectionError) {
        errorMessage =
            'Connection error. Please check your internet and try again.';
      } else if (e.isClientError) {
        errorMessage = e.message;
      }

      _setError(errorMessage);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyEmail(String email, String code) async {
    if (!_isOnline) {
      _setError('No internet connection. Please check your network settings.');
      return false;
    }

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
    if (!_isOnline) {
      _setError('No internet connection. Please check your network settings.');
      return false;
    }

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
    if (!_isOnline) {
      _setError('No internet connection. Please check your network settings.');
      return false;
    }

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
    if (!_isOnline) {
      _setError('No internet connection. Please check your network settings.');
      return false;
    }

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
    if (!_isOnline) {
      _setError('No internet connection. Please check your network settings.');
      return false;
    }

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

  void _setError(String? value) {
    _error = value;
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
