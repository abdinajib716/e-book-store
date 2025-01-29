import 'package:dio/dio.dart';
import '../../core/exceptions/api_exceptions.dart';
import '../../core/config/api_config.dart';
import '../../core/services/connectivity_service.dart';

class ApiClient {
  late final Dio _dio;
  final ConnectivityService _connectivityService;

  ApiClient({ConnectivityService? connectivityService})
      : _connectivityService = connectivityService ?? ConnectivityService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.apiUrl,
      contentType: 'application/json',
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
      // Shorter timeouts for better UX
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!_connectivityService.isOnline) {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'No internet connection',
              type: DioExceptionType.connectionError,
            ),
          );
        }

        print('🔍 Full URL: ${options.baseUrl}${options.path}');
        print(
            '🌐 REQUEST[${options.method}] => ${options.baseUrl}${options.path}');
        print('📤 REQUEST HEADERS: ${options.headers}');
        if (options.data != null) {
          print('📦 REQUEST BODY: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            '✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.baseUrl}${response.requestOptions.path}');
        print('📥 RESPONSE DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print(
            '❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.baseUrl}${error.requestOptions.path}');
        print('🚫 ERROR DATA: ${error.response?.data}');
        print('🔍 ERROR MESSAGE: ${error.message}');

        // Check if it's a timeout error
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error:
                  'Connection timed out. Please check your internet connection and try again.',
              type: error.type,
            ),
          );
        }

        // Handle other errors
        return handler.next(error);
      },
    ));
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      // Check connectivity before making the request
      if (!_connectivityService.isOnline) {
        throw ApiException(
          message:
              'No internet connection. Please check your network settings.',
          isConnectionError: true,
        );
      }

      // Ensure path starts with a slash
      final cleanPath = path.startsWith('/') ? path : '/$path';

      print('🔍 Full URL: ${_dio.options.baseUrl}$cleanPath');

      final response = await _dio.post(
        cleanPath,
        data: body,
        options: Options(
          headers: {
            ...ApiConfig.headers,
            if (headers != null) ...headers,
          },
        ),
      );

      if (response.data == null) {
        throw ApiException(message: 'Server returned empty response');
      }

      if (response.data is! Map) {
        print('Invalid response type: ${response.data.runtimeType}');
        throw ApiException(message: 'Invalid response format from server');
      }

      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode! >= 400) {
        final message = responseData['message'] ??
            responseData['error'] ??
            'Server error occurred';
        throw ApiException(
          message: message.toString(),
          statusCode: response.statusCode,
        );
      }

      return responseData;
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('DioException type: ${e.type}');
      print('DioException response: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          isConnectionError: true,
        );
      }

      if (e.type == DioExceptionType.receiveTimeout) {
        throw ApiException(
          message: 'Server is taking too long to respond. Please try again.',
          isConnectionError: true,
        );
      }

      if (e.response?.data != null && e.response!.data is Map) {
        final message = e.response!.data['message'] ??
            e.response!.data['error'] ??
            'Network error occurred';
        throw ApiException(
          message: message.toString(),
          statusCode: e.response?.statusCode,
        );
      }

      throw ApiException(
        message: 'Network error: ${e.message}',
        isConnectionError: true,
      );
    } catch (e) {
      print('Unexpected error in ApiClient: $e');
      if (e is ApiException) rethrow;
      throw ApiException(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      // Check connectivity before making the request
      if (!_connectivityService.isOnline) {
        throw ApiException(
          message:
              'No internet connection. Please check your network settings.',
          isConnectionError: true,
        );
      }

      final response = await _dio.get(
        endpoint,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiException(
          message: e.response?.data['message'] ?? e.message ?? 'Request failed',
          statusCode: e.response?.statusCode ?? 500,
        );
      }
      throw ApiException(message: e.message ?? 'Network error occurred');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      // Check connectivity before making the request
      if (!_connectivityService.isOnline) {
        throw ApiException(
          message:
              'No internet connection. Please check your network settings.',
          isConnectionError: true,
        );
      }

      final response = await _dio.put(
        endpoint,
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiException(
          message: e.response?.data['message'] ?? e.message ?? 'Request failed',
          statusCode: e.response?.statusCode ?? 500,
        );
      }
      throw ApiException(message: e.message ?? 'Network error occurred');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      // Check connectivity before making the request
      if (!_connectivityService.isOnline) {
        throw ApiException(
          message:
              'No internet connection. Please check your network settings.',
          isConnectionError: true,
        );
      }

      final response = await _dio.delete(
        endpoint,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiException(
          message: e.response?.data['message'] ?? e.message ?? 'Request failed',
          statusCode: e.response?.statusCode ?? 500,
        );
      }
      throw ApiException(message: e.message ?? 'Network error occurred');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> _handleResponse(Response response) async {
    final data = response.data;

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      if (data['success'] == false) {
        throw ApiException(
          message: data['message'] ?? 'Operation failed',
          statusCode: response.statusCode!,
        );
      }
      return data;
    } else {
      throw ApiException(
        message: data['message'] ?? 'Something went wrong',
        statusCode: response.statusCode!,
      );
    }
  }

  void addAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
