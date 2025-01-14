import 'dart:async';
import 'package:http/http.dart' as http;
import '../config/dev_config.dart';
import '../config/api_config.dart';

class ConnectivityHelper {
  // Check real internet connectivity
  static Future<bool> checkRealConnectivity() async {
    // First try production URL
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.productionUrl))
          .timeout(DevConfig.connectionTimeout);
      if (response.statusCode == 200) return true;
    } catch (_) {
      // Production URL failed, try backup URLs
      for (final url in DevConfig.connectionTestUrls) {
        try {
          final response = await http
              .get(Uri.parse(url))
              .timeout(DevConfig.connectionTimeout);
          if (response.statusCode == 200) return true;
        } catch (_) {
          continue;
        }
      }
    }
    return false;
  }

  // Check if development server is accessible (for USB debugging)
  static Future<bool> checkDevServerConnectivity() async {
    try {
      final response = await http
          .get(Uri.parse(DevConfig.devApiUrl))
          .timeout(DevConfig.connectionTimeout);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Get detailed connection status
  static Future<ConnectionStatus> getConnectionStatus() async {
    final hasInternet = await checkRealConnectivity();
    final canReachDevServer = await checkDevServerConnectivity();

    return ConnectionStatus(
      hasInternet: hasInternet,
      canReachDevServer: canReachDevServer,
      timestamp: DateTime.now(),
    );
  }
}

class ConnectionStatus {
  final bool hasInternet;
  final bool canReachDevServer;
  final DateTime timestamp;

  const ConnectionStatus({
    required this.hasInternet,
    required this.canReachDevServer,
    required this.timestamp,
  });

  bool get isFullyConnected => hasInternet && canReachDevServer;
  
  String get statusMessage {
    if (isFullyConnected) return 'Fully connected';
    if (hasInternet && !canReachDevServer) return 'Connected to internet but dev server unreachable';
    if (!hasInternet) return 'No internet connection';
    return 'Unknown connection status';
  }
}
