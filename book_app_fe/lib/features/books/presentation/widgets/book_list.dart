import 'package:book_app/features/books/domain/models/book.dart';
import 'package:book_app/features/books/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';

class BookList extends StatelessWidget {
  final List<Book> books;

  const BookList({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      itemBuilder: (_, i) => BookCard(book: books[i]),
    );
  }
}
