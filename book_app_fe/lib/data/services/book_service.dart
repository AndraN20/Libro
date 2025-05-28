import 'package:book_app/data/models/books/book_dto.dart';
import 'package:dio/dio.dart';

class BookService {
  final Dio _dio;
  BookService(this._dio);

  Future<List<BookDto>> fetchBooks() async {
    final response = await _dio.get('/books');
    print('Response data: ${response.data}');
    return (response.data as List).map((e) => BookDto.fromJson(e)).toList();
  }

  Future<List<BookDto>> fetchUserBooks(int userId) async {
    final response = await _dio.get('/books/users/$userId');
    return (response.data as List).map((e) => BookDto.fromJson(e)).toList();
  }
}
