import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionUtils {
  static String getConnectionEmoji(ConnectivityResult result) {
    return switch (result) {
      ConnectivityResult.mobile => '📱',
      ConnectivityResult.wifi => '📶',
      ConnectivityResult.ethernet => '🔌',
      ConnectivityResult.vpn => '🔒',
      ConnectivityResult.bluetooth => '🦷',
      ConnectivityResult.other => '🔄',
      ConnectivityResult.none => '❌',
    };
  }

  static String getConnectionLabel(ConnectivityResult result) {
    return switch (result) {
      ConnectivityResult.mobile => 'Mobile Data',
      ConnectivityResult.wifi => 'WiFi',
      ConnectivityResult.ethernet => 'Ethernet',
      ConnectivityResult.vpn => 'VPN',
      ConnectivityResult.bluetooth => 'Bluetooth',
      ConnectivityResult.other => 'Other Connection',
      ConnectivityResult.none => 'No Connection',
    };
  }

  static Color getConnectionColor(ConnectivityResult result) {
    return switch (result) {
      ConnectivityResult.none => Colors.red,
      _ => Colors.green,
    };
  }

  static IconData getConnectionIcon(ConnectivityResult result) {
    return switch (result) {
      ConnectivityResult.mobile => Icons.signal_cellular_alt,
      ConnectivityResult.wifi => Icons.wifi,
      ConnectivityResult.ethernet => Icons.lan,
      ConnectivityResult.vpn => Icons.vpn_lock,
      ConnectivityResult.bluetooth => Icons.bluetooth,
      ConnectivityResult.other => Icons.device_hub,
      ConnectivityResult.none => Icons.signal_wifi_off,
    };
  }
}
