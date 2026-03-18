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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Search Bar
            const CustomSearchBar(hintText: "Search for help..."),

            const SizedBox(height: 30),
            const Text(
              "Help Topics",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Help Topics List
            _buildTopicTile("Contacts", "Learn how to add contacts and track transactions"),
            _buildTopicTile("Transactions", "Help with, adding, editing or deleting transaction"),
            _buildTopicTile("EMI records", "Help with, adding, editing or deleting transaction"),
            _buildTopicTile("Payment history", "Help with, adding, editing or deleting transaction"),

            const SizedBox(height: 10),
            const Divider(thickness: 0.5),
            const SizedBox(height: 20),

            const Text(
              "Frequently Asked Questions?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // FAQ List
            _buildFAQTile("How do I add a contact?"),
            _buildFAQTile("How do I record a payment?"),
            _buildFAQTile("How do reminders work?"),

            const SizedBox(height: 10),
            const Divider(thickness: 0.5),
            const SizedBox(height: 20),

            const Text(
              "Still need help?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Contact Support Tiles
            _buildSupportTile("Email Support", "Example@gmail.com"),
            _buildSupportTile("Report a Problem", ""),

            const SizedBox(height: 40),
            // Footer Links
            Center(
              child: Wrap(
                spacing: 10,
                children: [
                  _buildFooterLink("Privacy Policy"),
                  _buildFooterLink("Terms & Conditions"),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Topic Tile Helper
  Widget _buildTopicTile(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
      onTap: () {},
    );
  }

  // FAQ Tile Helper
  Widget _buildFAQTile(String question) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(question, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
      onTap: () {},
    );
  }

  // Support Tile Helper
  Widget _buildSupportTile(String title, String trailingText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Text(trailingText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // Footer Link Helper
  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w400),
    );
  }
}