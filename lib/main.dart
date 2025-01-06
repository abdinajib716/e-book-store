import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

import 'core/constants/styles.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/wishlist_provider.dart';
import 'data/services/auth_service.dart';
import 'data/services/book_service.dart';
import 'data/services/search_service.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/services/api_client.dart';
import 'presentation/routes/routes.dart';
import 'presentation/screens/auth/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Initialize dependencies
  final apiClient = ApiClient();
  final authLocalDataSource = AuthLocalDataSourceImpl(prefs: prefs);
  final authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient: apiClient);

  final authService = AuthService(
    localDataSource: authLocalDataSource,
    remoteDataSource: authRemoteDataSource,
  );

  // Initialize AppLinks
  final appLinks = AppLinks();

  runApp(MyApp(
    authService: authService,
    appLinks: appLinks,
  ));
}

class MyApp extends StatefulWidget {
  final AuthService authService;
  final AppLinks appLinks;

  const MyApp({
    super.key,
    required this.authService,
    required this.appLinks,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri>? _linkSubscription;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _setupDeepLinkHandling();
  }

  Future<void> _setupDeepLinkHandling() async {
    // Handle initial URI
    try {
      final initialUri = await widget.appLinks.getInitialAppLinkString();
      if (initialUri != null) {
        _handleDeepLink(Uri.parse(initialUri));
      }
    } catch (e) {
      debugPrint('Error handling initial deep link: $e');
    }

    // Handle incoming links when app is running
    _linkSubscription = widget.appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      },
      onError: (err) {
        debugPrint('Error handling deep link: $err');
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    if (uri.path.startsWith('/reset-password')) {
      final token = uri.queryParameters['token'];
      if (token != null) {
        _navigatorKey.currentState?.pushNamed(
          Routes.resetPassword,
          arguments: {'token': token},
        );
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: widget.authService,
          ),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        Provider(create: (_) => BookService()),
        ProxyProvider<BookService, SearchService>(
          update: (context, bookService, previous) =>
              SearchService(bookService),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Book Store',
          theme: ThemeData(
            primaryColor: AppStyles.primaryColor,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          initialRoute: auth.isAuthenticated ? Routes.home : Routes.language,
          onGenerateRoute: (settings) {
            if (Routes.requiresAuth(settings.name ?? '') &&
                !auth.isAuthenticated) {
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, _, __) =>
                    Routes.getRoutes()[Routes.login]!(context),
                transitionsBuilder: _buildTransition,
              );
            }

            final routes = Routes.getRoutes();
            final builder = routes[settings.name];
            if (builder != null) {
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, _, __) => builder(context),
                transitionsBuilder: _buildTransition,
              );
            }
            return null;
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  Widget _buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
