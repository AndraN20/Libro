import 'package:book_app/core/api/dio_provider.dart';
import 'package:book_app/core/utils/token_utils.dart';
import 'package:book_app/features/user/data/repositories/user_repository.dart';
import 'package:book_app/features/user/data/services/user_service.dart';
import 'package:book_app/features/user/domain/entities/user.dart';
import 'package:book_app/features/user/presentation/viewmodels/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final dio = ref.watch(dioProvider);
  return UserService(dio);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final service = ref.watch(userServiceProvider);
  return UserRepository(service);
});

final userViewModelProvider =
    StateNotifierProvider<UserViewModel, AsyncValue<User?>>((ref) {
      final repo = ref.watch(userRepositoryProvider);
      return UserViewModel(repo);
    });

final fetchedUserProvider = FutureProvider<User?>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  final userId = await getUserIdFromToken();
  if (userId == null) return null;

  return await repo.fetchUser(userId);
});
