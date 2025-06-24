import 'package:book_app/features/books/domain/models/book.dart';
import 'package:book_app/features/books/presentation/widgets/book_card.dart';
import 'package:book_app/features/books/presentation/widgets/dismissible_book_card.dart';
import 'package:flutter/material.dart';

class BookList extends StatelessWidget {
  final List<Book> books;
  final bool dismissible; // adaugă acest parametru

  const BookList({super.key, required this.books, this.dismissible = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      itemBuilder:
          (_, i) =>
              dismissible
                  ? DismissibleBookCard(book: books[i])
                  : BookCard(book: books[i]),
    );
  }
}
