import 'auth_user_model.dart';

class RegisterResponseModel {
  final bool success;
  final String message;
  final RegisterData? data;
  final Map<String, List<String>>? errors;

  const RegisterResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? RegisterData.fromJson(json['data'])
          : null,
      errors: json['errors'] != null
          ? Map<String, List<String>>.from(
        json['errors'].map(
              (key, value) =>
              MapEntry(key, List<String>.from(value)),
        ),
      )
          : null,
    );
  }
}


class RegisterData {
  final AuthUser user;
  final String token;

  const RegisterData({
    required this.user,
    required this.token,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      user: AuthUser.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}

