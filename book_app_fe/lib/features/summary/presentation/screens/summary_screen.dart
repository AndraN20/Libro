import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/features/summary/presentation/viewmodels/summary_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryScreen extends ConsumerWidget {
  final String bookText;
  const SummaryScreen({super.key, required this.bookText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(summaryNotifierProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (summaryAsync is AsyncLoading == false && summaryAsync.value == "") {
        if (bookText.isEmpty) {
          // Show error if book text is empty
          ref
              .read(summaryNotifierProvider.notifier)
              .setError(
                "No book text available. Please wait for the book to fully load and try again.",
              );
        } else {
          print("Starting summarization with text length: ${bookText.length}");
          ref.read(summaryNotifierProvider.notifier).summarizeBook(bookText);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quick Recap",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppColors.darkPurple,
          ),
        ),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: summaryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text("Eroare la rezumare: $e"),
          data:
              (summary) => SingleChildScrollView(
                child: Text(summary, style: const TextStyle(fontSize: 20)),
              ),
        ),
      ),
    );
  }
}
