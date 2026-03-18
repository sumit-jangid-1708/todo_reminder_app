// lib/view_models/controller/payment_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  // Search Controller
  final TextEditingController searchController = TextEditingController();

  // Selected Tab (0: Payables/Receivable, 1: Due Payment, 2: Upcoming Emi)
  final RxInt selectedTab = 0.obs;

  // Search Query
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // ✅ Check if arguments passed from HomeScreen
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      if (arguments.containsKey('tab')) {
        selectedTab.value = arguments['tab'];
      }
    }

    // Listen to search changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Change Tab
  void changeTab(int index) {
    selectedTab.value = index;
  }

  // Clear Search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  // Handle Pay Action
  void handlePay(String personName) {
    Get.snackbar(
      'Payment',
      'Processing payment for $personName',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Handle Due Payment
  void handleDuePayment(String personName) {
    Get.snackbar(
      'Due Payment',
      'Processing due payment for $personName',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Handle Upcoming EMI
  void handleUpcomingEmi(String personName) {
    Get.snackbar(
      'Upcoming EMI',
      'Viewing upcoming EMI for $personName',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Handle View
  void handleView(String personName) {
    Get.snackbar(
      'View Details',
      'Viewing details for $personName',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Add New Payable
  void addPayable() {
    Get.snackbar(
      'Add Payable',
      'Opening add payable form',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Add New Receivable
  void addReceivable() {
    Get.snackbar(
      'Add Receivable',
      'Opening add receivable form',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}