import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class BookListScreen extends StatelessWidget {
  final String title;
  final List<Book> books;

  const BookListScreen({
    Key? key,
    required this.title,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
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
      body: books.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No books available in this category',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookCard(book: books[index]);
              },
            ),
    );
  }
}
