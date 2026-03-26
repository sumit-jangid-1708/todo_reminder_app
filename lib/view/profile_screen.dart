import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import 'package:todo_reminder/view_models/controller/auth_controller.dart';
import '../res/components/custom_button.dart';
import '../res/components/custom_textfield.dart';
import '../res/components/widgets/custom_profile_picker.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  ProfileScreen({super.key});

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
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // --- Profile Image Picker ---
              Obx(() {
                final imagePath = authController.profileImage.value?.path;
                final avatarUrl = authController.profileAvatarUrl.value;

                return CustomProfilePicker(
                  imagePath: imagePath ?? (avatarUrl.isNotEmpty ? avatarUrl : null),
                  onCameraTap: () => authController.pickProfileImage(),
                );
              }),

              const SizedBox(height: 30),

              // --- Name Field ---
              CustomTextField(
                controller: authController.profileNameController,
                labelText: "Name",
                hintText: "Enter your name",
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 20),

              // --- Email Field ---
              CustomTextField(
                controller: authController.profileEmailController,
                labelText: "Email",
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // --- Password Field (Optional) ---
              CustomTextField(
                controller: authController.profilePasswordController,
                labelText: "Password (Optional)",
                hintText: "Enter new password if you want to change",
                isPassword: true,
              ),

              const SizedBox(height: 30),

              // --- Save Button ---
              Obx(() => CustomButton(
                text: "Save Changes",
                onPressed: () => authController.updateProfile(),
                isLoading: authController.isLoading.value,
                height: 55,
                borderRadius: 30,
              )),

              const SizedBox(height: 30),
              const Divider(height: 1, thickness: 0.5),

              // --- Support Section ---
              _buildSectionHeader("Support"),
              _buildNavigationTile(
                "Help & Support — FAQ",
                Icons.arrow_forward_ios,
                onTap: () {
                  Get.toNamed(RouteName.helpScreen);
                },
              ),

              const SizedBox(height: 20),

              // --- Destructive Actions ---
              _buildActionText(
                "Log Out",
                color: Colors.deepOrangeAccent,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
              _buildActionText(
                "Delete Account",
                color: Colors.deepOrangeAccent,
                onTap: () {
                  Get.toNamed(RouteName.deleteScreen);
                },
              ),

              const SizedBox(height: 50),
              Center(
                child: const Text(
                  "App Version 1.0",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Section Label
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Tile with Navigation Arrow
  Widget _buildNavigationTile(String title, IconData icon,
      {required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(title,
          style: const TextStyle(fontSize: 14, color: Colors.black87)),
      trailing: Icon(icon, size: 16, color: Colors.black54),
    );
  }

  // Red/Orange Text Buttons
  Widget _buildActionText(String title,
      {required Color color, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
              color: color, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.deepOrangeAccent),
            ),
          ),
        ],
      ),
    );
  }
}