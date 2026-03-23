// lib/view/statement_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_reminder/model/statement_model.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/res/components/custom_dropdown.dart';
import 'package:todo_reminder/view_models/controller/statement_controller.dart';

// ✅ StatelessWidget with GetX - No need for StatefulWidget!
class StatementScreen extends StatelessWidget {
  const StatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Get or create controller (only once)
    final controller = Get.put(StatementController());

    // ✅ Initialize on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get transaction data from arguments
      final arguments = Get.arguments as Map<String, dynamic>?;
      final name = arguments?['name'] ?? '';
      final phone = arguments?['phone'] ?? '';
      final personType = arguments?['personType'] ?? '';

      // Initialize controller if not already initialized
      if (controller.contactPhone.isEmpty) {
        controller.initialize(
          name: name,
          phone: phone,
          type: personType,
        );
      }
    });

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
          "Statement",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingStatement.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final statement = controller.statementData.value;
        if (statement == null) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "View your complete transaction history and balances.",
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 25),

              // Contact Name
              Text(
                statement.contact.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Filter Dropdown
              Obx(() => CustomDropdown(
                hint: "Select Month",
                items: controller.filterOptions,
                value: controller.selectedFilter.value,
                onChanged: (val) => controller.onFilterChanged(val),
              )),

              const SizedBox(height: 30),

              // Balance Summary
              const Text(
                "Balance Summary",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  _buildSummaryCard(
                    title: "You Will Receive",
                    amount: controller.balanceReceive,
                    color: const Color(0xFFE8FFF0),
                    textColor: Colors.green.shade700,
                  ),
                  const SizedBox(width: 15),
                  _buildSummaryCard(
                    title: "You Will Pay",
                    amount: controller.balancePay,
                    color: const Color(0xFFFFE8E8),
                    textColor: Colors.red.shade700,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Transaction History
              const Text(
                "Transaction History",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Sort dates chronologically
              ...(() {
                final sortedDateGroups = List<StatementDateData>.from(statement.data);
                sortedDateGroups.sort((a, b) => _compareDate(a.date, b.date));
                return sortedDateGroups;
              })().map((dateGroup) => _buildDateGroup(dateGroup)).toList(),

              const SizedBox(height: 20),

              // Download Button
              Obx(() => ElevatedButton(
                onPressed: controller.isDownloadingPDF.value
                    ? null
                    : () => controller.downloadStatement(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: controller.isDownloadingPDF.value
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "Download Statement",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
            ],
          ),
        );
      }),
    );
  }

  /// Date Group Widget
  Widget _buildDateGroup(StatementDateData dateGroup) {
    // Sort transactions by time
    final sortedTransactions = List<StatementTransaction>.from(dateGroup.transactions);
    sortedTransactions.sort((a, b) => _compareTime(a.time, b.time));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month/Year Header
        Text(
          _formatMonthYear(dateGroup.date),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const Divider(),

        // Transactions
        ...sortedTransactions.map((tx) => _buildTransactionItem(tx, dateGroup.date)).toList(),

        const SizedBox(height: 15),
      ],
    );
  }

  /// Transaction Item
  Widget _buildTransactionItem(StatementTransaction tx, String date) {
    final isReceived = tx.transactionType == 'received';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Date, Type, Balance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  isReceived ? "Payment Received" : "Payment Given",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Balance",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Right Side: Amount, Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${isReceived ? '+' : '-'}₹${tx.totalAmount}",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isReceived ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "₹${tx.pendingAmount}",
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Balance Summary Card
  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required Color color,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
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
            "No statement data available",
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

  /// Format Month Year (e.g., "March 2026")
  String _formatMonthYear(String date) {
    try {
      final parsed = DateFormat('dd MMM yyyy').parse(date);
      return DateFormat('MMMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// Compare dates for sorting
  int _compareDate(String dateA, String dateB) {
    try {
      final parsedA = DateFormat('dd MMM yyyy').parse(dateA);
      final parsedB = DateFormat('dd MMM yyyy').parse(dateB);
      return parsedA.compareTo(parsedB);
    } catch (e) {
      return 0;
    }
  }

  /// Compare times for sorting
  int _compareTime(String timeA, String timeB) {
    try {
      final parsedA = _parseTime(timeA);
      final parsedB = _parseTime(timeB);
      return parsedA.compareTo(parsedB);
    } catch (e) {
      return 0;
    }
  }

  /// Parse time string
  DateTime _parseTime(String time) {
    final cleaned = time.trim().toUpperCase();
    final regex = RegExp(r'(\d{1,2}):(\d{2})(AM|PM)');
    final match = regex.firstMatch(cleaned);

    if (match == null) {
      throw FormatException('Invalid time format: $time');
    }

    int hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!;

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(2000, 1, 1, hour, minute);
  }
}