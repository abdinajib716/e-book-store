import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'services/book_service.dart';
import 'services/search_service.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
          title: 'Somali Library',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1E88E5),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(),
            useMaterial3: true,
          ),
          initialRoute: Routes.language,
          routes: Routes.getRoutes(),
          onGenerateRoute: (settings) {
            // Check if route requires authentication
            if (Routes.requiresAuth(settings.name ?? '') && !auth.isAuthenticated) {
              // Redirect to login if not authenticated
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, _, __) => Routes.getRoutes()[Routes.login]!(context),
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
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (ctx) => Scaffold(
                body: Center(
                  child: Text(
                    'Boggan ma jiro',
                    style: Theme.of(ctx).textTheme.headlineSmall,
                  ),
                ),
              ),
            );
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
