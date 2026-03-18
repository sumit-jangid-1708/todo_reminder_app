// lib/view/auth/otp_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../res/color/app_color.dart';
import '../../res/components/custom_back_button.dart';
import '../../res/components/custom_button.dart';
import '../../res/routes/routes_names.dart';
import '../../res/styles/app_text_styles.dart';
import '../../view_models/controller/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
    );

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
                    'Enter 6 digit\ncode',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'A six-digit code should have come to your email address that you indicated.',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // OTP Pinput field
                  Center(
                    child: Pinput(
                      controller: authController.otpController,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      separatorBuilder: (index) => const SizedBox(width: 15),
                      onCompleted: (pin) {
                        // Auto verify when all digits entered
                        authController.verifyOtp();
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Timer and Resend Code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                        "Code Expire in ${authController.otpTimerFormatted}",
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 13,
                        ),
                      )),
                      Obx(() => TextButton(
                        onPressed: authController.otpTimer.value > 0
                            ? null
                            : authController.resendOtp,
                        child: Text(
                          "Resend Code?",
                          style: TextStyle(
                            color: authController.otpTimer.value > 0
                                ? AppColors.textHint
                                : AppColors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      )),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Submit Button
                  Obx(() => CustomButton(
                    text: "Submit OTP",
                    onPressed: authController.verifyOtp,
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