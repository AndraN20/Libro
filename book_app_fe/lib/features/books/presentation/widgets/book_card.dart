import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/core/widgets/progress_bar.dart';
import 'package:book_app/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final coverData = book.decodedCover;

    final int currentPage = 45;
    final int totalPages = 60;
    final double progress = currentPage / totalPages;

    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                coverData != null
                    ? Image.memory(
                      coverData,
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                    : Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.book),
                    ),
          ),
          const SizedBox(width: 16),

          // Text + Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Page $currentPage of $totalPages',
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
                const SizedBox(height: 8),

                ProgressBar(progress: progress),
                const SizedBox(height: 8),

                // Quick recap + play
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      onPressed: () {},
                      child: const Text('Quick recap'),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFF5F5BD1),
                        size: 32,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
