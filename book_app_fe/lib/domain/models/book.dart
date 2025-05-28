import 'dart:convert';
import 'dart:typed_data';

class Book {
  final int id;
  final String title;
  final String author;
  final String? description;
  final String? coverBase64;
  final DateTime? date;
  final String? language;
  final String? genre;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.coverBase64,
    this.date,
    this.language,
    this.genre,
  });

  Uint8List? get decodedCover {
    if (coverBase64 == null) return null;
    return base64Decode(coverBase64!);
  }
}
