import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/category_card.dart';
import './book_list_screen.dart';
import '../services/book_service.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> categories = [
    const {
      'title': 'Somali Literature',
      'icon': Icons.auto_stories,
      'color': Colors.blue,
      'category': 'somali_literature'
    },
    const {
      'title': 'Fiction',
      'icon': Icons.menu_book,
      'color': Colors.green,
      'category': 'fiction'
    },
    const {
      'title': 'Non-Fiction',
      'icon': Icons.library_books,
      'color': Colors.orange,
      'category': 'non_fiction'
    },
    const {
      'title': 'Children',
      'icon': Icons.child_care,
      'color': Colors.purple,
      'category': 'children'
    },
    const {
      'title': 'Education',
      'icon': Icons.school,
      'color': Colors.red,
      'category': 'education'
    },
    const {
      'title': 'History',
      'icon': Icons.history_edu,
      'color': Colors.brown,
      'category': 'history'
    },
    const {
      'title': 'Religion',
      'icon': Icons.mosque,
      'color': Colors.teal,
      'category': 'religion'
    },
    const {
      'title': 'Poetry',
      'icon': Icons.format_quote,
      'color': Colors.indigo,
      'category': 'poetry'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Discover Books',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.tune_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Categories',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  icon: category['icon'],
                  title: category['title'],
                  color: category['color'],
                  onTap: () async {
                    try {
                      final bookService = BookService();
                      final books = await bookService.loadBooksByCategory(
                        category['category'],
                      );
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookListScreen(
                              title: category['title'],
                              books: books,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error loading books: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.7),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
