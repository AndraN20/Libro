import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/features/user/domain/entities/user.dart';
import 'package:book_app/features/user/data/repositories/user_repository.dart';

class UserViewModel extends StateNotifier<AsyncValue<User?>> {
  final UserRepository _repository;

  UserViewModel(this._repository) : super(const AsyncData(null));

  Future<void> updateUser({
    required String username,
    Uint8List? profilePicture,
  }) async {
    state = const AsyncLoading();
    try {
      final updatedUser = await _repository.editUser(
        username: username,
        profilePicture: profilePicture,
      );
      state = AsyncData(updatedUser);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteUser() async {
    try {
      await _repository.deleteUser();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
