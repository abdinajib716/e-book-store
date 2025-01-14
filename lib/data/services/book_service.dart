import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/models/book.dart';

class BookService {
  static final BookService _instance = BookService._internal();
  List<Book>? _cachedBooks;

  factory BookService() {
    return _instance;
  }

  BookService._internal();

  Future<List<Book>> loadAllBooks() async {
    if (_cachedBooks != null) {
      return _cachedBooks!;
    }

    try {
      print('Starting to load books...');
      final String response =
          await rootBundle.loadString('assets/books/books.json');
      print('Books JSON loaded successfully');

      final data = json.decode(response);
      print('JSON decoded successfully');

      if (!data.containsKey('books')) {
        throw FormatException('Invalid JSON format: missing "books" key');
      }

      final List<dynamic> booksData = data['books'];
      print('Found ${booksData.length} books in JSON');

      _cachedBooks = booksData.map<Book>((json) {
        try {
          final book = Book.fromJson(json);
          print('Successfully parsed book: ${book.title}');
          return book;
        } catch (e) {
          print('Error parsing book: $json');
          print('Error details: $e');
          rethrow;
        }
      }).toList();

      print('Successfully loaded ${_cachedBooks!.length} books');
      return _cachedBooks!;
    } catch (e) {
      print('Error loading books: $e');
      print('Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  Future<Book?> getBookById(String id) async {
    try {
      final allBooks = await loadAllBooks();
      return allBooks.firstWhere(
        (book) => book.id == id,
        orElse: () => throw Exception('Book not found'),
      );
    } catch (e) {
      print('Error getting book by ID: $e');
      return null;
    }
  }

  Future<List<Book>> getBooksByCategory(String category) async {
    try {
      final allBooks = await loadAllBooks();
      return allBooks
          .where((book) => book.categories
              .any((cat) => cat.toLowerCase() == category.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error getting books by category: $e');
      return [];
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      final books = await loadAllBooks();
      query = query.toLowerCase();
      return books.where((book) {
        return book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query) ||
            book.description.toLowerCase().contains(query) ||
            book.categories
                .any((category) => category.toLowerCase().contains(query));
      }).toList();
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }
}
