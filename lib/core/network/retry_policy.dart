import 'dart:async';
import 'package:flutter/foundation.dart';
import 'network_error_handler.dart';

class RetryPolicy {
  static const int maxRetries = 3;
  static const Duration initialDelay = Duration(seconds: 1);
  static const Duration maxDelay = Duration(seconds: 32);

  static Duration _clampDuration(Duration value, Duration min, Duration max) {
    final ms = value.inMilliseconds;
    return Duration(milliseconds: ms.clamp(min.inMilliseconds, max.inMilliseconds));
  }

  /// Executes an operation with automatic retries
  static Future<T> withRetry<T>({
    required Future<T> Function() operation,
    int retries = maxRetries,
    bool Function(Exception)? shouldRetry,
    void Function(int, Exception)? onRetry,
    String? operationName,
  }) async {
    try {
      if (kDebugMode) {
        print(
            '🚀 Starting operation${operationName != null ? ': $operationName' : ''}');
      }
      return await operation();
    } catch (e) {
      if (e is! Exception) rethrow;

      final shouldAttemptRetry =
          shouldRetry?.call(e) ?? NetworkErrorHandler.isNetworkError(e);

      if (!shouldAttemptRetry || retries <= 0) {
        if (kDebugMode) {
          print(
              '❌ Operation failed${operationName != null ? ' ($operationName)' : ''}: ${e.toString()}');
          print('⚠️ No more retries available');
        }
        rethrow;
      }

      final delay = _clampDuration(
        NetworkErrorHandler.getRetryDelay(maxRetries - retries),
        initialDelay,
        maxDelay
      );

      if (kDebugMode) {
        print(
            '🔄 Retrying operation${operationName != null ? ' ($operationName)' : ''}');
        print('⏰ Waiting for: ${delay.inSeconds}s');
        print('📝 Attempts remaining: $retries');
      }

      onRetry?.call(maxRetries - retries + 1, e);

      await Future.delayed(delay);

      return withRetry(
        operation: operation,
        retries: retries - 1,
        shouldRetry: shouldRetry,
        onRetry: onRetry,
        operationName: operationName,
      );
    }
  }

  /// Executes an operation with a timeout
  static Future<T> withTimeout<T>({
    required Future<T> Function() operation,
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) {
    if (kDebugMode) {
      print(
          '⏱️ Starting operation with ${timeout.inSeconds}s timeout${operationName != null ? ' ($operationName)' : ''}');
    }

    return operation().timeout(
      timeout,
      onTimeout: () {
        if (kDebugMode) {
          print(
              '⚠️ Operation timed out after ${timeout.inSeconds}s${operationName != null ? ' ($operationName)' : ''}');
        }
        throw TimeoutException(
          'Operation timed out after ${timeout.inSeconds} seconds${operationName != null ? ' ($operationName)' : ''}',
        );
      },
    );
  }
}
