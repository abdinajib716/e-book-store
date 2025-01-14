import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionTypeIcon extends StatelessWidget {
  final ConnectivityResult connectionType;
  final double size;
  final Color? color;

  const ConnectionTypeIcon({
    super.key,
    required this.connectionType,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final String label;
    final String emoji;

    switch (connectionType) {
      case ConnectivityResult.wifi:
        icon = Icons.wifi;
        label = 'WiFi';
        emoji = '📶';
      case ConnectivityResult.mobile:
        icon = Icons.signal_cellular_alt;
        label = 'Mobile Data';
        emoji = '📱';
      case ConnectivityResult.ethernet:
        icon = Icons.lan;
        label = 'Ethernet';
        emoji = '🔌';
      case ConnectivityResult.vpn:
        icon = Icons.vpn_lock;
        label = 'VPN';
        emoji = '🔒';
      case ConnectivityResult.bluetooth:
        icon = Icons.bluetooth;
        label = 'Bluetooth';
        emoji = '🦷';
      case ConnectivityResult.other:
        icon = Icons.device_hub;
        label = 'Other';
        emoji = '🔄';
      case ConnectivityResult.none:
        icon = Icons.signal_wifi_off;
        label = 'No Connection';
        emoji = '❌';
    }

    return Tooltip(
      message: '$emoji $label',
      child: Icon(
        icon,
        size: size,
        color: color ?? Theme.of(context).iconTheme.color,
      ),
    );
  }
}
