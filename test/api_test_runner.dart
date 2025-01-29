import 'package:flutter/material.dart';
import '../lib/core/services/api_test_helper.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  print('\n📱 Starting API Test Runner...');
  
  try {
    await ApiTestHelper.testApi();
  } catch (e) {
    print('🚨 Test Runner Error: $e');
  } finally {
    print('🏁 Test Runner Completed');
  }
} 