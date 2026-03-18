// lib/view_models/service/auth_service.dart

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

  /// Logout
  Future<T> logout<T>() async {
    return await _apiService.postApi<T>(
      AppUrl.logout,
      {},
    );
  }
}