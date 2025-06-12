import 'package:book_app/features/books/data/book_repository.dart';
import 'package:book_app/features/books/data/services/book_download_service.dart';
import 'package:book_app/features/books/data/services/book_service.dart';
import 'package:book_app/features/books/data/services/book_upload_service.dart';
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

final searchBooksProvider = FutureProvider.family<List<Book>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];
  final repo = ref.watch(bookRepositoryProvider);
  return await repo.searchBooks(query);
});

final genreBooksProvider = FutureProvider.family<List<Book>, String>((
  ref,
  genre,
) async {
  final repo = ref.watch(bookRepositoryProvider);
  if (genre.toLowerCase() == 'all') {
    return await repo.getBooks();
  }
  return await repo.getBooksByGenre(genre);
});

final bookDownloadServiceProvider = Provider<BookDownloadService>((ref) {
  final dio = ref.watch(dioProvider);
  return BookDownloadService(dio);
});

final bookUploadServiceProvider = Provider<BookUploadService>(
  (ref) => BookUploadService(
    dio: ref.watch(dioProvider),
    bookRepository: ref.watch(bookRepositoryProvider),
  ),
);
