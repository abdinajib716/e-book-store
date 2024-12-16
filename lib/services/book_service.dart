import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book.dart';

class BookService {
  final Map<String, List<Book>> _cache = {};
  static const String _basePath = 'assets/books';

  Future<List<Book>> loadBooksByCategory(String category) async {
    // Return cached books if available
    if (_cache.containsKey(category)) {
      return _cache[category]!;
    }

    try {
      // Load books catalog
      final String catalogPath = '$_basePath/catalog/$category.json';
      final String jsonString = await rootBundle.loadString(catalogPath);
      final List<dynamic> items = json.decode(jsonString);

      // Load prices
      const String pricesPath = '$_basePath/prices.json';
      final String pricesJsonString = await rootBundle.loadString(pricesPath);
      final Map<String, dynamic> pricesData = json.decode(pricesJsonString);

      final List<Book> books = [];

      for (var item in items) {
        final String bookId = item['id'];
        final Map<String, dynamic> priceInfo = pricesData['prices'][bookId] ??
            {
              'price': item['price'] ?? 19.99,
              'originalPrice': item['price'] ?? 19.99,
              'discounted': false,
            };

        // Fix image and PDF paths
        String imageAssetPath = item['imageAssetPath'] ?? '';
        if (!imageAssetPath.startsWith('assets/')) {
          imageAssetPath = 'assets/books/images/$bookId.jpg';
        }

        String pdfAssetPath = item['pdfAssetPath'] ?? '';
        if (!pdfAssetPath.startsWith('assets/')) {
          pdfAssetPath = 'assets/books/pdfs/$bookId.pdf';
        }

        final book = Book(
          id: bookId,
          title: item['title'] ?? '',
          author: item['author'] ?? '',
          description: item['description'] ?? '',
          imageAssetPath: imageAssetPath,
          pdfAssetPath: pdfAssetPath,
          price: (priceInfo['price'] ?? item['price'] ?? 19.99).toDouble(),
          originalPrice:
              (priceInfo['originalPrice'] ?? item['price'] ?? 19.99).toDouble(),
          isDiscounted: priceInfo['discounted'] ?? false,
          language: item['language'] ?? 'Somali',
          pages: item['pages'] ?? 0,
          rating: (item['rating'] ?? 0.0).toDouble(),
        );
        books.add(book);
      }

      // Cache the results
      _cache[category] = books;
      return books;
    } catch (e) {
      print('Error loading books: $e');
      return [];
    }
  }

  void clearCache() {
    _cache.clear();
  }
}
