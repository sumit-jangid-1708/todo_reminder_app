// lib/model/auth_models/forgot_pass_model.dart

class ForgotPassResponseModel {
  final bool success;
  final String message;

  const ForgotPassResponseModel({
    required this.success,
    required this.message,
  });

  factory ForgotPassResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPassResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}


// class forgotPassResponseModel {
//   final bool success;
//   final String message;
//
//   forgotPassResponseModel({
//     required this.success,
//     required this.message,
//   });
//
//   factory forgotPassResponseModel.fromJson(Map<String, dynamic> json) {
//     return forgotPassResponseModel(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "success": success,
//       "message": message,
//     };
//   }
// }