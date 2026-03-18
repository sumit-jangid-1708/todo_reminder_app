import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/color/app_color.dart';
import '../res/components/custom_button.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for the amount input
    final TextEditingController amountController = TextEditingController(text: "10");
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.black),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // --- Profile Section ---
            // const SizedBox(height: 100),
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 45, color: AppColors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              "Neha Sharma",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "₹0 Due",
              style: TextStyle(fontSize: 14, color: AppColors.text1),
            ),

            const Spacer(flex: 2),

            // --- Amount Input TextField ---
            Column(
              children: [
                IntrinsicWidth(
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      prefixText: "₹",
                      prefixStyle: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      border: InputBorder.none,
                      hintText: "0",
                      hintStyle: TextStyle(color: AppColors.darkGray.withOpacity(0.5)),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 2,
                  color: AppColors.darkGray.withOpacity(0.5),
                ),
              ],
            ),

            const Spacer(flex: 3),

            // --- Confirm Action Button ---
            CustomButton(
              text: "Confirm",
              borderRadius: 12, // App ke design ke hisaab se square-rounded
              height: 55,
              backgroundColor: AppColors.primary,
              onPressed: () {
                print("Confirming Amount: ${amountController.text}");
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}