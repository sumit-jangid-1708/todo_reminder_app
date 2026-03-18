// lib/view/auth/create_new_password_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/color/app_color.dart';
import '../../res/components/custom_back_button.dart';
import '../../res/components/custom_button.dart';
import '../../res/components/custom_textfield.dart';
import '../../res/routes/routes_names.dart';
import '../../res/styles/app_text_styles.dart';
import '../../view_models/controller/auth_controller.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() {
          return AbsorbPointer(
            absorbing: authController.isLoading.value,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CustomBackButton(onTap: () => Get.back()),
                  const SizedBox(height: 40),

                  // Header
                  Text(
                    'Create New\nPassword',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Set a strong password to secure your account.',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // New Password
                  const Text(
                    "New Password",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: authController.passwordController,
                    hintText: "••••••••••",
                    isPassword: true,
                  ),

                  const SizedBox(height: 6),

                  // Strong Password Indicator
                  Obx(() {
                    // final password = authController.passwordController.text;
                    // final isStrong = password.length >= 8 &&
                    //     password.contains(RegExp(r'[A-Z]')) &&
                    //     password.contains(RegExp(r'[0-9]'));
                    final isStrong = authController.isPasswordStrong;
                    return Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 14,
                          color: isStrong ? Colors.green : AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isStrong ? "Strong Password" : "Weak Password",
                          style: TextStyle(
                            color: isStrong ? Colors.green : AppColors.textHint,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 20),

                  // Confirm Password
                  const Text(
                    "Confirm Password",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: authController.confirmPasswordController,
                    hintText: "••••••••••",
                    isPassword: true,
                  ),

                  const SizedBox(height: 40),

                  // Submit Button
                  Obx(() => CustomButton(
                    text: "Submit",
                    onPressed: authController.resetPassword,
                    height: 55,
                    borderRadius: 12,
                    backgroundColor: AppColors.primary,
                    isLoading: authController.isLoading.value,
                  )),

                  const SizedBox(height: 25),

                  // Footer Login Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "I have remember my password? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.offAllNamed(RouteName.signIn),
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}