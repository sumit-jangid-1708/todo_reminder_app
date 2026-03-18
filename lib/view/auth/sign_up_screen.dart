// lib/view/auth/sign_up_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/color/app_color.dart';
import '../../res/components/custom_back_button.dart';
import '../../res/components/custom_button.dart';
import '../../res/components/custom_textfield.dart';
import '../../res/routes/routes_names.dart';
import '../../res/styles/app_text_styles.dart';
import '../../view_models/controller/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

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

                      // Back Button
                      CustomBackButton(onTap: () => Get.back()),

                      const SizedBox(height: 40),

                      // Sign Up Header
                      Text(
                        'Sign up',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.primary,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please create a new account',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Name Field
                      const Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: authController.nameController,
                        hintText: "Type something longer here...",
                        // prefixIcon: Icons.person_outline,
                      ),

                      const SizedBox(height: 20),

                      // Email Field
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: authController.emailController,
                        hintText: "myemail@gmail.com",
                        // prefixIcon: Icons.email_outlined,
                        // isValid: authController.isEmailValid,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      const Text(
                        "Password",
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
                        // prefixIcon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      const SizedBox(height: 24),

                      // Terms & Conditions Checkbox
                      Obx(() => _buildTermsCheckbox(authController)),

                      const SizedBox(height: 30),

                      // Sign Up Button
                      Obx(() =>
                          CustomButton(
                            text: "Sign up",
                            onPressed: authController.agreeToTerms.value
                                ? authController.signUp
                                : null,
                            height: 55,
                            borderRadius: 12,
                            backgroundColor: AppColors.primary,
                            isLoading: authController.isLoading.value,
                          )),

                      const SizedBox(height: 20),

                      // Already have account? Sign in
                      _buildSignInLink(),

                      const SizedBox(height: 40),
                    ],
                  ),
                )
            );
          })
      ),
    );
  }

  /// Terms & Conditions Checkbox
  Widget _buildTermsCheckbox(AuthController controller) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: controller.agreeToTerms.value,
            onChanged: (value) {
              controller.agreeToTerms.value = value ?? false;
            },
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: BorderSide(
              color: AppColors.primary.withOpacity(0.3),
              width: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
              children: [
                const TextSpan(text: 'Agree the '),
                TextSpan(
                  text: 'terms of use',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'privacy policy',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Sign In Link
  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.black,
          ),
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(RouteName.signIn);
            // Get.back();
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign in',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
