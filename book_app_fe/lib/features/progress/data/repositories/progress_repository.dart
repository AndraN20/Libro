import 'package:book_app/features/progress/data/services/progress_service.dart';
import 'package:book_app/features/progress/domain/models/progress.dart';

class ProgressRepository {
  final ProgressService service;

  ProgressRepository(this.service);

  Future<Progress?> loadProgress(int bookId) {
    return service.getProgress(bookId);
  }

  Future<void> updateProgress({
    required int bookId,
    required Progress progress,
  }) {
    return service.saveProgress(bookId, progress);
  }
}
