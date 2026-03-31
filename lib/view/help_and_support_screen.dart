import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import '../res/components/custom_search_bar.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          // Image ke hisab se back icon
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            // Search Bar (Custom widget jo aapne banaya hai)
            const CustomSearchBar(hintText: "Search for help..."),

            const SizedBox(height: 35),

            const Text(
              "Frequently Asked Questions?",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87
              ),
            ),

            const SizedBox(height: 10),

            // FAQ List - Expanded use kiya hai taaki footer niche rahe
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildFAQTile("How do I add a contact?"),
                  _buildFAQTile("How do I record a payment?"),
                  _buildFAQTile("How do reminders work?"),
                  _buildFAQTile("How do I add a contact?"),
                  _buildFAQTile("How do I record a payment?"),
                  _buildFAQTile("How do reminders work?"),
                ],
              ),
            ),

            // Footer Links (Privacy Policy & Terms)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterLink("Privacy Policy "),
                    _buildFooterLink("Terms & Conditions"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FAQ Tile Helper (Exact matching as per image)
  Widget _buildFAQTile(String question) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.transparent)) // Border hata diya image ke hisab se
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
            question,
            style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400
            )
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
        onTap: () {},
      ),
    );
  }

  // Footer Link Helper
  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
            fontSize: 10,
            color: Colors.blue.withOpacity(0.7),
            fontWeight: FontWeight.w400
        ),
      ),
    );
  }
}