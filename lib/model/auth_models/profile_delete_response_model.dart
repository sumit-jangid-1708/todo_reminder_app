// lib/model/auth_models/profile_delete_model.dart

class ProfileDeleteResponse {
  final bool success;
  final String message;

  ProfileDeleteResponse({
    required this.success,
    required this.message,
  });

  factory ProfileDeleteResponse.fromJson(Map<String, dynamic> json) {
    return ProfileDeleteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}