// lib/view/receivable/receivable_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/res/components/custom_search_bar.dart';
import 'package:todo_reminder/view_models/controller/receivable_controller.dart';

import '../res/components/widgets/summary_card_widget.dart';
import '../res/components/widgets/tab_button_widget.dart';

class ReceivableScreen extends StatelessWidget {
  const ReceivableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReceivableController controller = Get.put(ReceivableController());

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
          'Receivable',
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
                  'People who will pay you.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 16),

                // Summary Card
                Obx(() => SummaryCard(
                  title: 'Total Receivable',
                  subtitle: 'Upcoming Due',
                  amount: controller.totalReceivable,
                )),

                const SizedBox(height: 16),

                // Search Bar
                CustomSearchBar(
                  controller: controller.searchController,
                  hintText: 'Search by name or phone...',
                  onChanged: (value) {
                    // Already handled by controller listener
                  },
                  onClear: controller.clearSearch,
                ),

                const SizedBox(height: 16),

                // Tabs
                Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TabButton(
                        text: 'All',
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
                        text: 'Upcoming EMI',
                        isSelected: controller.selectedTab.value == 2,
                        onTap: () => controller.changeTab(2),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),

          // List Section with Pull-to-Refresh
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (controller.filteredList.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchReceivables(),
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredList[index];
                    return _buildReceivableCard(item, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Receivable Card Widget
  Widget _buildReceivableCard(dynamic item, ReceivableController controller) {
    return GestureDetector(
      onTap: () => controller.navigateToTransaction(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Left Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        item.formattedPending,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "to receive",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.dueDisplay,
                    style: TextStyle(
                      fontSize: 13,
                      color: item.dueStatus == 'overdue'
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Right Section: Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.formattedPending,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.dueStatus),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.dueStatusText,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Status Color Helper
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'overdue':
        return Colors.red;
      case 'due_soon':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  /// Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            "No receivables found",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}