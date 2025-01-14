# 📚 Book Store Core Directory Documentation

## 🔧 Configuration (`/core/config/`)

### 🌐 `api_config.dart`
**Path:** `/core/config/api_config.dart`
**Purpose:** Manages API configuration and endpoints
- 🔄 Environment-aware URL configuration
- 🎯 Centralized endpoint definitions
- 🔑 API headers management
- 📡 Development/Production mode detection

### ⚙️ `app_config.dart`
**Path:** `/core/config/app_config.dart`
**Purpose:** Application-wide configuration
- 🎨 App-wide settings
- 🔧 Feature flags
- 📱 Device-specific configurations

### 🛠️ `dev_config.dart`
**Path:** `/core/config/dev_config.dart`
**Purpose:** Development environment settings
- 🐛 Debug settings
- 🧪 Test configurations
- 📊 Development tools setup

## 🎨 Constants (`/core/constants/`)

### 💅 `styles.dart`
**Path:** `/core/constants/styles.dart`
**Purpose:** Global styling constants
- 🎭 Theme definitions
- 📐 Common dimensions
- 🖌️ Typography settings
- 🎪 Animation durations

## ⚠️ Exceptions (`/core/exceptions/`)

### 🚫 `api_exceptions.dart`
**Path:** `/core/exceptions/api_exceptions.dart`
**Purpose:** Custom API exception handling
- ❌ HTTP status code handling
- 🌐 Network error management
- ✅ Validation error handling
- 📝 Error message formatting

## 🌐 Network (`/core/network/`)

### 🔄 `network_error_handler.dart`
**Path:** `/core/network/network_error_handler.dart`
**Purpose:** Network error management
- 🚦 Error classification
- 📝 Human-readable error messages
- 🔄 Retry logic implementation

### 🔄 `retry_policy.dart`
**Path:** `/core/network/retry_policy.dart`
**Purpose:** Request retry management
- ⏱️ Retry timing configuration
- 🔄 Exponential backoff
- 🎯 Retry conditions

## 🔌 Services (`/core/services/`)

### 📡 `connectivity_service.dart`
**Path:** `/core/services/connectivity_service.dart`
**Purpose:** Network connectivity management
- 🔍 Connection state monitoring
- 🔄 Real-time status updates
- 🌐 Connection quality checks
- 🔧 Fallback handling

### 🛠️ `connectivity_helper.dart`
**Path:** `/core/services/connectivity_helper.dart`
**Purpose:** Connectivity utility functions
- 🔧 Connection test helpers
- 📊 Status reporting
- 🔍 Network diagnostics

## 💾 Storage (`/core/storage/`)

### 📦 `offline_storage.dart`
**Path:** `/core/storage/offline_storage.dart`
**Purpose:** Local data persistence
- 💾 Data caching
- ⏱️ Cache invalidation
- 🔄 Sync status tracking
- 🔒 Secure storage handling

## 🎨 Theme (`/core/theme/`)

### 🎭 `app_theme.dart`
**Path:** `/core/theme/app_theme.dart`
**Purpose:** Application theming
- 🌓 Light/Dark theme support
- 🎨 Material 3 implementation
- 📝 Custom fonts (Google Fonts)
- 🔧 Component-specific themes

## 🛠️ Utils (`/core/utils/`)

### 🧪 `api_tester.dart`
**Path:** `/core/utils/api_tester.dart`
**Purpose:** API testing utilities
- 🔍 Endpoint testing
- 🔐 Auth flow validation
- 📊 Response logging
- 🐛 Debug helpers

---

## 📋 Summary of Core Features
- 🔒 Robust error handling
- 🌐 Environment-aware configuration
- 📱 Offline-first capabilities
- 📡 Network state management
- 🎯 Clean architecture implementation
- 🔑 Secure data handling
- 🎨 Consistent theming
- 🧪 Development tools
