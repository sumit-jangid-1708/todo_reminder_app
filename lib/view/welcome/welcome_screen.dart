import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/res/components/custom_button.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import 'package:todo_reminder/view/auth/sign_in_screen.dart';
import '../../res/styles/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              // Welcome Text
              const Text('Welcome', style: AppTextStyles.h1),
              const Text('Start tracking your lending and borrowing easily. Never forget dues, EMI, or payments with smart reminders.', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 250),
              CustomButton(text: "Sign in", onPressed: () {
                Get.toNamed(RouteName.signIn);
              },
              height: 50,
              ),
              const SizedBox(height: 20),
              // Footer Text
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New customer? ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: AppColors.black,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteName.signUp);
                      },
                      child: const Text(
                        'Create new account',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: AppColors.primary,
                          fontFamily: 'Roboto',
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
      ),
    );
  }
}
