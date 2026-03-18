// lib/res/components/dialogs/reminder_action_dialog.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/model/reminder_response_model.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/view_models/controller/reminder_controller.dart';
import 'package:todo_reminder/view/create_reminder_form.dart';

import '../../../assets/images_assets.dart';
import '../../custom_button.dart';

class ReminderActionDialog extends StatelessWidget {
  final ReminderData reminder;

  const ReminderActionDialog({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    final ReminderController controller = Get.find<ReminderController>();
    final bool isComplete = reminder.status == 'complete';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Icon(Icons.close, size: 18, color: Colors.black),
                    ),
                  ),
                ),

                const Text(
                  "Reminder Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // --- Info Card ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reminder.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text("₹${reminder.amount}", style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text("Due: ${_formatDate(reminder.reminderDate)}", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          const SizedBox(width: 10),
                          if (reminder.note.isNotEmpty)
                            Expanded(child: Text("Note: ${reminder.note}", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black54))),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- Mark as Complete Logic ---
                if (!isComplete)
                  GestureDetector(
                    onTap: () => _showConfirmDialog(
                      context,
                      title: 'Mark as Complete',
                      message: 'Are you sure you want to mark this reminder as complete?',
                      onConfirm: () => controller.markAsComplete(reminder.id),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F9F1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                          const SizedBox(width: 10),
                          Text(
                            "Mark as complete",
                            style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    child: const Text("Status: Completed ✅", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),

                const SizedBox(height: 25),

                // --- Action Buttons ---
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "Edit Reminder",
                        borderRadius: 30,
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          // Close dialog
                          Get.back();

                          // Load reminder data into controller
                          controller.loadReminderForEdit(reminder);

                          // Navigate directly to the screen with arguments
                          Get.to(
                                () => const CreateReminderForm(),
                            arguments: {'reminderId': reminder.id},
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomButton(
                        text: "Delete Reminder",
                        borderRadius: 30,
                        backgroundColor: AppColors.white,
                        textColor: Colors.redAccent,
                        borderColor: Colors.redAccent.withOpacity(0.5),
                        onPressed: () => _showConfirmDialog(
                          context,
                          title: 'Delete Reminder',
                          message: 'Are you sure you want to delete this reminder?',
                          isDelete: true,
                          onConfirm: () => controller.deleteReminder(reminder.id),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Bell Icon ---
          Positioned(
            top: -40,
            child: Image.asset(ImageAssets.notificationBell, height: 100),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, {required String title, required String message, required VoidCallback onConfirm, bool isDelete = false}) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              onConfirm(); // Execute action
            },
            child: Text(isDelete ? "Delete" : "Confirm", style: TextStyle(color: isDelete ? Colors.red : AppColors.primary)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}