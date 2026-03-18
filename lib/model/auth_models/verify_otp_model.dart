// lib/model/auth_models/verify_otp_model.dart

class VerifyOtpResponseModel {
  final bool success;
  final String message;
  final String? resetToken;

  const VerifyOtpResponseModel({
    required this.success,
    required this.message,
    this.resetToken,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      resetToken: json['reset_token'],
    );
  }
}