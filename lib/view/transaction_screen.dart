// lib/view/transaction_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_reminder/model/statement_model.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/res/components/custom_button.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import 'package:todo_reminder/view_models/controller/transaction_controller.dart';
import '../model/transaction_model.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late TransactionController controller;

  // Transaction data
  late String name;
  late String phone;
  late String personType;

  @override
  void initState() {
    super.initState();

    // ✅ Get arguments (can be TransactionModel or Map)
    final arguments = Get.arguments as Map<String, dynamic>?;

    // ✅ Handle both TransactionModel and Map formats
    if (arguments != null && arguments.containsKey('transaction')) {
      final transactionData = arguments['transaction'];

      if (transactionData is TransactionModel) {
        // ✅ Case 1: TransactionModel (from HomeScreen)
        name = transactionData.name;
        phone = transactionData.phone;
        personType = transactionData.personType;
      } else if (transactionData is Map<String, dynamic>) {
        // ✅ Case 2: Map (from Receivable/Payable screens)
        name = transactionData['name'] ?? '';
        phone = transactionData['phone'] ?? '';
        personType = transactionData['personType'] ?? '';
      } else {
        // Fallback
        name = '';
        phone = '';
        personType = '';
      }
    } else {
      // Fallback
      name = '';
      phone = '';
      personType = '';
    }

    // Initialize controller
    controller = Get.put(TransactionController());

    // ✅ Set person type before fetching statement
    controller.setPersonType(personType);

    // Fetch statement
    if (phone.isNotEmpty) {
      controller.fetchStatement(phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- Custom AppBar ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 16,
            bottom: 8,
          ),
          decoration: const BoxDecoration(color: AppColors.primary),
          child: Row(
            children: [
              // Back Button
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              const SizedBox(width: 8),

              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),

              const SizedBox(width: 12),

              // Name & Profile
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteName.personProfile);
                      },
                      child: const Text(
                        "View Profile",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              // More Options
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () => _showMoreMenu(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          // --- Transaction List ---
          Expanded(
            child: Obx(() {
              if (controller.isLoadingStatement.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final statement = controller.statementData.value;
              if (statement == null || statement.data.isEmpty) {
                return _buildEmptyState();
              }

              // ✅ Sort date groups chronologically (oldest first)
              final sortedDateGroups = List<StatementDateData>.from(statement.data);
              sortedDateGroups.sort((a, b) => _compareDate(a.date, b.date));

              // ✅ Display transactions grouped by date
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: sortedDateGroups.length,
                itemBuilder: (context, index) {
                  final dateGroup = sortedDateGroups[index];
                  return _buildDateGroup(dateGroup);
                },
              );
            }),
          ),

          // --- Bottom Action Bar ---
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  /// ✅ Compare date strings for sorting
  int _compareDate(String dateA, String dateB) {
    try {
      final parsedA = _parseDate(dateA);
      final parsedB = _parseDate(dateB);
      return parsedA.compareTo(parsedB);
    } catch (e) {
      print('Error comparing dates: $dateA vs $dateB');
      return 0;
    }
  }

  /// ✅ Parse date string to DateTime
  DateTime _parseDate(String date) {
    try {
      final parsed = DateFormat('dd MMM yyyy').parse(date);
      return parsed;
    } catch (e) {
      print('Error parsing date: $date');
      return DateTime.now();
    }
  }

  /// ✅ Date Group Widget with Time Sorting
  Widget _buildDateGroup(StatementDateData dateGroup) {
    final sortedTransactions = List<StatementTransaction>.from(dateGroup.transactions);
    sortedTransactions.sort((a, b) => _compareTime(a.time, b.time));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              dateGroup.date,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        ...sortedTransactions.map((tx) => _buildTransactionItem(tx)).toList(),
      ],
    );
  }

  /// ✅ Compare time strings for sorting
  int _compareTime(String timeA, String timeB) {
    try {
      final parsedA = _parseTime(timeA);
      final parsedB = _parseTime(timeB);
      return parsedA.compareTo(parsedB);
    } catch (e) {
      print('Error comparing times: $timeA vs $timeB');
      return 0;
    }
  }

  /// ✅ Parse time string to DateTime
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

  /// ✅ Transaction Item Widget
  Widget _buildTransactionItem(StatementTransaction tx) {
    return Align(
      alignment: tx.isGiven ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: tx.isGiven
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: tx.isGiven
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tx.isGiven ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 16,
                      color: tx.isGiven ? AppColors.error : AppColors.success,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "₹${tx.totalAmount}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                if (tx.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    tx.note,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
            child: Text(
              tx.time,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 8),
        ],
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
            "No transactions yet",
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

  /// Bottom Action Bar
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.balanceText,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                controller.balanceLabel,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          )),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Received",
                  icon: Icons.arrow_downward,
                  onPressed: () => _navigateToPayment('received'),
                  backgroundColor: Colors.white,
                  textColor: AppColors.primary,
                  iconColor: AppColors.primary,
                  borderColor: Colors.grey.shade300,
                  borderWidth: 1.5,
                  height: 50,
                  borderRadius: 30,
                  fontSize: 15,
                  iconSize: 18,
                  spacing: 8,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: "Given",
                  icon: Icons.arrow_upward,
                  onPressed: () => _navigateToPayment('given'),
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  height: 50,
                  borderRadius: 30,
                  fontSize: 15,
                  iconSize: 18,
                  spacing: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// ✅ Navigate to Payment Screen
  void _navigateToPayment(String transactionType) async {
    controller.initializeTransaction(
      name: name,
      phone: phone,
      personType: personType,
      transactionType: transactionType,
    );

    final result = await Get.toNamed(RouteName.paymentScreen);

    if (result == true) {
      print('✅ Payment successful, refreshing statement...');
      await controller.fetchStatement(phone);
    }
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuOption(
                icon: Icons.delete_outline,
                title: "Delete",
                onTap: () => Navigator.pop(context),
              ),
              _buildMenuOption(
                icon: Icons.help_outline,
                title: "Help & support",
                onTap: () => Navigator.pop(context),
              ),
              _buildMenuOption(
                icon: Icons.assignment_outlined,
                title: "Statement",
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(
                    RouteName.statementScreen,
                    arguments: {
                      'name': name,
                      'phone': phone,
                      'personType': personType,
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}