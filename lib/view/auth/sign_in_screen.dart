// lib/view/auth/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/color/app_color.dart';
import '../../res/components/app_alerts.dart';
import '../../res/components/custom_back_button.dart';
import '../../res/components/custom_button.dart';
import '../../res/components/custom_textfield.dart';
import '../../res/routes/routes_names.dart';
import '../../res/styles/app_text_styles.dart';
import '../../view_models/controller/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
                  CustomBackButton(onTap: () => Get.back()),
                  const SizedBox(height: 40),

                  // Header
                  Text(
                    'Sign in',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please log in into your account',
                    style: TextStyle(color: AppColors.black, fontSize: 15),
                  ),

                  const SizedBox(height: 40),

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
                    isPassword: true,
                  ),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(RouteName.forgetPassword);
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign In Button
                  Obx(() => CustomButton(
                    text: "Sign in",
                    onPressed: authController.signIn,
                    height: 55,
                    borderRadius: 12,
                    backgroundColor: AppColors.primary,
                    isLoading: authController.isLoading.value,
                  )),

                  const SizedBox(height: 30),

                  // Google Sign In Button (TODO: Implement later)
                  CustomButton(
                    backgroundColor: AppColors.white,
                    textColor: AppColors.primary,
                    onPressed: () {
                      authController.signInWithGoogle();
                    },
                    text: "Sign in with Google",
                    height: 55,
                    borderRadius: 12,
                    borderColor: AppColors.primary.withOpacity(0.4),
                    borderWidth: 1.0,
                    iconWidget: Image.asset(
                      "assets/images/google_icon.png",
                      height: 22,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // // Sign Up Link
                  // Center(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       const Text(
                  //         "Don't have an account? ",
                  //         style: TextStyle(
                  //           fontSize: 14,
                  //           color: AppColors.black,
                  //         ),
                  //       ),
                  //       TextButton(
                  //         onPressed: () {
                  //           Get.toNamed(RouteName.signUp);
                  //         },
                  //         style: TextButton.styleFrom(
                  //           padding: EdgeInsets.zero,
                  //           minimumSize: Size.zero,
                  //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         ),
                  //         child: const Text(
                  //           'Sign up',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w600,
                  //             color: AppColors.primary,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

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