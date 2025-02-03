import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/config/api_config.dart';
import '../../core/exceptions/api_exceptions.dart';
import '../../core/services/connectivity_service.dart';

class ApiClient {
  final Dio _dio;
  final ConnectivityService? _connectivityService;
  String? _authToken;
  String? _baseUrl;

  ApiClient({ConnectivityService? connectivityService})
      : _connectivityService = connectivityService,
        _dio = Dio() {
    _initializeDio();
    _initializeBaseUrl();
  }

  void _initializeDio() {
    _dio.options.connectTimeout = ApiConfig.connectTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.options.sendTimeout = ApiConfig.sendTimeout;
    _dio.options.validateStatus = (status) => status! < 500;

    // Add logging interceptor
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('🔍 API Log: $obj'),
    ));
  }

  Future<void> _initializeBaseUrl() async {
    try {
      _baseUrl = await ApiConfig.apiUrl;
      print('🌍 Initialized base URL: $_baseUrl');
    } catch (e) {
      print('❌ Error initializing base URL: $e');
      throw ApiException(message: 'Failed to initialize API URL');
    }
  }

  // Auth token management
  void addAuthToken(String token) {
    _authToken = token;
    print('🔑 Added auth token');
  }

  void removeAuthToken() {
    _authToken = null;
    print('🔒 Removed auth token');
  }

  // Helper to get headers with optional auth token
  Map<String, String> _getHeaders() {
    final headers = Map<String, String>.from(ApiConfig.headers);
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // Check backend health before making requests
  Future<bool> _checkBackendHealth() async {
    if (_baseUrl == null) {
      await _initializeBaseUrl();
    }

    try {
      final healthUrl = '$_baseUrl/health';
      final response = await _dio.get(
        healthUrl,
        options: Options(
          headers: _getHeaders(),
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Backend health check passed');
        return true;
      }

      print('❌ Health check failed with status: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Health check error: $e');
      return false;
    }
  }

  // Generic request method with optimized error handling
  Future<Response> _request(
    String endpoint,
    Future<Response> Function(String url) makeRequest,
  ) async {
    if (_baseUrl == null) {
      await _initializeBaseUrl();
    }

    try {
      // Quick connectivity check
      if (_connectivityService != null && !await _connectivityService!.isOnline) {
        throw ApiException(
            message: 'No internet connection', isConnectionError: true);
      }

      final url = '$_baseUrl$endpoint';
      print('🌐 Making request to: $url');
      
      final response = await makeRequest(url);
      
      // Check for error responses
      if (response.statusCode != null && response.statusCode! >= 400) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          throw ApiException(
            message: data['message'] ?? 'Request failed',
            statusCode: response.statusCode,
            data: data
          );
        }
      }
      
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  // Optimized error handling
  ApiException _handleDioError(DioException error) {
    print('❌ API Error: ${error.message}');
    
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiException(
        message: 'Request timed out. Please try again.',
        isConnectionError: true
      );
    }

    if (error.response?.data is Map<String, dynamic>) {
      final data = error.response!.data as Map<String, dynamic>;
      return ApiException(
        message: data['message'] ?? error.message ?? 'Request failed',
        statusCode: error.response?.statusCode,
        data: data
      );
    }

    return ApiException(message: error.message ?? 'Request failed');
  }

  // GET request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return _request(
      endpoint,
      (url) => _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers ?? _getHeaders()),
      ),
    );
  }

  // POST request
  Future<Response> post(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return _request(
      endpoint,
      (url) => _dio.post(
        url,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers ?? _getHeaders()),
      ),
    );
  }

  // PUT request
  Future<Response> put(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return _request(
      endpoint,
      (url) => _dio.put(
        url,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers ?? _getHeaders()),
      ),
    );
  }

  // DELETE request
  Future<Response> delete(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return _request(
      endpoint,
      (url) => _dio.delete(
        url,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers ?? _getHeaders()),
      ),
    );
  }
}
