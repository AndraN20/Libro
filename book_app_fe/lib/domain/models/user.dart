// domain/models/user.dart

class User {
  final int id;
  final String email;
  final String username;

  User({required this.id, required this.email, required this.username});

  /// Creates a User from JWT claims, with fallback for missing username
  factory User.fromJwt(Map<String, dynamic> claims) {
    // Attempt to read username from common JWT claim names
    final rawUsername =
        (claims['username'] as String?) ??
        (claims['preferred_username'] as String?) ??
        '';

    // Fallback: derive username from email local-part
    final emailClaim = claims['email'] as String?;
    late final String username;
    if (rawUsername.isNotEmpty) {
      username = rawUsername;
    } else if (emailClaim != null && emailClaim.contains('@')) {
      username = emailClaim.split('@').first;
    } else {
      username = 'User';
    }

    // Parse ID from 'sub' claim
    final sub = claims['sub'];
    final id = sub is int ? sub : int.tryParse(sub.toString()) ?? 0;

    return User(id: id, email: emailClaim ?? '', username: username);
  }

  /// Optional: from JSON (e.g. /me endpoint)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'username': username};
  }
}
