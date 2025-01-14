import 'dart:io';
import 'dart:async';

class NetworkErrorHandler {
  static String getReadableError(Exception e) {
    return switch (e) {
      SocketException() => 'No internet connection. Please check your network settings.',
      TimeoutException() => 'Request timed out. Please try again.',
      HttpException() => 'Unable to reach server. Please try again later.',
      FormatException() => 'Received invalid data from server.',
      _ => 'An unexpected network error occurred. Please try again.'
    };
  }

  static bool isNetworkError(Exception e) {
    return e is SocketException || 
           e is TimeoutException || 
           e is HttpException;
  }

  static Duration getRetryDelay(int attempt) {
    // Exponential backoff: 1s, 2s, 4s, etc.
    return Duration(seconds: 1 << attempt);
  }
}
