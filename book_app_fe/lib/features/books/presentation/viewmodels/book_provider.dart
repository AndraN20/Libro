import 'package:book_app/features/books/data/book_repository.dart';
import 'package:book_app/features/books/data/book_service.dart';
import 'package:book_app/features/books/domain/entities/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/core/api/dio_provider.dart';

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
