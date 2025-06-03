import 'package:book_app/features/books/domain/entities/book.dart';

class BookDto {
  final int id;
  final String title;
  final String author;
  final String? description;
  final String? coverBase64;
  final String? date;
  final String? language;
  final String? genre;

  BookDto({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.coverBase64,
    this.date,
    this.language,
    this.genre,
  });

  factory BookDto.fromJson(Map<String, dynamic> json) => BookDto(
    id: json['id'],
    title: json['title'],
    author: json['author'],
    description: json['description'],
    coverBase64: json['cover_base64'],
    date: json['date'],
    language: json['language'],
    genre: json['genre'],
  );

  Book toDomain() => Book(
    id: id,
    title: title,
    author: author,
    description: description,
    coverBase64: coverBase64,
    date: date != null ? DateTime.tryParse(date!) : null,
    language: language,
    genre: genre,
  );
}
