import 'package:book_app/features/books/data/models/book_dto.dart';
import 'package:dio/dio.dart';

class BookService {
  final Dio _dio;
  BookService(this._dio);

  Future<List<BookDto>> fetchBooks() async {
    final response = await _dio.get('/books');
    print('Response data: ${response.data}');
    return (response.data as List).map((e) => BookDto.fromJson(e)).toList();
  }

  Future<BookDto> getBook(int bookId) async {
    final response = await _dio.get('/books/$bookId');
    return BookDto.fromJson(response.data);
  }

  Future<List<BookDto>> fetchUserAddedBooksByUserId(int userId) async {
    final response = await _dio.get('/books/users/$userId/added');
    return (response.data as List).map((e) => BookDto.fromJson(e)).toList();
  }

  Future<List<BookDto>> searchBooks(String query) async {
    final response = await _dio.get(
      '/books/search',
      queryParameters: {'query': query},
    );
    return (response.data as List)
        .map((json) => BookDto.fromJson(json))
        .toList();
  }

  Future<List<BookDto>> getBooksByGenre(String genre) async {
    final response = await _dio.get('/books/genre/$genre');
    return (response.data as List)
        .map((json) => BookDto.fromJson(json))
        .toList();
  }

  Future<List<BookDto>> getStartedBooks(int userId) async {
    final response = await _dio.get('/books/started/$userId');
    return (response.data as List)
        .map((json) => BookDto.fromJson(json))
        .toList();
  }

  Future<void> deleteBook(int bookId) async {
    await _dio.delete('/books/$bookId');
  }

  Future<List<BookDto>> getBooksInProgress() async {
    final response = await _dio.get('/books/in-progress');
    return (response.data as List)
        .map((json) => BookDto.fromJson(json))
        .toList();
  }

  Future<List<BookDto>> getCompletedBooks() async {
    final response = await _dio.get('/books/completed');
    return (response.data as List)
        .map((json) => BookDto.fromJson(json))
        .toList();
  }
}
