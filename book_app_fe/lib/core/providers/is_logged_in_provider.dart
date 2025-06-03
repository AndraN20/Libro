import 'package:book_app/core/storage/secure_storage.dart';
import 'package:book_app/core/utils/token_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsLoggedInNotifier extends StateNotifier<AsyncValue<bool>> {
  IsLoggedInNotifier() : super(const AsyncValue.loading()) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    state = const AsyncValue.loading();
    try {
      final token = await SecureStorage.readToken();
      final isValid = token != null && !isTokenExpired(token);
      state = AsyncValue.data(isValid);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    state = const AsyncValue.data(false);
  }
}

final isLoggedInProvider =
    StateNotifierProvider<IsLoggedInNotifier, AsyncValue<bool>>((ref) {
      return IsLoggedInNotifier();
    });
