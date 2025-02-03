import 'dart:io';
import 'dart:async';

class NetworkErrorHandler {
  static String getReadableError(Exception e, [String? operation]) {
    final baseMessage = switch (e) {
      SocketException() => 'No internet connection. Please check your network settings.',
      TimeoutException() => 'Request timed out. Please try again.',
      HttpException() => 'Unable to reach server. Please try again later.',
      FormatException() => 'Received invalid data from server.',
      _ => 'An unexpected network error occurred. Please try again.'
    };

    // Log the error for debugging
    print('🚨 Network Error: ${e.runtimeType}');
    print('📝 Error Details: $e');
    if (operation != null) {
      print('🔍 Operation: $operation');
    }

    return operation != null 
        ? '$baseMessage (during $operation)'
        : baseMessage;
  }

  static bool isNetworkError(Exception e) {
    final isNetwork = e is SocketException || 
           e is TimeoutException || 
           e is HttpException;
    
    if (isNetwork) {
      print('🌐 Network error detected: ${e.runtimeType}');
    }
    
    return isNetwork;
  }

  static Duration getRetryDelay(int attempt) {
    // Exponential backoff: 1s, 2s, 4s, etc. with max of 32s
    final seconds = 1 << attempt;
    final cappedSeconds = seconds.clamp(1, 32);
    print('⏱️ Retry delay: ${cappedSeconds}s (attempt: ${attempt + 1})');
    return Duration(seconds: cappedSeconds);
  }
}
