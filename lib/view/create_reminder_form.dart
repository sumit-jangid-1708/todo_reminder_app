// lib/view/create_reminder_form.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/view_models/controller/reminder_controller.dart';
import '../res/components/custom_dropdown.dart';
import '../res/components/custom_textfield.dart';

class CreateReminderForm extends StatelessWidget {
  const CreateReminderForm({super.key});

  @override
  Widget build(BuildContext context) {
    final ReminderController controller = Get.put(ReminderController());

    // Check if editing existing reminder
    final arguments = Get.arguments;
    final int? reminderId = arguments != null && arguments is Map ? arguments['reminderId'] : null;
    final bool isEditing = reminderId != null;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEditing ? "Edit Reminder" : "Create Reminder",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() => AbsorbPointer(
        absorbing: controller.isLoading.value,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Set a reminder so you never miss a payment.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 25),

              // Reminder Title
              const Text("Reminder Title", style: _labelStyle),
              const SizedBox(height: 8),
              CustomTextField(
                controller: controller.titleController,
                hintText: "Enter reminder title",
              ),

              const SizedBox(height: 20),

              // Amount
              const Text("Amount", style: _labelStyle),
              const SizedBox(height: 8),
              CustomTextField(
                controller: controller.amountController,
                hintText: "Enter amount",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              // Reminder Date
              const Text("Reminder Date", style: _labelStyle),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => controller.selectDate(context),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: controller.dateController,
                    hintText: "Select date",
                    // suffixIcon: Icons.calendar_today,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Reminder Before (Dropdown)
              const Text("Reminder Before", style: _labelStyle),
              const SizedBox(height: 8),
              Obx(() => CustomDropdown(
                hint: "${controller.selectedReminderBefore.value} Day Before",
                items: const ["1", "2", "3", "7"],
                onChanged: (val) {
                  if (val != null) {
                    controller.selectedReminderBefore.value = val;
                  }
                },
              )),

              const SizedBox(height: 20),

              // Notes (Optional)
              const Text("Notes (Optional)", style: _labelStyle),
              const SizedBox(height: 8),
              CustomTextField(
                controller: controller.notesController,
                hintText: "Pay installment for bike loan..",
                maxLines: 4,
              ),

              const SizedBox(height: 40),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    controller.updateReminder(reminderId);
                  } else {
                    controller.createReminder();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  isEditing ? "Update Reminder" : "Save Reminder",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel Button
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      )),
    );
  }

  static const _labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );
}