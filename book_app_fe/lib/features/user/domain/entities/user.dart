import 'dart:convert';
import 'dart:typed_data';

class User {
  final int id;
  final String email;
  final String username;
  final Uint8List? profilePictureBase64;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.profilePictureBase64,
  });

  /// Creates a User from JWT claims, with fallback for missing username
  factory User.fromJwt(Map<String, dynamic> claims) {
    final rawUsername = (claims['username'] as String?) ?? '';
    final emailClaim = claims['email'] as String?;

    final username =
        rawUsername.isNotEmpty
            ? rawUsername
            : (emailClaim != null && emailClaim.contains('@'))
            ? emailClaim.split('@').first
            : 'User';

    final sub = claims['sub'];
    final id = sub is int ? sub : int.tryParse(sub.toString()) ?? 0;

    return User(
      id: id,
      email: emailClaim ?? '',
      username: username,
      profilePictureBase64: null,
    );
  }

  /// Creates a User from backend JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      profilePictureBase64:
          json['profile_picture_base64'] != null
              ? base64Decode(json['profile_picture_base64'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profile_picture_base64':
          profilePictureBase64 != null
              ? base64Encode(profilePictureBase64!)
              : null,
    };
  }
}
