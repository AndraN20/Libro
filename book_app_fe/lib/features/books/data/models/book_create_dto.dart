class BookCreateModel {
  final String title;
  final String author;
  final String? coverBase64;
  final String? language;

  BookCreateModel({
    required this.title,
    required this.author,
    this.coverBase64,
    this.language,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'cover_data': coverBase64,
    'language': language,
  };
}
