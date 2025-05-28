import 'package:book_app/config/secure_storage.dart';
import 'package:book_app/data/models/login_request.dart';
import 'package:book_app/data/services/auth_service.dart';
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
}
