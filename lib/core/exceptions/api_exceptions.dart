class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? data;
  final bool isConnectionError;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.isConnectionError = false,
  });

  @override
  String toString() => message;

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
  
  // Helper for rate limit errors
  bool get isRateLimit => statusCode == 429;
  
  // Get retry after duration in minutes
  int get retryAfterMinutes {
    if (data != null && data!.containsKey('retryAfter')) {
      return (data!['retryAfter'] as int? ?? 3600) ~/ 60;
    }
    return 60; // Default to 1 hour
  }

  // Get user-friendly error message
  String get userMessage {
    if (isRateLimit) {
      return 'Too many attempts. Please wait $retryAfterMinutes minutes before trying again.';
    }
    return message;
  }

  // Helper Methods
  Map<String, dynamic>? get validationErrors {
    if (isValidationError && data is Map) {
      return data as Map<String, dynamic>;
    }
    return null;
  }
}
