import 'package:dio/dio.dart';
import '../../core/exceptions/api_exceptions.dart';
import '../../core/config/app_config.dart';

class ApiClient {
  late final Dio _dio;

  // Base URLs for different environments
  static const String baseUrlLocal = 'http://10.0.2.2:5000/api'; // For Android Emulator local testing
  static const String baseUrlDev = 'https://karshe-bookstore-backend.vercel.app/api'; // Vercel development
  static const String baseUrlProd = 'https://karshe-bookstore.kokapk.com/api'; // Production

  static String get baseUrl {
    // You can control this with an environment variable or build flag
    const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
    switch (environment) {
      case 'local':
        return baseUrlLocal;
      case 'prod':
        return baseUrlProd;
      case 'dev':
      default:
        return baseUrlDev;
    }
  }

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      contentType: 'application/json',
      responseType: ResponseType.json,
      validateStatus: (status) => true,
    ));

    // Add interceptors for logging in development
    if (AppConfig.isDevelopment) {
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          return handler.next(error);
        },
      ));
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

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
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

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
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

  void addAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
