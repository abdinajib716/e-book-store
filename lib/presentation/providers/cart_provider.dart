import 'package:flutter/foundation.dart';
import '../../domain/entities/models/book.dart';

class CartItem {
  final Book book;
  int quantity;

  CartItem({
    required this.book,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  int get totalQuantity {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + (item.book.price * item.quantity),
    );
  }

  double get savings {
    return _items.values.fold(
      0.0,
      (sum, item) =>
          sum + ((item.book.originalPrice - item.book.price) * item.quantity),
    );
  }

  void addItem(Book book) {
    if (_items.containsKey(book.id)) {
      // Increment quantity if item exists
      _items.update(
        book.id,
        (existingItem) => CartItem(
          book: existingItem.book,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      // Add new item if it doesn't exist
      _items.putIfAbsent(
        book.id,
        () => CartItem(book: book),
      );
    }
    notifyListeners();
  }

  void removeItem(String bookId) {
    _items.remove(bookId);
    notifyListeners();
  }

  void decrementQuantity(String bookId) {
    if (!_items.containsKey(bookId)) return;

    if (_items[bookId]!.quantity > 1) {
      _items.update(
        bookId,
        (existingItem) => CartItem(
          book: existingItem.book,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(bookId);
    }
    notifyListeners();
  }

  void incrementQuantity(String bookId) {
    if (!_items.containsKey(bookId)) return;

    _items.update(
      bookId,
      (existingItem) => CartItem(
        book: existingItem.book,
        quantity: existingItem.quantity + 1,
      ),
    );
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
