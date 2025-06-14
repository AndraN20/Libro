import 'package:book_app/core/api/dio_provider.dart';
import 'package:book_app/features/progress/data/repositories/progress_repository.dart';
import 'package:book_app/features/progress/data/services/progress_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  final dio = ref.watch(dioProvider);
  return ProgressService(dio);
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final service = ref.watch(progressServiceProvider);
  return ProgressRepository(service);
});
