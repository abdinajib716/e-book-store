# 🎨 Book Store Presentation Directory Documentation

## 📱 Providers (`/presentation/providers/`)

### 🔐 `auth_provider.dart`
**Path:** `/presentation/providers/auth_provider.dart`
**Purpose:** Authentication state management
Features:
- 👤 User authentication state
- 🔄 Token refresh management
- ⏲️ Session timeout handling
- 🌐 Online/Offline state
- 🔒 Security features
- 💾 Remember me functionality

### 🛒 `cart_provider.dart`
**Path:** `/presentation/providers/cart_provider.dart`
**Purpose:** Shopping cart state management
Features:
- 📦 Cart items management
- 💰 Price calculations
- 🔢 Quantity updates
- 💾 Cart persistence
- 🔄 Sync with backend

### ❤️ `wishlist_provider.dart`
**Path:** `/presentation/providers/wishlist_provider.dart`
**Purpose:** Wishlist management
Features:
- 📚 Wishlist items
- 💾 Persistence
- 🔄 Sync functionality
- 📱 UI updates

## 🛣️ Routes (`/presentation/routes/`)

### 🗺️ `routes.dart`
**Path:** `/presentation/routes/routes.dart`
**Purpose:** Application navigation
Features:
- 🗺️ Route definitions
- 🔒 Route guards
- 🔄 Navigation handling
- 📱 Screen transitions
- 🏗️ Route generation

## 📱 Screens (`/presentation/screens/`)

### 🔐 Auth Screens (`/screens/auth/`)
- `email_verification_screen.dart`: Email verification UI
- `forgot_password_screen.dart`: Password recovery
- `language_selection_screen.dart`: Language preferences
- `login_screen.dart`: User login
- `onboarding_screen.dart`: First-time user experience
- `register_screen.dart`: User registration
- `registration_success_screen.dart`: Success feedback
- `reset_password_screen.dart`: Password reset

### 📚 Books Screens (`/screens/books/`)
- Book listing
- Book details
- Reading interface

### 🛒 Cart Screens (`/screens/cart/`)
- Shopping cart interface
- Checkout process

### 📑 Categories Screens (`/screens/categories/`)
- Category listing
- Filtered book views

### 🏠 Home Screen (`/screens/home/`)
- `home_screen.dart`: Main app interface
Features:
- 📚 Featured books
- 🔍 Quick search
- 📱 Navigation menu
- 🎯 Personalized content

### 📚 Library Screens (`/screens/library/`)
- User's book collection
- Reading progress

### 🏛️ Main Screens (`/screens/main/`)
- App shell
- Navigation structure

### 💳 Payment Screens (`/screens/payment/`)
- Payment processing
- Transaction history

### 👤 Profile Screens (`/screens/profile/`)
- User profile management
- Settings

### 🔍 Search Screens (`/screens/search/`)
- Search interface
- Advanced filters

### 🎨 Splash Screen (`/screens/splash/`)
- App loading
- Initial setup

### ❤️ Wishlist Screens (`/screens/wishlist/`)
- Wishlist management
- Item actions

## 🛠️ Utils (`/presentation/utils/`)

### 🌐 `connection_utils.dart`
**Path:** `/presentation/utils/connection_utils.dart`
**Purpose:** Network utilities
Features:
- 📡 Connection checking
- 🔄 Retry logic
- 📱 UI feedback

## 🧩 Widgets (`/presentation/widgets/`)

### 🌐 `network_aware_widget.dart`
**Path:** `/presentation/widgets/network_aware_widget.dart`
**Purpose:** Network-aware UI components
Features:
- 🌐 Connection status display
- 📱 Offline mode handling
- 🔄 Auto-retry functionality
- 💫 Loading states

---

## 📋 Summary of Presentation Layer Features

### 🎯 Core Responsibilities
1. **State Management**
   - 📱 UI state
   - 🔐 Authentication
   - 🛒 Shopping features
   - 💾 Local state persistence

2. **Navigation**
   - 🗺️ Route management
   - 🔒 Protected routes
   - 📱 Screen transitions

3. **User Interface**
   - 🎨 Consistent design
   - 📱 Responsive layouts
   - 🌐 Offline support
   - 💫 Smooth animations

4. **User Experience**
   - 🎯 Intuitive navigation
   - 📝 Form handling
   - ⚡ Performance optimization
   - 🔍 Search functionality

### 🔗 Integration Points
- 📊 Domain layer connection
- 💾 Data persistence
- 🌐 Network handling
- 🔐 Security implementation

### 🎨 Design Patterns
- 📱 Provider pattern
- 🏗️ Widget composition
- 🔄 State management
- 🎯 Screen architecture
