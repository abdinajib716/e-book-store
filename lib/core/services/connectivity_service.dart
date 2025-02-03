import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _onlineController = StreamController<bool>.broadcast();
  bool _isOnline = false;
  Timer? _debounceTimer;
  bool _isChecking = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  static const Duration _timeout = Duration(seconds: 10);

  Stream<bool> get onlineStatus => _onlineController.stream;
  bool get isOnline => _isOnline;

  // Primary URLs for connectivity check, ordered by reliability
  final List<String> _connectivityCheckUrls = [
    'https://www.google.com',       // Most reliable
    'https://www.cloudflare.com',   // Secondary reliable
    'https://www.apple.com',        // Tertiary reliable
    'https://karshe-bookstore-backend.vercel.app/api/health', // Our backend
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
        if (!await _tryConnection()) {
          if (_retryCount < _maxRetries) {
            _retryCount++;
            print('🔄 Retrying connection... Attempt: $_retryCount');
            await checkConnection();
          } else {
            _updateOnlineStatus(false);
            _resetCheckState();
          }
        } else {
          _retryCount = 0;
          _updateOnlineStatus(true);
        }
      } catch (e) {
        print('❌ Error checking connection: $e');
        _updateOnlineStatus(false);
      } finally {
        _isChecking = false;
      }
    });
  }

  Future<bool> _tryConnection() async {
    for (final url in _connectivityCheckUrls) {
      try {
        print('🌐 Testing connection to: $url');
        final response = await http
            .get(Uri.parse(url))
            .timeout(_timeout);
        
        if (response.statusCode >= 200 && response.statusCode < 400) {
          print('✅ Connection successful to $url');
          _updateOnlineStatus(true);
          return true;
        }
      } catch (e) {
        print('⚠️ Failed to connect to $url: $e');
        // Don't update status yet, try next URL
        continue;
      }
    }
    _updateOnlineStatus(false);
    return false;
  }

  void _updateOnlineStatus(bool isOnline) {
    if (_isOnline != isOnline) {
      print('🔄 Updating online status to: ${isOnline ? 'ONLINE' : 'OFFLINE'}');
      _isOnline = isOnline;
      _onlineController.add(isOnline);
    }
  }

  void _resetCheckState() {
    _isChecking = false;
    _retryCount = 0;
    print('🔄 Reset connectivity check state');
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _connectivitySubscription?.cancel();
    _onlineController.close();
    _isChecking = false;
    print('🔌 Disposing connectivity service');
  }
}
