import 'dart:convert';
import 'package:shared_preferences.dart';

class OfflineStorage {
  static const String _prefix = 'offline_';
  static const String _booksKey = '${_prefix}books';
  static const String _lastSyncKey = '${_prefix}last_sync';
  static const Duration _maxCacheAge = Duration(days: 7);

  static Future<void> cacheData(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = DateTime.now().toIso8601String();
    
    final cacheEntry = {
      'data': data,
      'timestamp': timestamp,
    };
    
    await prefs.setString('$_prefix$key', jsonEncode(cacheEntry));
  }

  static Future<T?> getCachedData<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString('$_prefix$key');
    
    if (cachedString == null) return null;
    
    try {
      final cacheEntry = jsonDecode(cachedString) as Map<String, dynamic>;
      final timestamp = DateTime.parse(cacheEntry['timestamp'] as String);
      
      // Check if cache is still valid
      if (DateTime.now().difference(timestamp) > _maxCacheAge) {
        await prefs.remove('$_prefix$key');
        return null;
      }
      
      return fromJson(cacheEntry['data'] as Map<String, dynamic>);
    } catch (e) {
      await prefs.remove('$_prefix$key');
      return null;
    }
  }

  static Future<bool> isCacheValid(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString('$_prefix$key');
    
    if (cachedString == null) return false;
    
    try {
      final cacheEntry = jsonDecode(cachedString) as Map<String, dynamic>;
      final timestamp = DateTime.parse(cacheEntry['timestamp'] as String);
      return DateTime.now().difference(timestamp) <= _maxCacheAge;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_prefix));
    
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  static Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString(_lastSyncKey);
    
    if (timestamp == null) return null;
    
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }
}
