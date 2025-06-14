import 'package:book_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/features/books/domain/models/book.dart';
import 'package:book_app/features/books/presentation/viewmodels/book_provider.dart';
import 'package:book_app/features/books/presentation/widgets/book_card.dart';

class DismissibleBookCard extends ConsumerWidget {
  final Book book;

  const DismissibleBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(book.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: AppColors.primary,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        final confirm = await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text("Delete Book"),
                content: const Text(
                  "Are you sure you want to delete this book?",
                ),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                  TextButton(
                    child: const Text("Delete"),
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                ],
              ),
        );
        return confirm ?? false;
      },
      onDismissed: (_) async {
        await ref.read(bookRepositoryProvider).deleteBook(book.id);
        await ref
            .read(userAddedBookListViewModelProvider.notifier)
            .loadUserBooks();
      },
      child: BookCard(book: book),
    );
  }
}
