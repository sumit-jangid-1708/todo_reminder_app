// lib/view/payment_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/view_models/controller/transaction_controller.dart';

import '../res/color/app_color.dart';
import '../res/components/custom_button.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.put(TransactionController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        // ✅ FIXED: Removed Obx since actionLabel doesn't change
        title: Text(
          controller.actionLabel,
          style: TextStyle(
            color: controller.actionColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // --- Profile Section ---
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 45, color: AppColors.white),
            ),
            const SizedBox(height: 12),
            Text(
              controller.contactName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              controller.personType == 'creditor' ? 'Creditor' : 'Debtor',
              style: const TextStyle(fontSize: 14, color: AppColors.text1),
            ),

            const Spacer(flex: 2),

            // --- Amount Input TextField ---
            Column(
              children: [
                IntrinsicWidth(
                  child: TextField(
                    controller: controller.amountController,
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

            const SizedBox(height: 30),

            // --- Note TextField ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: controller.noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Add a note (optional)",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const Spacer(flex: 3),

            // ✅ FIXED: Only use Obx for loading state button
            Obx(() => CustomButton(
              text: "Confirm",
              borderRadius: 12,
              height: 55,
              backgroundColor: AppColors.primary,
              isLoading: controller.isLoading.value,
              onPressed: controller.isLoading.value
                  ? () {}
                  : controller.submitQuickTransaction,
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}