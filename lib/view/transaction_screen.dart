// lib/view/transaction_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/res/components/custom_button.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import 'package:todo_reminder/view_models/controller/transaction_controller.dart';
import '../model/transaction_model.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Get transaction data passed from home screen
    final arguments = Get.arguments as Map<String, dynamic>?;
    final TransactionModel? transaction = arguments?['transaction'];

    if (transaction == null) {
      return Scaffold(
        body: Center(
          child: Text('No transaction data found'),
        ),
      );
    }

    // Dummy transaction list (will be replaced with API data later)
    final List<Map<String, dynamic>> transactions = [
      {"amount": "10", "time": "12:39PM", "isGiven": false},
      {"amount": "10", "time": "12:39PM", "isGiven": true},
    ];

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
                      transaction.name,
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
          // Date Chip
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "05 Mar 2026",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // --- Transaction List ---
          Expanded(
            child: transactions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return _buildTransactionItem(tx);
              },
            ),
          ),

          // --- Bottom Action Bar ---
          _buildBottomActionBar(transaction),
        ],
      ),
    );
  }

  /// Transaction Item Widget
  Widget _buildTransactionItem(Map<String, dynamic> tx) {
    final bool isGiven = tx['isGiven'] as bool;

    return Align(
      alignment: isGiven ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isGiven
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isGiven ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: isGiven ? AppColors.error : AppColors.success,
                ),
                const SizedBox(width: 6),
                Text(
                  "₹${tx['amount']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
            child: Text(
              tx['time'] as String,
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
  Widget _buildBottomActionBar(TransactionModel transaction) {
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
          // Balance Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.personType == 'creditor' ? 'You Will Pay' : 'You Will Receive',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "₹${transaction.pendingAmount.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              // ✅ Received Button (Outlined)
              Expanded(
                child: CustomButton(
                  text: "Received",
                  icon: Icons.arrow_downward,
                  onPressed: () => _navigateToPayment(
                    transaction: transaction,
                    transactionType: 'received',
                  ),
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

              // ✅ Given Button (Filled)
              Expanded(
                child: CustomButton(
                  text: "Given",
                  icon: Icons.arrow_upward,
                  onPressed: () => _navigateToPayment(
                    transaction: transaction,
                    transactionType: 'given',
                  ),
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

  /// ✅ Navigate to Payment Screen with transaction data (FIXED)
  void _navigateToPayment({
    required TransactionModel transaction,
    required String transactionType,
  }) async {
    // ✅ FIXED: Use Get.put instead of Get.find
    // This creates the controller if it doesn't exist
    final controller = Get.put(TransactionController());

    controller.initializeTransaction(
      name: transaction.name,
      phone: transaction.phone,
      personType: transaction.personType,
      transactionType: transactionType,
    );

    // Navigate to payment screen
    final result = await Get.toNamed(RouteName.paymentScreen);

    // If payment was successful, refresh transaction list
    if (result == true) {
      print('✅ Payment successful, refreshing transactions...');
      // TODO: Add refresh logic here
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
                onTap: () {
                  Navigator.pop(context);
                  // Delete logic
                },
              ),
              _buildMenuOption(
                icon: Icons.help_outline,
                title: "Help & support",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildMenuOption(
                icon: Icons.assignment_outlined,
                title: "Statement",
                onTap: () {
                  Get.toNamed(RouteName.statementScreen);
                },
              ),
              _buildMenuOption(
                icon: Icons.share_outlined,
                title: "Share",
                onTap: () {
                  Navigator.pop(context);
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