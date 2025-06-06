import 'dart:convert';
import 'package:book_app/core/storage/secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

bool isTokenExpired(String? token) {
  if (token == null) return true;

  try {
    return JwtDecoder.isExpired(token);
  } catch (e) {
    return true; // If token is invalid, consider it expired
  }
}

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) throw Exception('Invalid JWT');
  final payload = base64Url.normalize(parts[1]);
  final decoded = utf8.decode(base64Url.decode(payload));
  return json.decode(decoded) as Map<String, dynamic>;
}

Future<int?> getUserIdFromToken() async {
  final token = await SecureStorage.readToken();
  if (token == null || isTokenExpired(token)) return null;

  try {
    final claims = parseJwt(token);
    final sub = claims['sub'];
    return sub is int ? sub : int.tryParse(sub.toString());
  } catch (_) {
    return null;
  }
}
