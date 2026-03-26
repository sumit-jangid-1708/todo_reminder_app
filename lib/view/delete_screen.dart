import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/view_models/controller/auth_controller.dart';
import '../res/components/custom_button.dart';
import '../res/components/custom_dropdown.dart';
import '../res/components/custom_textfield.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedReason;
  bool isConfirmed = false;

  @override
  void dispose() {
    feedbackController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Delete Your Account",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Deleting your account will permanently remove all your data from the app.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 25),
            const Text(
              "Your data that will be deleted:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // --- Bullet Points ---
            _buildBulletPoint("Contacts"),
            _buildBulletPoint("Transactions"),
            _buildBulletPoint("EMI records"),
            _buildBulletPoint("Payment history"),

            const SizedBox(height: 25),
            const Text(
              "Why are you leaving? (Optional)",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // --- Dropdown ---
            CustomDropdown(
              hint: "Select reason",
              items: const [
                "Too many ads",
                "Privacy concerns",
                "Not useful",
                "Other"
              ],
              onChanged: (val) {
                setState(() {
                  selectedReason = val;
                });
              },
            ),

            const SizedBox(height: 25),
            const Text(
              "Additional feedback",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // --- Feedback Text Field ---
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Tell us more...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),

            const SizedBox(height: 15),

            // --- Confirmation Checkbox ---
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: isConfirmed,
                    onChanged: (v) {
                      setState(() {
                        isConfirmed = v ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "I understand this action cannot be undone",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // --- Delete Button ---
            CustomButton(
              text: "Delete Account",
              onPressed: isConfirmed ? () => _showPasswordDialog(context) : null,
              backgroundColor: isConfirmed ? AppColors.primary : Colors.grey,
              height: 55,
              borderRadius: 30,
            ),

            const SizedBox(height: 12),

            // --- Cancel Button ---
            CustomButton(
              text: "Cancel",
              onPressed: () => Get.back(),
              backgroundColor: AppColors.white,
              textColor: Colors.black87,
              borderColor: Colors.grey.shade300,
              height: 55,
              borderRadius: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
                color: Colors.black87, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(text,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  // Password Confirmation Dialog
  void _showPasswordDialog(BuildContext context) {
    passwordController.clear();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Confirm Account Deletion",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please enter your password to confirm account deletion.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: passwordController,
              hintText: "Enter your password",
              isPassword: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              passwordController.clear();
              Get.back();
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          Obx(() => TextButton(
            onPressed: authController.isLoading.value
                ? null
                : () {
              final password = passwordController.text.trim();
              if (password.isNotEmpty) {
                Get.back(); // Close dialog
                authController.deleteAccount(password);
              }
            },
            child: authController.isLoading.value
                ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text(
              "Delete",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        ],
      ),
    );
  }
}