// lib/view_models/controller/auth_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_reminder/model/auth_models/auth_user_model.dart';

import '../../data/storage/token_storage.dart';
import '../../model/auth_models/forgot_password_model.dart';
import '../../model/auth_models/reset_password_model.dart';
import '../../model/auth_models/sign_in_model.dart';
import '../../model/auth_models/sign_up_model.dart';
import '../../model/auth_models/verify_otp_model.dart';
import '../../notification_service.dart';
import '../../res/components/app_alerts.dart';
import '../../res/routes/routes_names.dart';
import '../../utils/utils.dart';
import '../../view_models/service/auth_service.dart';
import 'base_controller.dart';

class AuthController extends GetxController with BaseController {
  final AuthService _authService = AuthService();
  final TokenStorage _tokenStorage = TokenStorage();
  final GetStorage _storage = GetStorage();

  // Form Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // Reactive States
  final RxBool isLoading = false.obs;
  final RxBool agreeToTerms = false.obs;
  final RxBool isEmailValid = false.obs;
  final RxString passwordText = ''.obs;
  // OTP Timer
  final RxInt otpTimer = 180.obs; // 3 minutes
  Timer? _timer;

  // Reset Token (from verify OTP)
  String? resetToken;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateEmail);

    passwordController.addListener(() {
      passwordText.value = passwordController.text;
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  /// Validate email in real-time
  void _validateEmail() {
    final email = emailController.text.trim();
    isEmailValid.value = Utils.isEmailValid(email) && email.isNotEmpty;
  }


  bool get isPasswordStrong {
    final password = passwordText.value;

    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }
  // ==================== SIGN UP ====================

  Future<void> signUp() async {
    if (!_validateSignUpInputs()) return;

    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      final response = await _authService.signUp<Map<String, dynamic>>(data);
      final model = RegisterResponseModel.fromJson(response);

      if (model.success) {
        if (model.data?.token != null) {
          await _tokenStorage.saveToken(model.data!.token);
        }

        if (model.data?.user != null) {
          await _saveUserData(model.data!.user);
        }

        // ✅ Send FCM token after successful signup
        await NotificationService.sendFcmTokenToServer(forceUpdate: true);

        AppAlerts.success(model.message);
        _clearForm();

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(RouteName.homeScreen);
      } else {
        _handleValidationErrors(model.errors, model.message);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateSignUpInputs() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty) {
      AppAlerts.error('Please enter your name');
      return false;
    }

    if (name.length < 2) {
      AppAlerts.error('Name must be at least 2 characters');
      return false;
    }

    if (email.isEmpty) {
      AppAlerts.error('Please enter your email');
      return false;
    }

    if (!Utils.isEmailValid(email)) {
      AppAlerts.error('Please enter a valid email address');
      return false;
    }

    if (password.isEmpty) {
      AppAlerts.error('Please enter a password');
      return false;
    }

    if (password.length < 6) {
      AppAlerts.error('Password must be at least 6 characters');
      return false;
    }

    if (!agreeToTerms.value) {
      AppAlerts.error('Please agree to terms and privacy policy');
      return false;
    }

    return true;
  }

  // ==================== SIGN IN ====================

  Future<void> signIn() async {
    if (!_validateSignInInputs()) return;

    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      final response = await _authService.signIn<Map<String, dynamic>>(data);
      final model = LoginResponseModel.fromJson(response);

      if (model.success) {
        if (model.data?.token != null) {
          await _tokenStorage.saveToken(model.data!.token);
        }

        if (model.data?.user != null) {
          await _saveUserData(model.data!.user);
        }

        // ✅ Send FCM token after successful login
        await NotificationService.sendFcmTokenToServer(forceUpdate: true);

        AppAlerts.success(model.message);
        _clearForm();

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(RouteName.homeScreen);
      } else {
        AppAlerts.error(
          model.message.isNotEmpty ? model.message : 'Login failed',
        );
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateSignInInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      AppAlerts.error('Please enter your email');
      return false;
    }

    if (!Utils.isEmailValid(email)) {
      AppAlerts.error('Please enter a valid email address');
      return false;
    }

    if (password.isEmpty) {
      AppAlerts.error('Please enter a password');
      return false;
    }

    return true;
  }

  // ==================== FORGOT PASSWORD ====================

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppAlerts.error('Please enter your email');
      return;
    }

    if (!Utils.isEmailValid(email)) {
      AppAlerts.error('Please enter a valid email address');
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {"email": email};

      final response = await _authService.forgotPassword<Map<String, dynamic>>(
        data,
      );
      final model = ForgotPassResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);

        // Start OTP timer
        _startOtpTimer();

        await Future.delayed(const Duration(seconds: 1));
        Get.toNamed(RouteName.otp);
      } else {
        AppAlerts.error(
          model.message.isNotEmpty ? model.message : 'Failed to send OTP',
        );
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== VERIFY OTP ====================

  Future<void> verifyOtp() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      AppAlerts.error('Please enter OTP');
      return;
    }

    if (otp.length != 6) {
      AppAlerts.error('OTP must be 6 digits');
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {"email": email, "otp": otp};

      final response = await _authService.verifyOtp<Map<String, dynamic>>(data);
      final model = VerifyOtpResponseModel.fromJson(response);

      if (model.success) {
        // Save reset token
        resetToken = model.resetToken;

        AppAlerts.success(model.message);

        // Stop timer
        _stopOtpTimer();

        await Future.delayed(const Duration(seconds: 1));
        Get.toNamed(RouteName.createNewPass);
      } else {
        AppAlerts.error(
          model.message.isNotEmpty ? model.message : 'Invalid OTP',
        );
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== RESET PASSWORD ====================

  Future<void> resetPassword() async {
    if (!_validateResetPasswordInputs()) return;

    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {
        "email": emailController.text.trim(),
        "reset_token": resetToken,
        "password": passwordController.text.trim(),
        "confirm_password": confirmPasswordController.text.trim(),
      };

      final response = await _authService.resetPassword<Map<String, dynamic>>(
        data,
      );
      final model = ResetPasswordResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);
        _clearForm();

        // Clear reset token
        resetToken = null;

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(RouteName.signIn);
      } else {
        AppAlerts.error(
          model.message.isNotEmpty ? model.message : 'Failed to reset password',
        );
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateResetPasswordInputs() {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty) {
      AppAlerts.error('Please enter new password');
      return false;
    }

    if (password.length < 6) {
      AppAlerts.error('Password must be at least 6 characters');
      return false;
    }

    if (confirmPassword.isEmpty) {
      AppAlerts.error('Please confirm your password');
      return false;
    }

    if (password != confirmPassword) {
      AppAlerts.error('Passwords do not match');
      return false;
    }

    if (resetToken == null || resetToken!.isEmpty) {
      AppAlerts.error('Invalid reset token. Please try again');
      Get.offAllNamed(RouteName.forgetPassword);
      return false;
    }

    return true;
  }

  // ==================== RESEND OTP ====================

  Future<void> resendOtp() async {
    await forgotPassword();
  }

  // ==================== OTP TIMER ====================

  void _startOtpTimer() {
    otpTimer.value = 180; // 3 minutes
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimer.value > 0) {
        otpTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void _stopOtpTimer() {
    _timer?.cancel();
    otpTimer.value = 0;
  }

  String get otpTimerFormatted {
    final minutes = (otpTimer.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (otpTimer.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // ==================== HELPER METHODS ====================

  Future<void> _saveUserData(AuthUser user) async {
    await _storage.write('user_id', user.id);
    await _storage.write('user_name', user.name);
    await _storage.write('user_email', user.email);
  }

  void _handleValidationErrors(
    Map<String, List<String>>? errors,
    String fallbackMessage,
  ) {
    if (errors != null && errors.isNotEmpty) {
      final firstErrorKey = errors.keys.first;
      final firstErrorMessages = errors[firstErrorKey];

      if (firstErrorMessages != null && firstErrorMessages.isNotEmpty) {
        AppAlerts.error(firstErrorMessages.first);
        return;
      }
    }

    AppAlerts.error(
      fallbackMessage.isNotEmpty ? fallbackMessage : 'Operation failed',
    );
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    otpController.clear();
    agreeToTerms.value = false;
    isEmailValid.value = false;
  }

  // ==================== LOGOUT ====================

  Future<void> logout() async {
    try {
      isLoading.value = true;

      // await _authService.logout<Map<String, dynamic>>();

      await _tokenStorage.clearTokens();
      await _storage.erase();

      AppAlerts.success('Logged out successfully');

      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(RouteName.welcome);
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
