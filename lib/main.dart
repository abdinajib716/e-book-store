import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/styles.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/main_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/wishlist_screen.dart';
import 'services/book_service.dart';
import 'services/search_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => BookService()),
        ProxyProvider<BookService, SearchService>(
          update: (ctx, bookService, previous) => SearchService(bookService),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        title: 'E-Book',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppStyles.primaryColor,
          scaffoldBackgroundColor: AppStyles.backgroundColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppStyles.primaryColor,
            primary: AppStyles.primaryColor,
            secondary: AppStyles.secondaryColor,
            background: AppStyles.backgroundColor,
            surface: AppStyles.surfaceColor,
            error: AppStyles.errorColor,
          ),
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: AppStyles.primaryButtonStyle,
          ),
          navigationBarTheme: NavigationBarThemeData(
            indicatorColor: AppStyles.primaryColor.withOpacity(0.1),
            labelTextStyle: WidgetStateProperty.all(
              AppStyles.bodyStyle.copyWith(fontSize: 12),
            ),
          ),
        ),
        home: const MainScreen(),
        routes: {
          '/cart': (ctx) => const CartScreen(),
          '/wishlist': (ctx) => const WishlistScreen(),
        },
      ),
    );
  }
}
