import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_app/core/utils/token_utils.dart';

void main() {
  group('isTokenExpired', () {
    test('returns true for null token', () {
      expect(isTokenExpired(null), isTrue);
    });

    test('returns true for a token with invalid format', () {
      // Only one segment — not a valid JWT
      expect(isTokenExpired('notavalidtoken'), isTrue);
    });
  });

  group('parseJwt', () {
    String makeToken(Map<String, dynamic> payload) {
      const header = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';
      final payloadJson = json.encode(payload);
      final payloadEncoded = base64Url
          .encode(utf8.encode(payloadJson))
          .replaceAll('=', '');
      return '$header.$payloadEncoded.fakesignature';
    }

    test('parses sub field from payload', () {
      final token = makeToken({'sub': '42', 'exp': 9999999999});
      final claims = parseJwt(token);
      expect(claims['sub'], '42');
    });

    test('parses multiple fields from payload', () {
      final token = makeToken({'sub': '7', 'exp': 9999999999, 'role': 'user'});
      final claims = parseJwt(token);
      expect(claims['sub'], '7');
      expect(claims['role'], 'user');
    });

    test('throws Exception when JWT has fewer than 3 parts', () {
      expect(() => parseJwt('onlyone'), throwsException);
      expect(() => parseJwt('only.two'), throwsException);
    });

    test('throws Exception when JWT has more than 3 parts', () {
      expect(() => parseJwt('a.b.c.d'), throwsException);
    });
  });
}
