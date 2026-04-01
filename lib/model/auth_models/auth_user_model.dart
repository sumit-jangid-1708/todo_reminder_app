// lib/model/auth_models/auth_user_model.dart

class AuthUser {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl; // ✅ handles both "avatar" and "avatar_url" from API

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    // ✅ Regular login → "avatar" (relative path e.g. "avatars/xxx.jpg")
    // ✅ Google login  → "avatar_url" (full URL)
    // ✅ Register      → no avatar field
    final raw = json['avatar_url'] ?? json['avatar'];

    String? avatarUrl;
    if (raw != null && raw.toString().isNotEmpty) {
      final str = raw.toString();
      if (str.startsWith('http')) {
        avatarUrl = str; // already full URL (Google login)
      } else {
        avatarUrl = 'https://todotransaction.testwebs.in/storage/$str'; // relative path
      }
    }

    return AuthUser(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatarUrl: avatarUrl,
    );
  }
}