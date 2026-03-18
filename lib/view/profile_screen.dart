import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import 'package:todo_reminder/view_models/controller/auth_controller.dart'; // Apna path check kar lein

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
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- Profile Header Section ---
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, size: 55, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: const Icon(Icons.camera_alt, size: 18, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Neha sharma",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "+91 89876898767",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Divider(height: 1, thickness: 0.5),

            // --- Notifications Section ---
            _buildSectionHeader("Notifications"),
            _buildSwitchTile("Transaction Alerts", true),
            _buildSwitchTile("Due Reminder Alerts", false),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 1, thickness: 0.5),
            ),

            // --- Support Section ---
            _buildSectionHeader("Support"),
            _buildNavigationTile("Help & Support — FAQ", Icons.arrow_forward_ios, onTap: () {Get.toNamed(RouteName.helpScreen);}),
            _buildNavigationTile("Report a Problem", Icons.arrow_forward_ios, onTap: () {}),

            const SizedBox(height: 20),

            // --- Destructive Actions ---
            _buildActionText("Log Out", color: Colors.deepOrangeAccent, onTap: () {
              authController.logout();
            }),
            _buildActionText("Delete Account", color: Colors.deepOrangeAccent, onTap: () {Get.toNamed(RouteName.deleteScreen);}),

            const SizedBox(height: 50),
            const Text(
              "App Version 1.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Section Label
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Tile with Switch
  Widget _buildSwitchTile(String title, bool value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      trailing: CupertinoSwitch(
        value: value,
        activeColor: AppColors.primary,
        onChanged: (v) {},
      ),
    );
  }

  // Tile with Navigation Arrow
  Widget _buildNavigationTile(String title, IconData icon, {required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      trailing: Icon(icon, size: 16, color: Colors.black54),
    );
  }

  // Red/Orange Text Buttons
  Widget _buildActionText(String title, {required Color color, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}