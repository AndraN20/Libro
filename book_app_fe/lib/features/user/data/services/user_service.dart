import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class UserService {
  final Dio dio;

  UserService(this.dio);

  Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String username,
    Uint8List? profilePicture,
  }) async {
    final response = await dio.patch(
      '/users/$userId',
      data: {
        'username': username,
        'profile_picture_base64':
            profilePicture != null ? base64Encode(profilePicture) : null,
      },
    );
    print(" RESPONSE ${response.data}");
    return response.data;
  }

  Future<void> deleteUser(int userId) async {
    await dio.delete('/users/$userId');
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    final response = await dio.get('/users/$userId');
    return response.data;
  }
}
