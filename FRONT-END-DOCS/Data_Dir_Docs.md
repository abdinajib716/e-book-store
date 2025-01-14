# 📂 Book Store Data Directory Documentation

## 📊 Data Sources (`/data/datasources/`)

### 🔐 `auth_local_datasource.dart`
**Path:** `/data/datasources/auth_local_datasource.dart`
**Purpose:** Local authentication data management
- 💾 User data persistence
- 🔑 Auth token management
- 🧹 Cache clearing functionality
- 🔄 User session management

### 🌐 `auth_remote_datasource.dart`
**Path:** `/data/datasources/auth_remote_datasource.dart`
**Purpose:** Remote authentication operations
- 🔑 Login/Register functionality
- ✉️ Email verification
- 🔄 Password reset
- 👤 Profile management

### 📚 `book_local_datasource.dart`
**Path:** `/data/datasources/book_local_datasource.dart`
**Purpose:** Local book data management
- 📚 Book caching
- 🔍 Local search functionality
- 📖 Reading history
- ⭐ Favorites management

## 📋 Models (`/data/models/`)

### 📚 `book_model.dart`
**Path:** `/data/models/book_model.dart`
**Purpose:** Book data model
- 📖 Book metadata
- 💰 Pricing information
- 🏷️ Categories handling
- ⭐ Rating system
- 📱 Asset path management

### 👤 `user_model.dart`
**Path:** `/data/models/user_model.dart`
**Purpose:** User data model
- 👤 User profile data
- 🔐 Authentication info
- 🌍 Language preferences
- 📱 Profile customization
- 📅 Timestamps management

## 📦 Repositories (`/data/repositories/`)

### 🔐 `auth_repository_impl.dart`
**Path:** `/data/repositories/auth_repository_impl.dart`
**Purpose:** Authentication repository implementation
- 🔑 Authentication operations
- 🔄 Data synchronization
- 🌐 Online/Offline handling
- 🔒 Security implementations
- ⚠️ Error handling

### 📚 `book_repository_impl.dart`
**Path:** `/data/repositories/book_repository_impl.dart`
**Purpose:** Book repository implementation
- 📚 Book data management
- 🔍 Search operations
- 🔄 Cache management
- 📱 Asset handling

## 🛠️ Services (`/data/services/`)

### 🌐 `api_client.dart`
**Path:** `/data/services/api_client.dart`
**Purpose:** API communication handler
- 🌐 HTTP request management
- 🔄 Request interceptors
- ⚠️ Error handling
- 📡 Network state management
- 🔒 Authentication headers
- 📊 Response parsing

### 🔐 `auth_service.dart`
**Path:** `/data/services/auth_service.dart`
**Purpose:** Authentication service
- 🔑 Authentication flow
- 👤 User session management
- 🔒 Security implementations
- 🔄 Token management

### 📚 `book_service.dart`
**Path:** `/data/services/book_service.dart`
**Purpose:** Book service operations
- 📚 Book data operations
- 🔍 Search functionality
- 📖 Reading progress
- 🏷️ Category management

### 🔍 `search_service.dart`
**Path:** `/data/services/search_service.dart`
**Purpose:** Search functionality
- 🔍 Advanced search operations
- 📊 Search results handling
- 🏷️ Category filtering
- 📱 Search suggestions

---

## 📋 Summary of Data Layer Features
- 🔐 Comprehensive authentication system
- 📚 Robust book management
- 🌐 Online/Offline capability
- 🔄 Data synchronization
- 🔍 Advanced search functionality
- 📊 Clean data models
- 🔒 Secure data handling
- ⚠️ Error handling and recovery
