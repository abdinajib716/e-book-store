import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book_model.dart';

abstract class BookLocalDataSource {
  Future<List<BookModel>> getAllBooks();
  Future<BookModel?> getBookById(String id);
  Future<List<BookModel>> getBooksByCategory(String category);
  Future<List<BookModel>> searchBooks(String query);
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  static final BookLocalDataSourceImpl _instance = BookLocalDataSourceImpl._internal();
  List<BookModel>? _cachedBooks;

  factory BookLocalDataSourceImpl() {
    return _instance;
  }

  BookLocalDataSourceImpl._internal();

  @override
  Future<List<BookModel>> getAllBooks() async {
    if (_cachedBooks != null) {
      return _cachedBooks!;
    }

    try {
      final String response = await rootBundle.loadString('assets/books/books.json');
      final data = json.decode(response);
      
      if (!data.containsKey('books')) {
        throw FormatException('Invalid JSON format: missing "books" key');
      }

      final List<dynamic> booksData = data['books'];
      _cachedBooks = booksData.map<BookModel>((json) => BookModel.fromJson(json)).toList();
      
      return _cachedBooks!;
    } catch (e) {
      print('Error loading books: $e');
      return [];
    }
  }

  @override
  Future<BookModel?> getBookById(String id) async {
    try {
      final allBooks = await getAllBooks();
      return allBooks.firstWhere(
        (book) => book.id == id,
        orElse: () => throw Exception('Book not found'),
      );
    } catch (e) {
      print('Error getting book by ID: $e');
      return null;
    }
  }

  @override
  Future<List<BookModel>> getBooksByCategory(String category) async {
    try {
      final allBooks = await getAllBooks();
      return allBooks.where((book) => 
        book.categories.any((cat) => 
          cat.toLowerCase() == category.toLowerCase()
        )
      ).toList();
    } catch (e) {
      print('Error getting books by category: $e');
      return [];
    }
  }

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final books = await getAllBooks();
      query = query.toLowerCase();
      return books.where((book) {
        return book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query) ||
            book.description.toLowerCase().contains(query) ||
            book.categories.any((category) => category.toLowerCase().contains(query));
      }).toList();
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }
}
