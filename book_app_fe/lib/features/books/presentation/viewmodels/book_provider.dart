import 'package:book_app/features/books/data/repositories/book_repository.dart';
import 'package:book_app/features/books/data/services/book_download_service.dart';
import 'package:book_app/features/books/data/services/book_service.dart';
import 'package:book_app/features/books/data/services/book_upload_service.dart';
import 'package:book_app/features/books/domain/models/book.dart';
import 'package:book_app/features/books/presentation/viewmodels/user_added_book_list_view.dart';
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

final booksProvider = FutureProvider<List<Book>>((ref) async {
  return ref.watch(bookRepositoryProvider).getBooks();
});

final userAddedBooksProvider = FutureProvider.family<List<Book>, int>((
  ref,
  userId,
) async {
  return ref.watch(bookRepositoryProvider).getUserAddedBooksByUserId(userId);
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

final userAddedBookListViewModelProvider =
    StateNotifierProvider<UserAddedBookListViewModel, AsyncValue<List<Book>>>((
      ref,
    ) {
      final repo = ref.watch(bookRepositoryProvider);
      final viewModel = UserAddedBookListViewModel(repo, ref);
      viewModel.loadUserBooks();
      return viewModel;
    });

final startedBooksProvider = FutureProvider<List<Book>>((ref) async {
  return ref.watch(bookRepositoryProvider).getBooksInProgress();
});

final completedBooksProvider = FutureProvider<List<Book>>((ref) async {
  return ref.watch(bookRepositoryProvider).getCompletedBooks();
});
