import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/styles.dart';
import '../../../data/services/book_service.dart';
import '../../../domain/entities/models/book.dart';
import '../books/book_list_screen.dart';
import '../search/search_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final String response =
          await rootBundle.loadString('assets/books/categories.json');
      final data = await json.decode(response);
      setState(() {
        categories = data['categories'];
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error loading categories: $e',
              style: AppStyles.bodyStyle,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Discover Books', style: AppStyles.headingStyle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: AppStyles.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return InkWell(
                    onTap: () async {
                      try {
                        final bookService = BookService();
                        final List<Book> books =
                            await bookService.getBooksByCategory(
                          category['name'],
                        );

                        if (books.isEmpty) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('No books found in this category'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                          return;
                        }

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookListScreen(
                                title: category['name'],
                                books: books,
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error loading books: $e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error loading books: $e',
                                style: AppStyles.bodyStyle,
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(
                                category['color'].substring(1, 7),
                                radix: 16) +
                            0xFF000000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIconData(category['icon']),
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['name'],
                            style: AppStyles.bodyStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'book':
        return Icons.book;
      case 'psychology':
        return Icons.psychology;
      case 'healing':
        return Icons.healing;
      case 'psychology_alt':
        return Icons.psychology_alt;
      case 'computer':
        return Icons.computer;
      case 'groups':
        return Icons.groups;
      case 'mosque':
        return Icons.mosque;
      default:
        return Icons.book;
    }
  }
}
