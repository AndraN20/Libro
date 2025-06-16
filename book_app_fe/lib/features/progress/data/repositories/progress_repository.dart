import 'dart:async';

import 'package:book_app/features/progress/data/services/progress_service.dart';
import 'package:book_app/features/progress/domain/models/progress.dart';

class ProgressRepository {
  final ProgressService service;
  final Map<int, StreamController<Progress?>> _controllers = {};

  ProgressRepository(this.service);

  Stream<Progress?> watchProgressStream(int bookId) async* {
    // Emit initial value fetched from backend
    final initial = await service.getProgress(bookId);
    yield initial;
    // Ensure a controller exists for this bookId
    final controller = _controllers.putIfAbsent(
      bookId,
      () => StreamController<Progress?>.broadcast(),
    );
    // Emit future local updates
    yield* controller.stream;
  }

  Future<Progress?> loadProgress(int bookId) {
    return service.getProgress(bookId);
  }

  Future<void> updateProgress({
    required int bookId,
    required Progress progress,
  }) {
    return service.updateProgress(bookId, progress);
  }

  Future<void> createProgress({
    required int bookId,
    required Progress progress,
  }) {
    return service.createProgress(bookId, progress);
  }
}
