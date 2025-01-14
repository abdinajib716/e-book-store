import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/styles.dart';
import '../../../core/services/connectivity_service.dart';
import '../widgets/connectivity/connectivity_banner.dart';
import '../widgets/connectivity/no_connection_screen.dart';
import '../home/home_screen.dart';
import '../categories/categories_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late ScrollController _scrollController;
  bool _isScrolled = false;
  late AnimationController _animationController;
  late Animation<double> _elevationAnimation;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers first
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Initialize animation after controller
    _elevationAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // Add listeners last
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() => _isScrolled = true);
      _animationController.forward();
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() => _isScrolled = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: _isScrolled ? 2 : 0,
        shadowColor: Colors.black26,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/app_icon.png',
              height: 32,
              width: 32,
            ),
            const SizedBox(width: 8),
            const Text(
              'Book Store',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black87),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            _onScroll();
          }
          return false;
        },
        child: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            const ConnectivityBanner(),
            StreamBuilder<bool>(
              stream: context.read<ConnectivityService>().onlineStatus,
              builder: (context, snapshot) {
                final isOnline = snapshot.data ?? true;
                if (!isOnline) {
                  return NoConnectionScreen(
                    onRetry: () {
                      context.read<ConnectivityService>().checkConnection();
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
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
