# 📱 Book Store Flutter App Structure

## 📁 Project Structure Overview

```
book_store/
├── 📱 lib/
│   ├── 🔧 core/
│   │   ├── config/
│   │   │   └── api_config.dart
│   │   ├── constants/
│   │   │   └── styles.dart
│   │   └── exceptions/
│   │       └── api_exceptions.dart
│   ├── 💾 data/
│   │   ├── datasources/
│   │   │   ├── auth_local_datasource.dart
│   │   │   ├── auth_remote_datasource.dart
│   │   │   └── book_local_datasource.dart
│   │   ├── models/
│   │   │   ├── book_model.dart
│   │   │   └── user_model.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository_impl.dart
│   │   │   └── book_repository_impl.dart
│   │   └── services/
│   │       ├── api_client.dart
│   │       ├── auth_service.dart
│   │       ├── book_service.dart
│   │       └── search_service.dart
│   ├── 🏗️ domain/
│   │   ├── entities/models/
│   │   │   ├── book.dart
│   │   │   ├── cart.dart
│   │   │   └── user.dart
│   │   └── repositories/
│   │       ├── auth_repository.dart
│   │       └── book_repository.dart
│   ├── 🎨 presentation/
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── cart_provider.dart
│   │   │   └── wishlist_provider.dart
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   │   ├── email_verification_screen.dart
│   │   │   │   ├── forgot_password_screen.dart
│   │   │   │   ├── language_selection_screen.dart
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── onboarding_screen.dart
│   │   │   │   ├── register_screen.dart
│   │   │   │   ├── registration_success_screen.dart
│   │   │   │   └── reset_password_screen.dart
│   │   │   ├── books/
│   │   │   │   ├── book_details_screen.dart
│   │   │   │   ├── book_list_screen.dart
│   │   │   │   └── book_preview_screen.dart
│   │   │   ├── cart/
│   │   │   │   └── cart_screen.dart
│   │   │   ├── categories/
│   │   │   │   └── categories_screen.dart
│   │   │   ├── home/
│   │   │   │   └── home_screen.dart
│   │   │   ├── library/
│   │   │   │   ├── book_reader_screen.dart
│   │   │   │   ├── downloads_screen.dart
│   │   │   │   └── my_books_screen.dart
│   │   │   ├── main/
│   │   │   │   └── main_screen.dart
│   │   │   ├── payment/
│   │   │   │   ├── payment_method_screen.dart
│   │   │   │   └── payment_success_screen.dart
│   │   │   ├── profile/
│   │   │   │   └── profile_screen.dart
│   │   │   ├── search/
│   │   │   │   └── search_screen.dart
│   │   │   └── splash/
│   │   │       └── splash_screen.dart
│   │   └── widgets/
│   │       ├── book_card_skeleton.dart
│   │       ├── book_card.dart
│   │       ├── cart_badge.dart
│   │       ├── category_card_skeleton.dart
│   │       ├── category_card.dart
│   │       ├── loading_overlay.dart
│   │       └── preview_limit_overlay.dart
│   ├── 🛠️ services/
│   │   └── auth_service.dart
│   ├── 🔧 utils/
│   │   └── main.dart
│   └── 📱 main.dart
└── 🎨 assets/
    ├── images/
    ├── fonts/
    └── translations/
```

## 🔧 Key Components Description

### Core Module
- **Config**: API configurations
- **Constants**: App-wide styles and constants
- **Exceptions**: Custom API exception handling

### Data Layer
- **Datasources**: Local and remote data handling
- **Models**: Data models for books and users
- **Repositories**: Implementation of domain repositories
- **Services**: API and authentication services

### Domain Layer
- **Entities/Models**: Core business objects
- **Repositories**: Abstract repository definitions

### Presentation Layer
- **Providers**: State management using providers
- **Screens**: All app screens organized by feature
- **Widgets**: Reusable UI components

### Services
- Authentication service implementation

### Utils
- Utility functions and helpers

## 📱 Main Features

1. **Authentication**
   - Login/Register
   - Email verification
   - Password recovery
   - Language selection

2. **Books**
   - Book listing
   - Book details
   - Preview functionality
   - Categories

3. **Shopping**
   - Cart management
   - Payment processing
   - Wishlist

4. **Library**
   - Book reader
   - Downloads
   - My books section

5. **User Profile**
   - Profile management
   - Settings

## 🔧 Technical Details

- **State Management**: Provider
- **Navigation**: Named routes
- **API Integration**: REST API
- **Local Storage**: Shared Preferences
- **UI Components**: Material Design

---

Last Updated: December 30, 2024
