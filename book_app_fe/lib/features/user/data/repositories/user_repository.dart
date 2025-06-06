import 'dart:typed_data';

import 'package:book_app/core/utils/token_utils.dart';
import 'package:book_app/features/user/data/services/user_service.dart';
import 'package:book_app/features/user/domain/entities/user.dart';

class UserRepository {
  final UserService service;

  UserRepository(this.service);

  Future<User> editUser({
    required String username,
    Uint8List? profilePicture,
  }) async {
    final userId = await getUserIdFromToken();
    if (userId == null) {
      throw Exception('User ID cannot be null');
    }

    final data = await service.updateUser(
      userId: userId,
      username: username,
      profilePicture: profilePicture,
    );
    return User.fromJson(data);
  }

  Future<void> deleteUser() async {
    final userId = await getUserIdFromToken();
    if (userId == null) {
      throw Exception('User ID cannot be null');
    }
    await service.deleteUser(userId);
  }

  Future<User> fetchUser(int userId) async {
    final data = await service.getUserById(userId);
    return User.fromJson(data);
  }
}
