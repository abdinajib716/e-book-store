import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/book.dart';
import 'book_service.dart';

class SearchResult {
  final Book book;
  final double score;
  final SearchMatchType matchType;

  SearchResult(this.book, this.score, this.matchType);
}

enum SearchMatchType {
  title,
  author,
  category,
  searchTerm
}

class SearchService {
  final BookService _bookService;
  List<Map<String, dynamic>>? _searchIndex;

  SearchService(this._bookService);

  Future<void> _loadSearchIndex() async {
    if (_searchIndex != null) return;

    try {
      final String jsonString = await rootBundle.loadString('assets/books/search_index.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      _searchIndex = List<Map<String, dynamic>>.from(data['books']);
      print('Search index loaded successfully: ${_searchIndex?.length} items');
    } catch (e) {
      print('Error loading search index: $e');
      _searchIndex = [];
    }
  }

  double _calculateScore(String text, String query) {
    if (text.isEmpty || query.isEmpty) return 0.0;
    
    text = text.toLowerCase();
    query = query.toLowerCase();
    
    if (text == query) return 1.0;
    if (text.startsWith(query)) return 0.8;
    if (text.contains(query)) return 0.6;
    
    final List<String> textWords = text.split(RegExp(r'\s+'));
    final List<String> queryWords = query.split(RegExp(r'\s+'));
    
    double maxWordScore = 0.0;
    for (final textWord in textWords) {
      for (final queryWord in queryWords) {
        if (textWord == queryWord) {
          maxWordScore = max(maxWordScore, 0.4);
        } else if (textWord.startsWith(queryWord)) {
          maxWordScore = max(maxWordScore, 0.3);
        } else if (textWord.contains(queryWord)) {
          maxWordScore = max(maxWordScore, 0.2);
        }
      }
    }
    
    return maxWordScore;
  }

  Future<List<Book>> searchBooks(String query) async {
    if (query.trim().isEmpty) return [];

    await _loadSearchIndex();
    if (_searchIndex == null || _searchIndex!.isEmpty) return [];

    final Map<String, SearchResult> results = {};

    for (final Map<String, dynamic> bookData in _searchIndex!) {
      double maxScore = 0.0;
      SearchMatchType bestMatchType = SearchMatchType.title;

      // Check title
      final String title = bookData['title'] as String? ?? '';
      final double titleScore = _calculateScore(title, query);
      if (titleScore > maxScore) {
        maxScore = titleScore;
        bestMatchType = SearchMatchType.title;
      }

      // Check author
      final String author = bookData['author'] as String? ?? '';
      final double authorScore = _calculateScore(author, query);
      if (authorScore > maxScore) {
        maxScore = authorScore;
        bestMatchType = SearchMatchType.author;
      }

      // Check categories
      final List<String> categories = List<String>.from(bookData['categories'] ?? []);
      for (final String category in categories) {
        final double categoryScore = _calculateScore(category, query);
        if (categoryScore > maxScore) {
          maxScore = categoryScore;
          bestMatchType = SearchMatchType.category;
        }
      }

      // Check search terms
      final List<String> searchTerms = List<String>.from(bookData['searchTerms'] ?? []);
      for (final String term in searchTerms) {
        final double termScore = _calculateScore(term, query);
        if (termScore > maxScore) {
          maxScore = termScore;
          bestMatchType = SearchMatchType.searchTerm;
        }
      }

      if (maxScore > 0.0) {
        final String bookId = bookData['id'] as String;
        final Book? book = await _bookService.getBookById(bookId);
        
        if (book != null) {
          if (!results.containsKey(bookId) || results[bookId]!.score < maxScore) {
            results[bookId] = SearchResult(book, maxScore, bestMatchType);
          }
        }
      }
    }

    final List<SearchResult> sortedResults = results.values.toList()
      ..sort((a, b) => b.score.compareTo(a.score));
      
    return sortedResults.map((result) => result.book).toList();
  }

  void clearCache() {
    // No cache to clear in this version
  }
}
