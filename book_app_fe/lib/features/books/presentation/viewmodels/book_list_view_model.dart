import 'package:book_app/features/books/data/repositories/book_repository.dart';
import 'package:book_app/features/books/domain/models/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookListViewModel extends StateNotifier<AsyncValue<List<Book>>> {
  final BookRepository _repo;

  BookListViewModel(this._repo) : super(const AsyncValue.loading());

  Future<void> loadBooks() async {
    try {
      final books = await _repo.getBooks();
      state = AsyncValue.data(books);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
