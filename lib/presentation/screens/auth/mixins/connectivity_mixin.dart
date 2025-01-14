import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../utils/notification_utils.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  bool _isOnline = true;
  bool _showingOfflineIndicator = false;
  Timer? _offlineIndicatorTimer;
  late ConnectivityService _connectivityService;
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivityService = context.read<ConnectivityService>();
    _setupConnectivityListener();
    // Initial check
    _isOnline = _connectivityService.isOnline;
    if (!_isOnline) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOfflineIndicator();
      });
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivityService.onlineStatus.listen((isOnline) {
      if (mounted && isOnline != _isOnline) {
        setState(() => _isOnline = isOnline);
        _handleConnectivityChange(isOnline);
      }
    });
  }

  void _handleConnectivityChange(bool isOnline) {
    if (isOnline) {
      _hideOfflineIndicator();
      NotificationUtils.showSuccess(
        context: context,
        message: 'Back online',
      );
    } else {
      _showOfflineIndicator();
    }
  }

  void _showOfflineIndicator() {
    if (!mounted) return;
    setState(() => _showingOfflineIndicator = true);
    
    // Show the notification after a short delay to avoid flashing
    _offlineIndicatorTimer?.cancel();
    _offlineIndicatorTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      NotificationUtils.showError(
        context: context,
        message: 'No internet connection',
      );
    });
  }

  void _hideOfflineIndicator() {
    if (!mounted) return;
    setState(() => _showingOfflineIndicator = false);
    _offlineIndicatorTimer?.cancel();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _offlineIndicatorTimer?.cancel();
    super.dispose();
  }

  /// Check if the device is online before performing an action
  Future<bool> checkConnectivity() async {
    // Force a fresh check
    await _connectivityService.checkConnection();
    
    if (!_connectivityService.isOnline) {
      if (!mounted) return false;
      
      NotificationUtils.showError(
        context: context,
        message: 'No internet connection. Please check your connection and try again.',
      );
      return false;
    }
    return true;
  }

  /// Retry button widget for offline state
  Widget buildRetryButton({
    required VoidCallback onRetry,
    String text = 'Retry',
  }) {
    return AnimatedOpacity(
      opacity: !_isOnline ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton.icon(
        onPressed: !_isOnline ? () async {
          // Force a fresh check when retrying
          await _connectivityService.checkConnection();
          onRetry();
        } : null,
        icon: const Icon(Icons.refresh),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  /// Offline indicator widget with animation
  Widget buildOfflineIndicator() {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      offset: Offset(0, _showingOfflineIndicator ? 0 : -1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _showingOfflineIndicator ? 1.0 : 0.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, color: Colors.red.shade700, size: 16),
              const SizedBox(width: 8),
              Text(
                'No internet connection',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
