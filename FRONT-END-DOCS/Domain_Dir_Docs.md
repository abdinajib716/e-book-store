# 🏗️ Book Store Domain Directory Documentation

## 📊 Entities (`/domain/entities/models/`)

### 📚 `book.dart`
**Path:** `/domain/entities/models/book.dart`
**Purpose:** Core book entity definition
Features:
- 📝 Basic book information (id, title, author)
- 📖 Content details (description, pages)
- 🖼️ Asset management (image and PDF paths)
- 💰 Pricing logic (original price, discounts)
- 🏷️ Metadata (language, categories)
- ⭐ Rating system
- 🔄 JSON serialization/deserialization

### 🛒 `cart.dart`
**Path:** `/domain/entities/models/cart.dart`
**Purpose:** Shopping cart entity
Features:
- 📦 Cart item management
- 💰 Price calculations
- 🔢 Quantity handling
- 💾 Cart persistence

### 👤 `user.dart`
**Path:** `/domain/entities/models/user.dart`
**Purpose:** User entity definition
Features:
- 👤 Basic user information
  - ID and email
  - Full name
  - Phone number
  - Profile picture
- 📅 User metadata
  - Date of birth
  - Gender
  - Created/Last login dates
- 🌍 Preferences
  - Language settings
  - Interests
- ✅ Account status
  - Email verification
  - Account timestamps
- 🔄 JSON conversion utilities

## 📝 Repositories (`/domain/repositories/`)

### 🔐 `auth_repository.dart`
**Path:** `/domain/repositories/auth_repository.dart`
**Purpose:** Authentication repository contract
Features:
- 🔑 Authentication operations
  - Login
  - Register
  - Logout
- ✉️ Email verification
  - Send verification
  - Verify email
- 🔒 Password management
  - Forgot password
  - Reset password
- 👤 Profile operations
  - Get current user
  - Update profile
- 🔄 Token management
  - Refresh token

### 📚 `book_repository.dart`
**Path:** `/domain/repositories/book_repository.dart`
**Purpose:** Book repository contract
Features:
- 📚 Book operations
  - Fetch books
  - Get book details
- 🔍 Search functionality
- 🏷️ Category management
- ⭐ Rating operations
- 💾 Cache management

---

## 📋 Summary of Domain Layer Features

### 🎯 Core Responsibilities
- 📝 Business logic definition
- 🏗️ Entity structure
- 📊 Data contracts
- 🔐 Security protocols

### 🔑 Key Features
1. **Clean Architecture Implementation**
   - 🏗️ Clear separation of concerns
   - 📝 Domain-driven design
   - 🔄 Repository pattern

2. **Strong Type Safety**
   - ✅ Null safety
   - 🔒 Immutable entities
   - 🎯 Type definitions

3. **Business Rules**
   - 📚 Book management
   - 👤 User handling
   - 🔐 Authentication flow
   - 🛒 Shopping features

4. **Data Integrity**
   - ✅ Validation rules
   - 🔄 Data transformation
   - 💾 Persistence contracts

### 🔗 Layer Integration
- 📱 Presentation layer connection
- 💾 Data layer abstraction
- 🔄 Repository pattern implementation
- 🎯 Use case definitions
