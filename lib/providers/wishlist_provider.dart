import 'package:flutter/foundation.dart';
import '../models/book.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, Book> _items = {};

  Map<String, Book> get items => {..._items};

  List<Book> get itemsList => _items.values.toList();

  int get itemCount => _items.length;

  void toggleWishlist(Book book) {
    if (_items.containsKey(book.id)) {
      _items.remove(book.id);
    } else {
      _items[book.id] = book;
    }
    notifyListeners();
  }

  bool isInWishlist(Book book) {
    return _items.containsKey(book.id);
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
