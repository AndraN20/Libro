import 'package:book_app/features/summary/data/repositories/summary_repository.dart';
import 'package:book_app/features/summary/data/services/summary_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final summaryServiceProvider = Provider<SummaryService>(
  (ref) => SummaryService(),
);
final summaryRepositoryProvider = Provider<SummaryRepository>(
  (ref) => SummaryRepository(ref.read(summaryServiceProvider)),
);
