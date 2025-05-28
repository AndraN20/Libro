import 'package:book_app/config/secure_storage.dart';
import 'package:book_app/domain/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/data/services/auth_service.dart';
import 'package:book_app/data/repositories/auth_repository.dart';
import 'package:book_app/ui/auth/view_model/auth_view_model.dart';
import 'package:book_app/providers/dio_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthService(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthRepository(service);
});

final authRefreshNotifierProvider = Provider((ref) {
  return AuthRefreshNotifier();
});

final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthViewModel(repo, ref);
});

class AuthRefreshNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

final currentUserProvider = FutureProvider<User?>((ref) async {
  final token = await SecureStorage.readToken();
  if (token == null) return null;
  final claims = parseJwt(token);
  return User.fromJwt(claims);
});

final currentUserIdProvider = Provider<int>((ref) {
  final user = ref
      .watch(currentUserProvider)
      .maybeWhen(data: (u) => u, orElse: () => null);
  if (user == null) throw StateError('No user logged in');
  return user.id;
});

// Parse JWT token and return claims as Map
Map<String, dynamic> parseJwt(String token) {
  return JwtDecoder.decode(token);
}
