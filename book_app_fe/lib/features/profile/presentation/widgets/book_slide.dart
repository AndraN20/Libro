import 'package:flutter/material.dart';

class BookSlide extends StatelessWidget {
  const BookSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final books = [
      {'title': 'Moby Dick', 'author': 'Herman Melville'},
      {'title': 'Anna Karenina', 'author': 'Leo Tolstoy'},
      {'title': '1984', 'author': 'George Orwell'},
      {'title': 'Hamlet', 'author': 'William Shakespeare'},
      {'title': 'The Hobbit', 'author': 'J.R.R. Tolkien'},
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/placeholder_book.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  book['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  book['author']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
