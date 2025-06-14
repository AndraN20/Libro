import 'package:book_app/features/books/domain/models/book.dart';

class BookCoverDto {
  final int id;
  final String title;
  final String author;
  final String? coverBase64;

  BookCoverDto({
    required this.id,
    required this.title,
    required this.author,
    this.coverBase64,
  });

  factory BookCoverDto.fromJson(Map<String, dynamic> json) => BookCoverDto(
    id: json['id'],
    title: json['title'],
    author: json['author'],
    coverBase64: json['cover_base64'],
  );

  Book toDomain() => Book(
    id: id,
    title: title,
    author: author,
    coverBase64: coverBase64,
    bookUrl: '',
  );
}
