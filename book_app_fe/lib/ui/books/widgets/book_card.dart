import 'package:flutter/material.dart';
import 'package:book_app/domain/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(book.title), subtitle: Text(book.author));
  }
}
