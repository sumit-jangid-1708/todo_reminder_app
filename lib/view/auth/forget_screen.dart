// lib/view/auth/forget_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/color/app_color.dart';
import '../../res/components/custom_back_button.dart';
import '../../res/components/custom_button.dart';
import '../../res/components/custom_textfield.dart';
import '../../res/styles/app_text_styles.dart';
import '../../view_models/controller/auth_controller.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

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
                    'Forgot\npassword?',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Enter your email for the verification process,\nwe will send code to your email',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Email Label
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email Input Field
                  CustomTextField(
                    controller: authController.emailController,
                    hintText: "Type something longer here...",
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 40),

                  // Continue Button
                  Obx(() => CustomButton(
                    text: "Continue",
                    onPressed: authController.forgotPassword,
                    height: 55,
                    borderRadius: 12,
                    backgroundColor: AppColors.primary,
                    isLoading: authController.isLoading.value,
                  )),

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