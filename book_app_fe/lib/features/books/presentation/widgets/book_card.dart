import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/core/widgets/progress_bar.dart';
import 'package:book_app/features/books/domain/models/book.dart';
import 'package:book_app/features/progress/presentation/viewmodels/reader_progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookCard extends ConsumerWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressProvider(book.id));

    return progressAsync.when(
      data: (progress) {
        final bool isStarted =
            progress != null &&
            progress.percentage != null &&
            progress.percentage! > 0.0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:
                    book.decodedCover != null
                        ? Image.memory(
                          book.decodedCover!,
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
                    if (isStarted && progress.percentage != null) ...[
                      const SizedBox(height: 8),
                      ProgressBar(percentage: progress.percentage!),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.primary,
                  size: 40,
                ),
                onPressed: () {
                  context.push('/book-details', extra: book);
                  ref.invalidate(progressProvider(book.id));
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const SizedBox.shrink(),
    );
  }
}
