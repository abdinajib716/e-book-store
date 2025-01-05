import '../../domain/entities/models/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_local_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final BookLocalDataSource localDataSource;

  BookRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Book>> getAllBooks() async {
    return await localDataSource.getAllBooks();
  }

  @override
  Future<Book?> getBookById(String id) async {
    return await localDataSource.getBookById(id);
  }

  @override
  Future<List<Book>> getBooksByCategory(String category) async {
    return await localDataSource.getBooksByCategory(category);
  }

  @override
  Future<List<Book>> searchBooks(String query) async {
    return await localDataSource.searchBooks(query);
  }
}
