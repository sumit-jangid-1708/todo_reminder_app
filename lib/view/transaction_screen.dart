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

  late String name;
  late String phone;
  late String personType;

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.containsKey('transaction')) {
      final transactionData = arguments['transaction'];

      if (transactionData is TransactionModel) {
        name = transactionData.name;
        phone = transactionData.phone;
        personType = transactionData.personType;
      } else if (transactionData is Map<String, dynamic>) {
        name = transactionData['name'] ?? '';
        phone = transactionData['phone'] ?? '';
        personType = transactionData['personType'] ?? '';
      } else {
        name = '';
        phone = '';
        personType = '';
      }
    } else {
      name = '';
      phone = '';
      personType = '';
    }

    controller = Get.put(TransactionController());

    // ✅ Seed the RxString with the name received from the previous screen
    controller.contactName.value = name;
    controller.setPersonType(personType);

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
              IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child:
                const Icon(Icons.person, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Obx now tracks controller.contactName (RxString) — no more GetX error
                    Obx(() => Text(
                      controller.contactName.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          RouteName.personProfile,
                          arguments: {
                            'phone': phone,
                            'name': name,
                            'personType': personType,
                          },
                        );
                      },
                      child: const Text(
                        "View Profile",
                        style:
                        TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
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
          Expanded(
            child: Obx(() {
              if (controller.isLoadingStatement.value) {
                return const Center(
                  child:
                  CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final statement = controller.statementData.value;
              if (statement == null || statement.data.isEmpty) {
                return _buildEmptyState();
              }

              final sortedDateGroups =
              List<StatementDateData>.from(statement.data);
              sortedDateGroups.sort((a, b) => _compareDate(a.date, b.date));

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                itemCount: sortedDateGroups.length,
                itemBuilder: (context, index) {
                  return _buildDateGroup(sortedDateGroups[index]);
                },
              );
            }),
          ),
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  // ── Date / time helpers ──────────────────────────────────────────

  int _compareDate(String dateA, String dateB) {
    try {
      return _parseDate(dateA).compareTo(_parseDate(dateB));
    } catch (_) {
      return 0;
    }
  }

  DateTime _parseDate(String date) {
    try {
      return DateFormat('dd MMM yyyy').parse(date);
    } catch (_) {
      return DateTime.now();
    }
  }

  Widget _buildDateGroup(StatementDateData dateGroup) {
    final sorted = List<StatementTransaction>.from(dateGroup.transactions);
    sorted.sort((a, b) => _compareTime(a.time, b.time));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
        ...sorted.map((tx) => _buildTransactionItem(tx)),
      ],
    );
  }

  int _compareTime(String timeA, String timeB) {
    try {
      return _parseTime(timeA).compareTo(_parseTime(timeB));
    } catch (_) {
      return 0;
    }
  }

  DateTime _parseTime(String time) {
    final cleaned = time.trim().toUpperCase();
    final regex = RegExp(r'(\d{1,2}):(\d{2})(AM|PM)');
    final match = regex.firstMatch(cleaned);
    if (match == null) throw FormatException('Invalid time: $time');

    int hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!;

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return DateTime(2000, 1, 1, hour, minute);
  }

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
                      tx.isGiven
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
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
                    style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
            child: Text(
              tx.time,
              style:
              TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64, color: Colors.grey.shade300),
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

  void _navigateToPayment(String transactionType) async {
    controller.initializeTransaction(
      name: controller.contactName.value, // ✅ use current (possibly updated) name
      phone: phone,
      personType: personType,
      transactionType: transactionType,
    );

    final result = await Get.toNamed(RouteName.paymentScreen);
    if (result == true) {
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
              // ✅ Obx is now safe — isDeletingContact is RxBool
              Obx(() => _buildMenuOption(
                icon: Icons.delete_outline,
                title: "Delete",
                iconColor: Colors.redAccent,
                titleColor: Colors.redAccent,
                isLoading: controller.isDeletingContact.value,
                onTap: controller.isDeletingContact.value
                    ? null
                    : () {
                  Navigator.pop(context);
                  _showDeleteConfirmation();
                },
              )),
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Contact',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "$name"? '
              'This will also remove all their transactions.',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteContact(phone);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color iconColor = Colors.black87,
    Color titleColor = Colors.black87,
    bool isLoading = false,
  }) {
    return ListTile(
      leading: isLoading
          ? const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
            strokeWidth: 2, color: Colors.redAccent),
      )
          : Icon(icon, color: iconColor, size: 22),
      title: Text(title,
          style: TextStyle(fontSize: 16, color: titleColor)),
      onTap: onTap,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}