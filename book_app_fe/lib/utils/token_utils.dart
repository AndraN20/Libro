import 'dart:convert';
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
