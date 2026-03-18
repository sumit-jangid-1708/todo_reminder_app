import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../res/color/app_color.dart';
import '../res/components/custom_dropdown.dart';

class StatementScreen extends StatelessWidget {
  const StatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Create a local observable for dropdown if needed
    final selectedMonth = 'This Month'.obs;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "View your complete transaction history and balances.",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 25),

            const Text(
              "Rahul Sharma",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // ✅ Option 1: Remove Obx if no reactive state needed
            CustomDropdown(
              hint: "Select Month",
              items: const [
                "This Month",
                "Last Month",
                "Last 6 Months",
                "All Time"
              ],
              // value: null, // ✅ Set initial value or use selectedMonth.value
              onChanged: (val) {
                if (val != null) {
                  selectedMonth.value = val; // ✅ Update observable
                  print("Filtering for: $val");
                }
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "Balance Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // --- Balance Summary Cards ---
            Row(
              children: [
                _buildSummaryCard(
                  title: "You Will Receive",
                  amount: "₹12,500",
                  color: const Color(0xFFE8FFF0),
                  textColor: Colors.green.shade700,
                ),
                const SizedBox(width: 15),
                _buildSummaryCard(
                  title: "You Will Pay",
                  amount: "₹3,200",
                  color: const Color(0xFFFFE8E8),
                  textColor: Colors.red.shade700,
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              "Transaction History",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Text(
              "March 2026",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Divider(),

            // --- Transaction List ---
            _buildTransactionItem(
              "Payment Received",
              "12 March 2026",
              "+₹12,500",
              true,
            ),
            _buildTransactionItem(
              "Payment Given",
              "12 March 2026",
              "-₹1,000",
              false,
            ),
            _buildTransactionItem(
              "Payment Received",
              "12 March 2026",
              "+₹12,500",
              true,
            ),
            _buildTransactionItem(
              "Payment Given",
              "12 March 2026",
              "-₹1,000",
              false,
            ),  _buildTransactionItem(
              "Payment Given",
              "12 March 2026",
              "-₹1,000",
              false,
            ),  _buildTransactionItem(
              "Payment Given",
              "12 March 2026",
              "-₹1,000",
              false,
            ),

            const SizedBox(height: 20),

            // --- Download Button ---
            ElevatedButton(
              onPressed: () {
                // Download statement logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Download Statement",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildTransactionItem(
      String title,
      String date,
      String amount,
      bool isCredit,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "Balance",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isCredit ? Colors.green : Colors.red,
                ),
              ),
              const Text(
                "₹12,500",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}