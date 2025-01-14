import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/connectivity_service.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: context.read<ConnectivityService>().onlineStatus,
      builder: (context, snapshot) {
        final isOnline = snapshot.data;
        if (isOnline == null) return const SizedBox.shrink();

        return AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          offset: Offset(0, isOnline ? -1 : 0),
          child: Material(
            child: Container(
              color: isOnline ? Colors.green : Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isOnline ? Icons.wifi : Icons.wifi_off,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOnline ? 'Back Online' : 'No Internet Connection',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
