import 'package:book_app/data/services/book_service.dart';
import 'package:book_app/domain/models/book.dart';

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
}
