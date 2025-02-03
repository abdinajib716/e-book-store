import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/dev_config.dart';
import '../config/api_config.dart';

class ConnectivityHelper {
  static final Map<String, DateTime> _urlCache = {};
  static const _cacheDuration = Duration(minutes: 5);
  static const _backendTimeout = Duration(seconds: 5); // Short timeout for health check

  // Check real internet connectivity
  static Future<bool> checkRealConnectivity() async {
    // First, try backend health check
    try {
      print('🔍 Testing backend health...');
      final isBackendHealthy = await checkBackendConnectivity();
      if (isBackendHealthy) {
        print('✅ Backend is healthy and accessible');
        return true;
      }
      print('⚠️ Backend is not healthy, checking general internet connectivity');
    } catch (e) {
      print('⚠️ Backend health check failed: $e');
    }

    // If backend fails, check general internet
    for (final url in DevConfig.connectionTestUrls) {
      try {
        print('🔍 Testing connection to: $url');
        final success = await _checkSingleUrl(url);
        if (success) {
          print('✅ Internet connection available, but backend might be unreachable');
          return true;
        }
      } catch (e) {
        print('❌ URL check failed: $url - $e');
        continue;
      }
    }

    print('❌ No internet connection available');
    return false;
  }

  // Check backend health
  static Future<bool> checkBackendConnectivity() async {
    try {
      print('🔍 Checking backend health...');
      final response = await http
          .get(Uri.parse('${ApiConfig.productionUrl}/health'))
          .timeout(_backendTimeout);
      
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          final isHealthy = data['success'] == true && 
                         data['status'] == 'healthy' &&
                         data['checks']['database']['healthy'] == true;
          
          if (isHealthy) {
            print('✅ Backend is healthy');
            print('📊 Server Stats:');
            print('   - Uptime: ${data['checks']['server']['uptime']}s');
            print('   - Memory: ${data['checks']['server']['memory']['heapUsed']}');
            print('   - Response Time: ${data['performance']['responseTime']}');
          } else {
            print('❌ Backend health check failed:');
            print('   - Status: ${data['status']}');
            print('   - Database: ${data['checks']['database']['status']}');
          }
          return isHealthy;
        } catch (e) {
          print('❌ Failed to parse health check response: $e');
          return false;
        }
      }
      print('❌ Health check failed with status: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Backend health check failed: $e');
      return false;
    }
  }

  static Future<bool> _checkSingleUrl(String url) async {
    final response = await http
        .get(Uri.parse(url))
        .timeout(DevConfig.connectionTimeout);
    return response.statusCode >= 200 && response.statusCode < 400;
  }

  // Get detailed connection status
  static Future<ConnectionStatus> getConnectionStatus() async {
    final hasInternet = await checkRealConnectivity();
    final canReachBackend = await checkBackendConnectivity();

    final status = ConnectionStatus(
      hasInternet: hasInternet,
      canReachBackend: canReachBackend,
      timestamp: DateTime.now(),
    );

    print('📊 Connection Status: ${status.statusMessage}');
    return status;
  }
}

class ConnectionStatus {
  final bool hasInternet;
  final bool canReachBackend;
  final DateTime timestamp;

  const ConnectionStatus({
    required this.hasInternet,
    required this.canReachBackend,
    required this.timestamp,
  });

  bool get isFullyConnected => hasInternet && canReachBackend;
  
  String get statusMessage {
    if (isFullyConnected) return 'Fully connected to backend';
    if (hasInternet && !canReachBackend) return 'Internet available but backend server unreachable';
    if (!hasInternet) return 'No internet connection';
    return 'Unknown connection status';
  }
}
