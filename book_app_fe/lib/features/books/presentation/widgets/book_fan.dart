import 'package:flutter/material.dart';
import 'package:book_app/features/books/domain/models/book.dart';

class BookFan extends StatelessWidget {
  final List<Book> books;

  const BookFan({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    final covers = books.take(3).toList();
    final order = [0, 2, 1];

    const double imageWidth = 130;
    const double imageHeight = 200;

    return SizedBox(
      height: imageHeight + 20,
      child: Stack(
        alignment: Alignment.center,
        children:
            order.map((i) {
              final book = covers[i];
              final coverData = book.decodedCover;
              final angle = (i - 1) * 0.26;
              final offsetX = (i - 1) * 40.0;

              return Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(offsetX, 0),
                  child: Transform.rotate(
                    angle: angle,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child:
                            coverData != null
                                ? Image.memory(
                                  coverData,
                                  width: imageWidth,
                                  height: imageHeight,
                                  fit: BoxFit.cover,
                                )
                                : const SizedBox(
                                  width: imageWidth,
                                  height: imageHeight,
                                  child: Icon(Icons.book, size: 48),
                                ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
