import 'package:book_app/data/models/login_request.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<Map<String, dynamic>> login(LoginRequest request) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'email': request.email, 'password': request.password},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Login failed');
      }
      rethrow;
    }
  }
}
