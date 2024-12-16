import 'book.dart';

class Cart {
  List<Book> items = [];

  void addBook(Book book) {
    items.add(book);
  }

  void removeBook(Book book) {
    items.remove(book);
  }

  double get totalPrice {
    return items.fold(0, (total, book) => total + book.price);
  }
}
