// lib/view_models/controller/auth_controller.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_reminder/model/auth_models/auth_user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/storage/token_storage.dart';
import '../../model/auth_models/forgot_password_model.dart';
import '../../model/auth_models/profile_delete_response_model.dart';
import '../../model/auth_models/profile_update_response_model.dart';
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
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
    '731022300465-7fefrrme52cvrh3u6eeqoauk94slnnqv.apps.googleusercontent.com',
  );
  final AuthService _authService = AuthService();
  final TokenStorage _tokenStorage = TokenStorage();
  final GetStorage _storage = GetStorage();
  final ImagePicker _imagePicker = ImagePicker();

  // Form Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // Profile Controllers
  final TextEditingController profileNameController = TextEditingController();
  final TextEditingController profileEmailController = TextEditingController();
  final TextEditingController profilePasswordController =
  TextEditingController();

  // Reactive States
  final RxBool isLoading = false.obs;
  final RxBool agreeToTerms = false.obs;
  final RxBool isEmailValid = false.obs;
  final RxString passwordText = ''.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString profileAvatarUrl = ''.obs; // ✅ used in HomeHeader

  // OTP Timer
  final RxInt otpTimer = 180.obs;
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
    _loadUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    profileNameController.dispose();
    profileEmailController.dispose();
    profilePasswordController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void _loadUserProfile() {
    profileNameController.text = _storage.read('user_name') ?? '';
    profileEmailController.text = _storage.read('user_email') ?? '';
    profileAvatarUrl.value = _storage.read('user_avatar') ?? '';
  }

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

  // ==================== IMAGE PICKER ====================

  Future<void> pickProfileImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      AppAlerts.error('Failed to pick image');
    }
  }

  // ==================== UPDATE PROFILE ====================

  Future<void> updateProfile() async {
    if (!_validateProfileInputs()) return;

    try {
      isLoading.value = true;

      final response = await _authService.updateProfile<Map<String, dynamic>>(
        name: profileNameController.text.trim(),
        email: profileEmailController.text.trim(),
        password: profilePasswordController.text.trim().isNotEmpty
            ? profilePasswordController.text.trim()
            : null,
        avatarFile: profileImage.value,
      );

      final model = ProfileUpdateResponse.fromJson(response);

      if (model.success) {
        if (model.data != null) {
          await _storage.write('user_name', model.data!.user.name);
          await _storage.write('user_email', model.data!.user.email);
          await _storage.write('user_avatar', model.data!.avatarUrl);
          profileAvatarUrl.value = model.data!.avatarUrl;
          profilePasswordController.clear();
          profileImage.value = null;
        }
        AppAlerts.success(model.message);
      } else {
        AppAlerts.error(model.message);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateProfileInputs() {
    final name = profileNameController.text.trim();
    final email = profileEmailController.text.trim();

    if (name.isEmpty) { AppAlerts.error('Please enter your name'); return false; }
    if (name.length < 2) { AppAlerts.error('Name must be at least 2 characters'); return false; }
    if (email.isEmpty) { AppAlerts.error('Please enter your email'); return false; }
    if (!Utils.isEmailValid(email)) { AppAlerts.error('Please enter a valid email address'); return false; }
    return true;
  }

  // ==================== DELETE ACCOUNT ====================

  Future<void> deleteAccount(String password) async {
    if (password.isEmpty) {
      AppAlerts.error('Please enter your password');
      return;
    }
    try {
      isLoading.value = true;
      final response =
      await _authService.deleteAccount<Map<String, dynamic>>(password);
      final model = ProfileDeleteResponse.fromJson(response);
      if (model.success) {
        await _tokenStorage.clearTokens();
        await _storage.erase();
        AppAlerts.success(model.message);
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(RouteName.welcome);
      } else {
        AppAlerts.error(model.message);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== SIGN UP ====================

  Future<void> signUp() async {
    if (!_validateSignUpInputs()) return;

    try {
      isLoading.value = true;

      final response = await _authService.signUp<Map<String, dynamic>>({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      });
      final model = RegisterResponseModel.fromJson(response);

      if (model.success) {
        if (model.data?.token != null) {
          await _tokenStorage.saveToken(model.data!.token);
        }
        if (model.data?.user != null) {
          await _saveUserData(model.data!.user);
        }

        AppAlerts.success(model.message);
        _clearForm();

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(RouteName.homeScreen);

        // ✅ FCM after navigation — non-blocking, token is saved by now
        _sendFcmSafely();
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

    if (name.isEmpty) { AppAlerts.error('Please enter your name'); return false; }
    if (name.length < 2) { AppAlerts.error('Name must be at least 2 characters'); return false; }
    if (email.isEmpty) { AppAlerts.error('Please enter your email'); return false; }
    if (!Utils.isEmailValid(email)) { AppAlerts.error('Please enter a valid email address'); return false; }
    if (password.isEmpty) { AppAlerts.error('Please enter a password'); return false; }
    if (password.length < 6) { AppAlerts.error('Password must be at least 6 characters'); return false; }
    if (!agreeToTerms.value) { AppAlerts.error('Please agree to terms and privacy policy'); return false; }
    return true;
  }

  // ==================== SIGN IN ====================

  Future<void> signIn() async {
    if (!_validateSignInInputs()) return;

    try {
      isLoading.value = true;

      final response = await _authService.signIn<Map<String, dynamic>>({
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      });
      final model = LoginResponseModel.fromJson(response);

      if (model.success) {
        if (model.data?.token != null) {
          await _tokenStorage.saveToken(model.data!.token);
        }
        if (model.data?.user != null) {
          await _saveUserData(model.data!.user);
        }

        AppAlerts.success(model.message);
        _clearForm();

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(RouteName.homeScreen);

        // ✅ FCM after navigation — non-blocking
        _sendFcmSafely();
      } else {
        AppAlerts.error(
            model.message.isNotEmpty ? model.message : 'Login failed');
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
    if (email.isEmpty) { AppAlerts.error('Please enter your email'); return false; }
    if (!Utils.isEmailValid(email)) { AppAlerts.error('Please enter a valid email address'); return false; }
    if (password.isEmpty) { AppAlerts.error('Please enter a password'); return false; }
    return true;
  }

  // ==================== GOOGLE SIGN IN ====================

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        AppAlerts.error("Google sign-in failed. Please try again.");
        return;
      }

      final response =
      await _authService.googleLogin<Map<String, dynamic>>(idToken);
      final model = LoginResponseModel.fromJson(response);

      if (model.success) {
        if (model.data?.token != null) {
          await _tokenStorage.saveToken(model.data!.token);
        }
        if (model.data?.user != null) {
          await _saveUserData(model.data!.user);
        }

        AppAlerts.success(model.message);

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(RouteName.homeScreen);

        // ✅ FCM after navigation — non-blocking
        _sendFcmSafely();
      } else {
        AppAlerts.error(model.message);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== FORGOT PASSWORD ====================

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) { AppAlerts.error('Please enter your email'); return; }
    if (!Utils.isEmailValid(email)) { AppAlerts.error('Please enter a valid email address'); return; }

    try {
      isLoading.value = true;
      final response = await _authService
          .forgotPassword<Map<String, dynamic>>({"email": email});
      final model = ForgotPassResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);
        _startOtpTimer();
        await Future.delayed(const Duration(seconds: 1));
        Get.toNamed(RouteName.otp);
      } else {
        AppAlerts.error(
            model.message.isNotEmpty ? model.message : 'Failed to send OTP');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== VERIFY OTP ====================

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty) { AppAlerts.error('Please enter OTP'); return; }
    if (otp.length != 6) { AppAlerts.error('OTP must be 6 digits'); return; }

    try {
      isLoading.value = true;
      final response = await _authService.verifyOtp<Map<String, dynamic>>(
          {"email": emailController.text.trim(), "otp": otp});
      final model = VerifyOtpResponseModel.fromJson(response);

      if (model.success) {
        resetToken = model.resetToken;
        AppAlerts.success(model.message);
        _stopOtpTimer();
        await Future.delayed(const Duration(seconds: 1));
        Get.toNamed(RouteName.createNewPass);
      } else {
        AppAlerts.error(
            model.message.isNotEmpty ? model.message : 'Invalid OTP');
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
      final response =
      await _authService.resetPassword<Map<String, dynamic>>({
        "email": emailController.text.trim(),
        "reset_token": resetToken,
        "password": passwordController.text.trim(),
        "confirm_password": confirmPasswordController.text.trim(),
      });
      final model = ResetPasswordResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);
        _clearForm();
        resetToken = null;
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(RouteName.signIn);
      } else {
        AppAlerts.error(model.message.isNotEmpty
            ? model.message
            : 'Failed to reset password');
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
    if (password.isEmpty) { AppAlerts.error('Please enter new password'); return false; }
    if (password.length < 6) { AppAlerts.error('Password must be at least 6 characters'); return false; }
    if (confirmPassword.isEmpty) { AppAlerts.error('Please confirm your password'); return false; }
    if (password != confirmPassword) { AppAlerts.error('Passwords do not match'); return false; }
    if (resetToken == null || resetToken!.isEmpty) {
      AppAlerts.error('Invalid reset token. Please try again');
      Get.offAllNamed(RouteName.forgetPassword);
      return false;
    }
    return true;
  }

  // ==================== RESEND OTP ====================

  Future<void> resendOtp() async => forgotPassword();

  // ==================== OTP TIMER ====================

  void _startOtpTimer() {
    otpTimer.value = 180;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimer.value > 0) { otpTimer.value--; } else { timer.cancel(); }
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

  /// ✅ Save user data including avatar
  Future<void> _saveUserData(AuthUser user) async {
    await _storage.write('user_id', user.id);
    await _storage.write('user_name', user.name);
    await _storage.write('user_email', user.email);
    // ✅ Save avatar URL (null-safe)
    await _storage.write('user_avatar', user.avatarUrl ?? '');
    // ✅ Update reactive variable immediately
    profileAvatarUrl.value = user.avatarUrl ?? '';
  }

  /// ✅ FCM — called after navigation, non-blocking, errors silently ignored
  void _sendFcmSafely() {
    Future.delayed(const Duration(milliseconds: 500), () {
      NotificationService.sendFcmTokenToServer(forceUpdate: true).catchError(
            (e) => debugPrint("FCM send failed (non-critical): $e"),
      );
    });
  }

  void _handleValidationErrors(
      Map<String, List<String>>? errors,
      String fallbackMessage,
      ) {
    if (errors != null && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first.isNotEmpty) { AppAlerts.error(first.first); return; }
    }
    AppAlerts.error(
        fallbackMessage.isNotEmpty ? fallbackMessage : 'Operation failed');
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
      await _googleSignIn.signOut();
      await _tokenStorage.clearTokens();
      await _storage.erase();
      profileAvatarUrl.value = '';
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