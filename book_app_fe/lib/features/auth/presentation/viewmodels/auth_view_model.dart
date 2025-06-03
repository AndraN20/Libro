import 'package:book_app/core/storage/secure_storage.dart';
import 'package:book_app/features/auth/data/auth_repository.dart';
import 'package:book_app/core/providers/is_logged_in_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewModel extends StateNotifier<bool> {
  final AuthRepository _repo;
  final Ref ref;

  AuthViewModel(this._repo, this.ref) : super(false);

  Future<bool> login(String email, String password) async {
    try {
      state = true; // Set loading state
      final token = await _repo.login(email, password);
      if (token != null) {
        await SecureStorage.writeToken(token);
        await ref.read(isLoggedInProvider.notifier).checkLoginStatus();
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    } finally {
      state = false; // Reset loading state
    }
  }

  Future<bool> signup(String email, String username, String password) async {
    try {
      state = true; // loading
      await _repo.signup(email, username, password);
      return true;
    } catch (e) {
      return false;
    } finally {
      state = false; // done loading
    }
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    await ref.read(isLoggedInProvider.notifier).checkLoginStatus();
  }
}
