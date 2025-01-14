import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _onlineController =
      StreamController<bool>.broadcast();
  bool _isOnline = true; // Start optimistically
  Timer? _debounceTimer;
  bool _isChecking = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Stream<bool> get onlineStatus => _onlineController.stream;
  bool get isOnline => _isOnline;

  // Primary URLs for connectivity check
  final List<String> _connectivityCheckUrls = [
    'https://karshe-bookstore-backend.vercel.app/api/health', // Our backend first
    'https://www.google.com', // Fallback
  ];

  ConnectivityService() {
    print('🌐 Initializing connectivity service...');
    _initConnectivity();
    _setupConnectivityStream();
  }

  void _setupConnectivityStream() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      print('📡 Connectivity changed: $results');
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;

      if (result == ConnectivityResult.none) {
        _updateOnlineStatus(false);
      } else {
        // Don't immediately assume online, verify first
        checkConnection();
      }
    });
  }

  Future<void> _initConnectivity() async {
    try {
      print('📡 Starting network monitoring...');
      final results = await _connectivity.checkConnectivity();
      final result = results is List ? (results).firstOrNull : results;

      print('📱 Initial connectivity status: $result');
      if (result == null || result == ConnectivityResult.none) {
        _updateOnlineStatus(false);
      } else {
        // Initial connection check
        await checkConnection();
      }
    } catch (e) {
      print('❌ Error initializing connectivity: $e');
      _updateOnlineStatus(false);
    }
  }

  Future<void> checkConnection() async {
    if (_isChecking) {
      print('🔄 Already checking connection, skipping...');
      return;
    }

    _isChecking = true;
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        bool hasConnection = false;
        print('🔍 Checking internet connection...');

        final results = await _connectivity.checkConnectivity();
        final result = results is List ? (results).firstOrNull : results;

        if (result == null || result == ConnectivityResult.none) {
          print('❌ No network connectivity');
          _updateOnlineStatus(false);
          _isChecking = false;
          return;
        }

        // Then verify internet access
        for (final url in _connectivityCheckUrls) {
          try {
            print('🌐 Testing connection to: $url');
            final response = await http.get(Uri.parse(url)).timeout(
              const Duration(seconds: 3),
              onTimeout: () {
                print('⏰ Connection timeout for: $url');
                throw TimeoutException('Connection timeout');
              },
            );

            if (response.statusCode == 200) {
              print('✅ Successfully connected to: $url');
              hasConnection = true;
              break;
            } else {
              print('⚠️ Received status ${response.statusCode} from: $url');
            }
          } catch (e) {
            print('⚠️ Failed to connect to $url: $e');
            continue;
          }
        }

        _updateOnlineStatus(hasConnection);
      } catch (e) {
        print('❌ Error checking connection: $e');
        _updateOnlineStatus(false);
      } finally {
        _isChecking = false;
      }
    });
  }

  void _updateOnlineStatus(bool isOnline) {
    if (_isOnline != isOnline) {
      print('🔄 Updating online status to: ${isOnline ? 'ONLINE' : 'OFFLINE'}');
      _isOnline = isOnline;
      _onlineController.add(isOnline);
    }
  }

  void dispose() {
    print('👋 Disposing connectivity service...');
    _connectivitySubscription?.cancel();
    _debounceTimer?.cancel();
    _onlineController.close();
  }
}
