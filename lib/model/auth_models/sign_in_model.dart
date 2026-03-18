// lib/model/auth_models/login_model.dart

import 'auth_user_model.dart';

class LoginResponseModel {
  final bool success;
  final String message;
  final LoginData? data;

  const LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

class LoginData {
  final AuthUser user;
  final String token;

  const LoginData({
    required this.user,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: AuthUser.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}
//
// class LoginUser {
//   final int id;
//   final String name;
//   final String email;
//   final String createdAt;
//   final String updatedAt;
//
//   const LoginUser({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory LoginUser.fromJson(Map<String, dynamic> json) {
//     return LoginUser(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       createdAt: json['created_at'] ?? '',
//       updatedAt: json['updated_at'] ?? '',
//     );
//   }
// }
