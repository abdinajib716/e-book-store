import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../utils/notification_utils.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  bool _isOnline = false;
  late ConnectivityService _connectivityService;
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivityService = context.read<ConnectivityService>();
    _setupConnectivityListener();
    // Initial check with forced refresh
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _connectivityService.checkConnection();
      if (mounted) {
        setState(() => _isOnline = _connectivityService.isOnline);
        if (!_isOnline) {
          _handleConnectivityChange(false);
        }
      }
    });
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
    if (!mounted) return;
    
    if (isOnline) {
      NotificationUtils.showSuccess(
        context: context,
        message: 'Back online',
      );
    } else {
      NotificationUtils.showError(
        context: context,
        message: 'No internet connection. Please check your connection and try again.',
      );
    }
  }

  /// Check if the device is online before performing an action
  Future<bool> checkConnectivity() async {
    await _connectivityService.checkConnection();
    return _connectivityService.isOnline;
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

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
