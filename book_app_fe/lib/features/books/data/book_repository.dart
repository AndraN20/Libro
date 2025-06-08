import 'package:book_app/features/books/data/services/book_service.dart';
import 'package:book_app/features/books/domain/entities/book.dart';

class BookRepository {
  final BookService service;

  BookRepository(this.service);

  Future<List<Book>> getBooks() async {
    final dtos = await service.fetchBooks();
    return dtos.map((e) => e.toDomain()).toList();
  }

  Future<List<Book>> getUserBooks(int userId) async {
    final dtos = await service.fetchUserBooks(userId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  Future<List<Book>> searchBooks(String query) async {
    final dtos = await service.searchBooks(query);
    return dtos.map((e) => e.toDomain()).toList();
  }

  Future<List<Book>> getBooksByGenre(String genre) async {
    final dtos = await service.getBooksByGenre(genre);
    return dtos.map((e) => e.toDomain()).toList();
  }
}
