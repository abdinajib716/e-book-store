import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/connectivity_service.dart';

class ConnectivityStatusDot extends StatelessWidget {
  final double size;

  const ConnectivityStatusDot({
    super.key,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: context.read<ConnectivityService>().onlineStatus,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? false;

        return Tooltip(
          message: isOnline ? 'Online' : 'Offline',
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
}
