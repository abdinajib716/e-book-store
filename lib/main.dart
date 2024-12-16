import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/categories_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
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
        Provider(
          create: (ctx) => BookService(),
        ),
        ProxyProvider<BookService, SearchService>(
          update: (ctx, bookService, previous) => SearchService(bookService),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => WishlistProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Book Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: const MainScreen(),
        routes: {
          '/cart': (ctx) => const CartScreen(),
          '/wishlist': (ctx) => const WishlistScreen(),
          '/search': (ctx) => const SearchScreen(),
          '/profile': (ctx) => const ProfileScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
