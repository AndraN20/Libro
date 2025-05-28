import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/data/services/book_service.dart';
import 'package:book_app/data/repositories/book_repository.dart';
import 'package:book_app/domain/models/book.dart';
import 'package:book_app/providers/dio_provider.dart';

final bookServiceProvider = Provider<BookService>((ref) {
  final dio = ref.watch(dioProvider);
  return BookService(dio);
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final service = ref.watch(bookServiceProvider);
  return BookRepository(service);
});

final libraryBooksProvider = FutureProvider<List<Book>>((ref) async {
  return ref.watch(bookRepositoryProvider).getBooks();
});

final userBooksProvider = FutureProvider.family<List<Book>, int>((
  ref,
  userId,
) async {
  return ref.watch(bookRepositoryProvider).getUserBooks(userId);
});
