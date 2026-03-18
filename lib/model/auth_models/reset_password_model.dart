// lib/model/auth_models/reset_password_model.dart

class ResetPasswordResponseModel {
  final bool success;
  final String message;

  const ResetPasswordResponseModel({
    required this.success,
    required this.message,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}