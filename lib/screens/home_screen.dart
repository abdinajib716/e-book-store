import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/book_card.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../screens/book_details_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/profile_screen.dart';
import '../providers/cart_provider.dart';
import '../constants/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookService _bookService = BookService();
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final books = await _bookService.loadBooksByCategory('somali_literature');
      if (mounted) {
        setState(() {
          _books = books;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading books: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No books available',
              style: AppStyles.subheadingStyle,
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Text(
            'Book Store',
            style: AppStyles.headingStyle,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.pushNamed(context, '/search'),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: AppStyles.headingStyle,
                ),
                Text(
                  'Discover your next favorite book',
                  style: AppStyles.subheadingStyle,
                ),
              ],
            ),
          ),
        ),
        if (_books.isNotEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _books.length.clamp(0, 5),
                itemBuilder: (context, index) => _buildFeaturedBook(
                  context,
                  _books[index],
                ),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Books',
                  style: AppStyles.headingStyle,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: AppStyles.subheadingStyle.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= _books.length) return null;
                final book = _books[index];
                return BookCard(book: book);
              },
              childCount: _books.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );
  }

  Widget _buildFeaturedBook(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: book),
          ),
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            Container(
              decoration: AppStyles.cardDecoration.copyWith(
                image: DecorationImage(
                  image: AssetImage(book.imageAssetPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: AppStyles.headingStyle.copyWith(color: Colors.white),
                  ),
                  Text(
                    book.author,
                    style: AppStyles.subheadingStyle.copyWith(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
