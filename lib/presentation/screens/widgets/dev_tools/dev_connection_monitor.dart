import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/config/dev_config.dart';

class DevConnectionMonitor extends StatefulWidget {
  const DevConnectionMonitor({super.key});

  @override
  State<DevConnectionMonitor> createState() => _DevConnectionMonitorState();
}

class _DevConnectionMonitorState extends State<DevConnectionMonitor> {
  @override
  void initState() {
    super.initState();
    // Initial check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConnectivityService>().checkConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode
    if (!DevConfig.isRealDevice) return const SizedBox.shrink();

    return Material(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.black87,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.developer_mode, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Development Mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      context.read<ConnectivityService>().checkConnection();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              StreamBuilder<bool>(
                stream: context.read<ConnectivityService>().onlineStatus,
                builder: (context, snapshot) {
                  final isOnline = snapshot.data ?? false;

                  return Column(
                    children: [
                      _StatusRow(
                        label: 'Internet',
                        isConnected: isOnline,
                        onTap: () => context
                            .read<ConnectivityService>()
                            .checkConnection(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final bool isConnected;
  final VoidCallback? onTap;

  const _StatusRow({
    required this.label,
    required this.isConnected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(width: 8),
            Text(
              isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isConnected ? Colors.green : Colors.red,
                border: Border.all(
                  color: Colors.white24,
                  width: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
