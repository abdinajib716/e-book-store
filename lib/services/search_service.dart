import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book.dart';
import 'book_service.dart';

class SearchService {
  final BookService _bookService;
  Map<String, dynamic>? _searchIndex;

  SearchService(this._bookService);

  Future<void> _loadSearchIndex() async {
    if (_searchIndex != null) return;

    final String jsonString = await rootBundle.loadString('assets/books/catalog/search_index.json');
    _searchIndex = json.decode(jsonString);
  }

  Future<List<Book>> searchBooks(String query) async {
    await _loadSearchIndex();
    if (query.isEmpty) return [];

    query = query.toLowerCase();
    final List<String> matchingIds = [];

    _searchIndex!.forEach((id, data) {
      final String title = data['title'].toString().toLowerCase();
      final String author = data['author'].toString().toLowerCase();
      final String category = data['category'].toString().toLowerCase();

      if (title.contains(query) || 
          author.contains(query) || 
          category.contains(query)) {
        matchingIds.add(id);
      }
    });

    final List<Book> results = [];
    for (var id in matchingIds) {
      final category = _searchIndex![id]['category'];
      final books = await _bookService.loadBooksByCategory(category);
      final book = books.firstWhere(
        (book) => book.id == id,
        orElse: () => null as Book,
      );
      if (book != null) {
        results.add(book);
      }
    }

    return results;
  }
}
