// lib/model/auth_models/profile_update_model.dart

class ProfileUpdateResponse {
  final bool success;
  final String message;
  final ProfileUpdateData? data;

  ProfileUpdateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileUpdateData.fromJson(json['data']) : null,
    );
  }
}

class ProfileUpdateData {
  final ProfileUser user;
  final String avatarUrl;

  ProfileUpdateData({
    required this.user,
    required this.avatarUrl,
  });

  factory ProfileUpdateData.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateData(
      user: ProfileUser.fromJson(json['user']),
      avatarUrl: json['avatar_url'] ?? '',
    );
  }
}

class ProfileUser {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}