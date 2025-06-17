import 'package:book_app/features/summary/presentation/viewmodels/summary_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async => "";

  Future<void> summarizeBook(String text) async {
    state = const AsyncLoading();
    try {
      if (text.isEmpty) {
        state = AsyncError(
          "No text provided for summarization",
          StackTrace.current,
        );
        return;
      }

      print("Summarizing text of length: ${text.length}");
      final repo = ref.read(summaryRepositoryProvider);
      final summary = await repo.getSummary(text);
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

final summaryNotifierProvider = AsyncNotifierProvider<SummaryNotifier, String>(
  () => SummaryNotifier(),
);
