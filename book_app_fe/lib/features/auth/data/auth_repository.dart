import 'package:book_app/core/storage/secure_storage.dart';
import 'package:book_app/features/auth/data/auth_service.dart';
import 'package:book_app/features/auth/data/models/login_request.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Future<String?> login(String email, String password) async {
    final result = await _service.login(
      LoginRequest(email: email, password: password),
    );
    final token = result['access_token'];
    debugPrint('Received token: $token');

    if (token != null) {
      _service.dio.options.headers['Authorization'] = 'Bearer $token';
      await SecureStorage.writeToken(token);
    }

    return token;
  }

  Future<void> signup(String email, String username, String password) async {
    await _service.signup(email, username, password);
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    _service.dio.options.headers.remove('Authorization');
  }
}
