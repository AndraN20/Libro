import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/features/summary/presentation/viewmodels/summary_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryScreen extends ConsumerWidget {
  final String bookText;
  const SummaryScreen({super.key, required this.bookText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(summaryNotifierProvider(bookText));
    final notifier = ref.read(summaryNotifierProvider(bookText).notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (summaryAsync is AsyncLoading == false && summaryAsync.value == "") {
        if (bookText.isEmpty) {
          notifier.setError(
            "No book text available. Please wait for the book to fully load and try again.",
          );
        } else {
          print("Starting summarization with text length: ${bookText.length}");
          notifier.summarizeBook();
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.lightPurple.withOpacity(0.18),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.bolt_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              "Quick Recap",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.darkPurple,
              ),
            ),
          ],
        ),
        leading: const BackButton(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: summaryAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (e, _) => Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    "Eroare la rezumare: $e",
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
            data:
                (summary) => Card(
                  elevation: 7,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 22,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badge/label
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.11),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            "Summary generated",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        // Textul rezumatului
                        SingleChildScrollView(
                          child: SelectableText(
                            summary,
                            style: const TextStyle(
                              fontSize: 19,
                              height: 1.6,
                              color: AppColors.darkPurple,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Buton de copiere
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            tooltip: "Copy summary",
                            icon: const Icon(
                              Icons.copy_rounded,
                              color: AppColors.primary,
                              size: 26,
                            ),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: summary),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Summary copied!"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
