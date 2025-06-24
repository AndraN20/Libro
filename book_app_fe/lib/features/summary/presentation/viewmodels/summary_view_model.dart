import 'package:book_app/features/summary/presentation/viewmodels/summary_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryNotifier extends FamilyAsyncNotifier<String, String> {
  late final String bookText;

  @override
  Future<String> build(String arg) async {
    bookText = arg;
    return "";
  }

  Future<void> summarizeBook() async {
    state = const AsyncLoading();
    try {
      if (bookText.isEmpty) {
        state = AsyncError(
          "No text provided for summarization",
          StackTrace.current,
        );
        return;
      }
      print("Summarizing text of length: ${bookText.length}");
      final repo = ref.read(summaryRepositoryProvider);
      final summary = await repo.getSummary(bookText);
      state = AsyncData(summary);
    } catch (e, st) {
      print("Error during summarization: $e");
      state = AsyncError(e, st);
    }
  }

  void setError(String errorMessage) {
    state = AsyncError(errorMessage, StackTrace.current);
  }
}

final summaryNotifierProvider =
    AsyncNotifierProvider.family<SummaryNotifier, String, String>(
      SummaryNotifier.new,
    );
