import 'package:book_app/features/books/data/services/book_service.dart';
import 'package:book_app/features/books/domain/models/book.dart';

class BookRepository {
  final BookService service;

  BookRepository(this.service);

  Future<List<Book>> getBooks() async {
    final dtos = await service.fetchBooks();
    return dtos.map((e) => e.toDomain()).toList();
  }

  Future<Book> getBook(int bookId) async {
    final dto = await service.getBook(bookId);
    return dto.toDomain();
  }

  Future<List<Book>> getUserAddedBooksByUserId(int userId) async {
    final dtos = await service.fetchUserAddedBooksByUserId(userId);
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

  Future<void> deleteBook(int bookId) async {
    await service.deleteBook(bookId);
  }

  Future<List<Book>> getBooksInProgress() async {
    final dtos = await service.getBooksInProgress();
    return dtos.map((e) => e.toDomain()).toList();
  }

  Future<List<Book>> getCompletedBooks() async {
    final dtos = await service.getCompletedBooks();
    return dtos.map((e) => e.toDomain()).toList();
  }
}
