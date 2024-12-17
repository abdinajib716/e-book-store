import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book.dart';

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
      final String response = await rootBundle.loadString('assets/books/books.json');
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
          print('Successfully parsed book: ${book.title} with categories: ${book.categories}');
          return book;
        } catch (e) {
          print('Error parsing book: $json');
          print('Error details: $e');
          rethrow;
        }
      }).toList();

      print('Successfully loaded ${_cachedBooks!.length} books');
      return _cachedBooks!;
    } catch (e, stackTrace) {
      print('Error loading books: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  String _normalizeCategory(String category) {
    // Convert to lowercase and remove special characters
    return category.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
  }

  Future<List<Book>> loadBooksByCategory(String categoryId) async {
    try {
      print('\nLoading books for category: $categoryId');
      
      // Load all books first
      final allBooks = await loadAllBooks();
      print('Total books loaded: ${allBooks.length}');
      
      // Try to load the category file
      String? categoryName;
      List<String> bookIds = [];
      
      try {
        final String categoryJson = await rootBundle.loadString('assets/books/catalog/$categoryId.json');
        final categoryData = json.decode(categoryJson);
        
        if (categoryData.containsKey('category')) {
          final category = categoryData['category'];
          categoryName = category['name'] as String;
          bookIds = List<String>.from(category['books']);
          print('Loaded from category file - Name: $categoryName, Book IDs: $bookIds');
        }
      } catch (e) {
        print('Category file not found, falling back to books.json categories');
      }
      
      // If category file wasn't found, get the category name from categories.json
      if (categoryName == null) {
        try {
          final String categoriesJson = await rootBundle.loadString('assets/books/categories.json');
          final categoriesData = json.decode(categoriesJson);
          final categories = List<Map<String, dynamic>>.from(categoriesData['categories']);
          
          final category = categories.firstWhere((c) => c['id'] == categoryId);
          categoryName = category['name'] as String;
          print('Found category name from categories.json: $categoryName');
        } catch (e) {
          print('Error loading category name: $e');
          return [];
        }
      }
      
      if (categoryName == null) {
        print('Could not find category name');
        return [];
      }
      
      // Filter books that match either the ID or category name
      final normalizedCategoryName = _normalizeCategory(categoryName);
      print('Normalized category name: $normalizedCategoryName');
      
      final categoryBooks = allBooks.where((book) {
        // Check if book ID is in the category's book list
        final matchById = bookIds.contains(book.id);
        
        // Check if book's categories contain this category name
        final matchByCategory = book.categories.any((cat) {
          final normalizedBookCategory = _normalizeCategory(cat);
          final matches = normalizedBookCategory == normalizedCategoryName;
          print('Comparing book category "$cat" ($normalizedBookCategory) with "$categoryName" ($normalizedCategoryName): $matches');
          return matches;
        });
        
        print('Book "${book.title}": matchById=$matchById, matchByCategory=$matchByCategory');
        return matchById || matchByCategory;
      }).toList();
      
      print('\nFound ${categoryBooks.length} books in category "$categoryName":');
      for (var book in categoryBooks) {
        print('- ${book.title} (ID: ${book.id})');
      }
      
      return categoryBooks;
    } catch (e, stackTrace) {
      print('\nError loading books by category: $e');
      print('Stack trace: $stackTrace');
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
}
