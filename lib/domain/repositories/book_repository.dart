import '../entities/models/book.dart';

abstract class BookRepository {
  Future<List<Book>> getAllBooks();
  Future<Book?> getBookById(String id);
  Future<List<Book>> getBooksByCategory(String category);
  Future<List<Book>> searchBooks(String query);
}
