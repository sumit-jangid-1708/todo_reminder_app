// lib/view_models/service/auth_service.dart

import 'dart:io';

import '../../data/network/network_api_service.dart';
import '../../res/app_url/app_url.dart';

class AuthService {
  final NetworkApiService _apiService = NetworkApiService();

  /// Sign In
  Future<T> signIn<T>(Map<String, dynamic> data) async {
    return await _apiService.postApi<T>(
      AppUrl.signIn,
      data,
    );
  }

  /// Sign Up
  Future<T> signUp<T>(Map<String, dynamic> data) async {
    return await _apiService.postApi<T>(
      AppUrl.signUp,
      data,
    );
  }

  /// Forgot Password
  Future<T> forgotPassword<T>(Map<String, dynamic> data) async {
    return await _apiService.postApi<T>(
      AppUrl.forgetPass,
      data,
    );
  }

  /// Verify OTP
  Future<T> verifyOtp<T>(Map<String, dynamic> data) async {
    return await _apiService.postApi<T>(
      AppUrl.verifyOtp,
      data,
    );
  }

  /// Reset Password
  Future<T> resetPassword<T>(Map<String, dynamic> data) async {
    return await _apiService.postApi<T>(
      AppUrl.resetPass,
      data,
    );
  }

  /// Update Profile (with multipart support for avatar)
  Future<T> updateProfile<T>({
    required String name,
    required String email,
    String? password,
    File? avatarFile,
  }) async {
    return await _apiService.multipartApi<T>(
      AppUrl.updateProfile,
      {
        'name': name,
        'email': email,
        if (password != null && password.isNotEmpty) 'password': password,
      },
      file: avatarFile,
      fileField: 'avatar',
    );
  }

  /// Delete Account
  Future<T> deleteAccount<T>(String password) async {
    return await _apiService.deleteApi<T>(
      AppUrl.deleteAccount,
      body: {'password': password}, // ✅ Named parameter 'body' use karo
    );
  }


  /// Logout
  Future<T> logout<T>() async {
    return await _apiService.postApi<T>(
      AppUrl.logout,
      {},
    );
  }
}