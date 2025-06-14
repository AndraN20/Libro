import 'package:book_app/features/books/data/repositories/book_repository.dart';
import 'package:book_app/features/books/domain/models/book.dart';
import 'package:book_app/features/auth/presentation/viewmodels/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAddedBookListViewModel extends StateNotifier<AsyncValue<List<Book>>> {
  final BookRepository _repo;
  final Ref _ref;

  UserAddedBookListViewModel(this._repo, this._ref)
    : super(const AsyncValue.loading());

  Future<void> loadUserBooks() async {
    try {
      final user = _ref.read(currentUserProvider).value;
      if (user == null) {
        state = const AsyncValue.data([]);
        return;
      }

      final books = await _repo.getUserAddedBooksByUserId(user.id);
      state = AsyncValue.data(books);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
