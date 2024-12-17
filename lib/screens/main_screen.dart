import 'package:flutter/material.dart';
import '../constants/styles.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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
        backgroundColor: Colors.white,
        elevation: 8,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppStyles.subtitleColor),
            selectedIcon: Icon(Icons.home, color: AppStyles.primaryColor),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined, color: AppStyles.subtitleColor),
            selectedIcon: Icon(Icons.category, color: AppStyles.primaryColor),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline, color: AppStyles.subtitleColor),
            selectedIcon: Icon(Icons.favorite, color: AppStyles.primaryColor),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppStyles.subtitleColor),
            selectedIcon: Icon(Icons.person, color: AppStyles.primaryColor),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
