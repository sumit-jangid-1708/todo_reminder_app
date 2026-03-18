// lib/view/payable/payable_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/res/components/custom_search_bar.dart';
import 'package:todo_reminder/view_models/controller/payment_controller.dart';

import '../res/components/widgets/payment_card_widget.dart';
import '../res/components/widgets/summary_card_widget.dart';
import '../res/components/widgets/tab_button_widget.dart';

class PayableScreen extends StatelessWidget {
  const PayableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());

    return Scaffold(
      backgroundColor: AppColors.gray,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Payables',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // White section with summary and tabs
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle
                Text(
                  'People you need to pay.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 16),

                // Summary Card
                const SummaryCard(
                  title: 'Total Payable',
                  amount: '₹18,500',
                ),

                const SizedBox(height: 16),

                // Search Bar
                CustomSearchBar(
                  controller: controller.searchController,
                  hintText: 'Search for fee...',
                  onChanged: (value) {
                    // Already handled by controller listener
                  },
                  onClear: controller.clearSearch,
                ),

                const SizedBox(height: 16),

                // Tabs
                Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      TabButton(
                        text: 'Payables',
                        isSelected: controller.selectedTab.value == 0,
                        onTap: () => controller.changeTab(0),
                      ),
                      const SizedBox(width: 8),
                      TabButton(
                        text: 'Due Payment',
                        isSelected: controller.selectedTab.value == 1,
                        onTap: () => controller.changeTab(1),
                      ),
                      const SizedBox(width: 8),
                      TabButton(
                        text: 'Upcoming Emi',
                        isSelected: controller.selectedTab.value == 2,
                        onTap: () => controller.changeTab(2),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),

          // List Section
          Expanded(
            child: Obx(() => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Sample Payment Cards
                PaymentCard(
                  personName: 'Rahul Sharma',
                  amount: '₹12,500',
                  dueDate: 'Due: 15 March',
                  showPayButton: controller.selectedTab.value == 0,
                  showDuePaymentButton: controller.selectedTab.value == 1,
                  showUpcomingEmiButton: controller.selectedTab.value == 2,
                  showViewButton: true,
                  onPayPressed: () => controller.handlePay('Rahul Sharma'),
                  onDuePaymentPressed: () => controller.handleDuePayment('Rahul Sharma'),
                  onUpcomingEmiPressed: () => controller.handleUpcomingEmi('Rahul Sharma'),
                  onViewPressed: () => controller.handleView('Rahul Sharma'),
                ),

                PaymentCard(
                  personName: 'Rahul Sharma',
                  amount: '₹12,500',
                  dueDate: 'Due: 15 March',
                  showPayButton: controller.selectedTab.value == 0,
                  showDuePaymentButton: controller.selectedTab.value == 1,
                  showUpcomingEmiButton: controller.selectedTab.value == 2,
                  showViewButton: true,
                  onPayPressed: () => controller.handlePay('Rahul Sharma'),
                  onDuePaymentPressed: () => controller.handleDuePayment('Rahul Sharma'),
                  onUpcomingEmiPressed: () => controller.handleUpcomingEmi('Rahul Sharma'),
                  onViewPressed: () => controller.handleView('Rahul Sharma'),
                ),

                PaymentCard(
                  personName: 'Rahul Sharma',
                  amount: '₹12,500',
                  dueDate: 'Due: 15 March',
                  showPayButton: controller.selectedTab.value == 0,
                  showDuePaymentButton: controller.selectedTab.value == 1,
                  showUpcomingEmiButton: controller.selectedTab.value == 2,
                  showViewButton: true,
                  onPayPressed: () => controller.handlePay('Rahul Sharma'),
                  onDuePaymentPressed: () => controller.handleDuePayment('Rahul Sharma'),
                  onUpcomingEmiPressed: () => controller.handleUpcomingEmi('Rahul Sharma'),
                  onViewPressed: () => controller.handleView('Rahul Sharma'),
                ),

                PaymentCard(
                  personName: 'Rahul Sharma',
                  amount: '₹12,500',
                  dueDate: 'Due: 15 March',
                  showPayButton: controller.selectedTab.value == 0,
                  showDuePaymentButton: controller.selectedTab.value == 1,
                  showUpcomingEmiButton: controller.selectedTab.value == 2,
                  showViewButton: true,
                  onPayPressed: () => controller.handlePay('Rahul Sharma'),
                  onDuePaymentPressed: () => controller.handleDuePayment('Rahul Sharma'),
                  onUpcomingEmiPressed: () => controller.handleUpcomingEmi('Rahul Sharma'),
                  onViewPressed: () => controller.handleView('Rahul Sharma'),
                ),

                PaymentCard(
                  personName: 'Rahul Sharma',
                  amount: '₹12,500',
                  dueDate: 'Due: 15 March',
                  showPayButton: controller.selectedTab.value == 0,
                  showDuePaymentButton: controller.selectedTab.value == 1,
                  showUpcomingEmiButton: controller.selectedTab.value == 2,
                  showViewButton: true,
                  onPayPressed: () => controller.handlePay('Rahul Sharma'),
                  onDuePaymentPressed: () => controller.handleDuePayment('Rahul Sharma'),
                  onUpcomingEmiPressed: () => controller.handleUpcomingEmi('Rahul Sharma'),
                  onViewPressed: () => controller.handleView('Rahul Sharma'),
                ),
              ],
            )),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addPayable,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}