// lib/view/add_person_form.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/view_models/controller/home_controller.dart';

import '../../res/color/app_color.dart';
import '../../res/components/custom_button.dart';
import '../../res/components/custom_dropdown.dart';
import '../../res/components/custom_textfield.dart';

class AddPersonForm extends StatelessWidget {
  const AddPersonForm({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Add Transaction",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() => AbsorbPointer(
        absorbing: homeController.isLoading.value,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Primary Type Selection
              CustomDropdown(
                items: const ["Debtor", "Creditor"],
                hint: "Select type",
                onChanged: (val) => homeController.selectedType.value = val!,
              ),
              const SizedBox(height: 25),

              CustomTextField(
                controller: homeController.fullNameController,
                labelText: "Full Name",
                hintText: "Enter Full Name",
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: homeController.mobileNumberController,
                labelText: "Mobile Number",
                hintText: "Enter Mobile Number",
                keyboardType: TextInputType.phone,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () async {
                    final contactData = await homeController.pickContact();
                    if (contactData != null) {
                      homeController.fullNameController.text =
                          contactData["name"] ?? "";
                      homeController.mobileNumberController.text =
                          contactData["number"] ?? "";
                    }
                  },
                  child: const Text(
                    "Add from contacts",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Opening Balance",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // 2. Total Amount
              CustomTextField(
                controller: homeController.totalAmountController,
                labelText: "Total Amount (Optional)",
                hintText: "₹ 10,000",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // 3. Current Pending
              CustomTextField(
                controller: homeController.pendingAmountController,
                labelText: "Current Pending Amount",
                hintText: "₹ 10,000",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),

              // 4. Secondary Dropdown
              CustomDropdown(
                items: const ["To Pay", "To Receive"],
                hint: "Select balance type",
                onChanged: (val) => homeController.selectedBalanceType.value = val!,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(color: Color(0xFFEEEEEE)),
              ),

              // 5. Recurring Payment Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Set Recurring Payment",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Obx(() => Switch(
                    value: homeController.isRecurring.value,
                    activeColor: const Color(0xFF4A80F0),
                    onChanged: (val) => homeController.toggleRecurring(val),
                  )),
                ],
              ),

              // 6. Installment Field
              Obx(() => homeController.isRecurring.value
                  ? Padding(
                padding: const EdgeInsets.only(top: 15),
                child: CustomTextField(
                  controller: homeController.installmentController,
                  labelText: "Installment Amount",
                  hintText: "₹ 1,000",
                  keyboardType: TextInputType.number,
                ),
              )
                  : const SizedBox.shrink()),

              const SizedBox(height: 20),

              CustomTextField(
                controller: homeController.noteController,
                labelText: "Note",
                hintText: "Add a note (optional)",
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // 7. Action Buttons
              CustomButton(
                text: "Confirm",
                borderRadius: 12,
                height: 55,
                isLoading: homeController.isLoading.value,
                onPressed: homeController.addTransaction, // ✅ Call API
              ),
              const SizedBox(height: 12),

              CustomButton(
                text: "Cancel",
                borderRadius: 12,
                height: 55,
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
                borderColor: AppColors.gray,
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )),
    );
  }
}