import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/connectivity_service.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineWidget;
  final Widget? offlineWidget;
  final bool showOfflineIndicator;
  final VoidCallback? onRetry;

  const NetworkAwareWidget({
    super.key,
    required this.onlineWidget,
    this.offlineWidget,
    this.showOfflineIndicator = true,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: context.read<ConnectivityService>().onlineStatus,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? false;

        if (isOnline) {
          return onlineWidget;
        }

        if (offlineWidget != null) {
          return offlineWidget!;
        }

        if (!showOfflineIndicator) {
          return onlineWidget;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showOfflineIndicator)
              Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: Theme.of(context).colorScheme.onError,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'No Internet Connection',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    if (onRetry != null) ...[
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: onRetry,
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.onError,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ],
                ),
              ),
            Expanded(child: onlineWidget),
          ],
        );
      },
    );
  }
}

// Extension for easy widget wrapping
extension NetworkAwareWidgetExtension on Widget {
  Widget withNetworkAwareness({
    Widget? offlineWidget,
    bool showOfflineIndicator = true,
    VoidCallback? onRetry,
  }) {
    return NetworkAwareWidget(
      onlineWidget: this,
      offlineWidget: offlineWidget,
      showOfflineIndicator: showOfflineIndicator,
      onRetry: onRetry,
    );
  }
}
