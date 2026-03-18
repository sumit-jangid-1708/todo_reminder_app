import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import '../res/components/custom_textfield.dart'; // Apna path check kar lein

class PersonProfileScreen extends StatelessWidget {
  const PersonProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for the fields
    final nameController = TextEditingController(text: "Neha sharma");
    final phoneController = TextEditingController(text: "+91 987876765768");
    final addressController = TextEditingController(text: "Address");

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
      body: SingleChildScrollView( // Added scroll view to avoid overflow with keyboard
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- Profile Image ---
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.primary.withOpacity(0.7),
                      child: const Icon(Icons.person_outline, size: 60, color: Colors.white),
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
              ),

              const SizedBox(height: 40),

              // --- Name Field ---
              CustomTextField(
                controller: nameController,
                hintText: "Enter your name",
              ),

              const SizedBox(height: 25),
              const Text(
                "Contact Information",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
              const SizedBox(height: 15),

              // --- Phone Number Field ---
              CustomTextField(
                controller: phoneController,
                hintText: "Phone number",
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 15),

              // --- Address Field ---
              CustomTextField(
                controller: addressController,
                hintText: "Enter address",
                maxLines: 1, // Aap chahen to multi-line ke liye ise badha sakte hain
              ),

              const SizedBox(height: 25),

              // --- Delete Option ---
              InkWell(
                onTap: () {
                  // Delete logic
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Delete",
                      style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50), // Spacer ki jagah fixed height scroll view mein better hai

              // --- Save Changes Button ---
              ElevatedButton(
                onPressed: () {
                  // Save logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}