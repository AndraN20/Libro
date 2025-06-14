import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/core/widgets/progress_bar.dart';
import 'package:book_app/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isStarted;

  const BookCard({super.key, required this.book, this.isStarted = false});

  @override
  Widget build(BuildContext context) {
    final coverData = book.decodedCover;
    final int currentPage = 70;
    final int totalPages = 90;
    final double progress = currentPage / totalPages;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
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
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                    )
                    : Container(
                      width: 60,
                      height: 90,
                      color: Colors.grey[300],
                      child: const Icon(Icons.book),
                    ),
          ),
          const SizedBox(width: 12),
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
                Text(
                  book.author,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                if (isStarted) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Page $currentPage of $totalPages',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  ProgressBar(progress: progress),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: Color(0xFF5F5BD1),
              size: 32,
            ),
            onPressed: () {
              context.push('/book-details', extra: book);
            },
          ),
        ],
      ),
    );
  }
}
