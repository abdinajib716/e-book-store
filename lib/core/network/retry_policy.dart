import 'dart:async';
import 'package:flutter/foundation.dart';
import 'network_error_handler.dart';

class RetryPolicy {
  static const int maxRetries = 3;
  static const Duration initialDelay = Duration(seconds: 1);

  /// Executes an operation with automatic retries
  static Future<T> withRetry<T>({
    required Future<T> Function() operation,
    int retries = maxRetries,
    bool Function(Exception)? shouldRetry,
    void Function(int, Exception)? onRetry,
  }) async {
    try {
      return await operation();
    } catch (e) {
      if (e is! Exception) rethrow;
      
      final shouldAttemptRetry = shouldRetry?.call(e) ?? 
                                NetworkErrorHandler.isNetworkError(e);
      
      if (!shouldAttemptRetry || retries <= 0) {
        rethrow;
      }

      final delay = NetworkErrorHandler.getRetryDelay(maxRetries - retries);
      
      if (kDebugMode) {
        print('🔄 Retrying operation. Attempts remaining: $retries');
        print('⏰ Waiting for: ${delay.inSeconds}s');
      }

      onRetry?.call(maxRetries - retries + 1, e);
      
      await Future.delayed(delay);
      
      return withRetry(
        operation: operation,
        retries: retries - 1,
        shouldRetry: shouldRetry,
        onRetry: onRetry,
      );
    }
  }

  /// Executes an operation with a timeout
  static Future<T> withTimeout<T>({
    required Future<T> Function() operation,
    Duration timeout = const Duration(seconds: 30),
  }) {
    return operation().timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        'Operation timed out after ${timeout.inSeconds} seconds',
      ),
    );
  }
}
