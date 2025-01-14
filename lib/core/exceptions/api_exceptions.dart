class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final bool isConnectionError;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.isConnectionError = false,
  });

  @override
  String toString() {
    if (isConnectionError) {
      return 'Connection Error: $message';
    }
    return 'API Error (${statusCode ?? 'unknown'}): $message';
  }

  // HTTP Status Code Checks
  bool get isNotFound => statusCode == 404;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;
  bool get isTimeout => message.toLowerCase().contains('timeout');
  
  // Common Error Types
  bool get isNetworkError => isConnectionError || isTimeout;
  bool get isAuthError => isUnauthorized || isForbidden;
  bool get isValidationError => statusCode == 422;
  
  // Helper Methods
  Map<String, dynamic>? get validationErrors {
    if (isValidationError && data is Map) {
      return data as Map<String, dynamic>;
    }
    return null;
  }
}
