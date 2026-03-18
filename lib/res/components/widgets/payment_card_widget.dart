// lib/res/components/widgets/payment_card.dart

import 'package:flutter/material.dart';
import 'package:todo_reminder/res/color/app_color.dart';

class PaymentCard extends StatelessWidget {
  final String personName;
  final String amount;
  final String dueDate;
  final VoidCallback? onPayPressed;
  final VoidCallback? onDuePaymentPressed;
  final VoidCallback? onUpcomingEmiPressed;
  final VoidCallback? onViewPressed;
  final bool showPayButton;
  final bool showDuePaymentButton;
  final bool showUpcomingEmiButton;
  final bool showViewButton;

  const PaymentCard({
    super.key,
    required this.personName,
    required this.amount,
    required this.dueDate,
    this.onPayPressed,
    this.onDuePaymentPressed,
    this.onUpcomingEmiPressed,
    this.onViewPressed,
    this.showPayButton = false,
    this.showDuePaymentButton = false,
    this.showUpcomingEmiButton = false,
    this.showViewButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Section: Name, Sub-Amount, and Due Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  personName,
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
                      amount,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "to pay",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dueDate, // e.g., "Due: 15 March"
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Right Section: Top Amount and Action Buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showPayButton)
                    _buildActionButton(
                      text: "Pay",
                      color: AppColors.primary,
                      textColor: Colors.white,
                      onPressed: onPayPressed,
                    ),
                  if (showDuePaymentButton)
                    _buildActionButton(
                      text: "Pay Due",
                      color: AppColors.primary,
                      textColor: Colors.white,
                      onPressed: onDuePaymentPressed,
                    ),
                  if (showUpcomingEmiButton)
                    _buildActionButton(
                      text: "Pay EMI",
                      color: AppColors.primary,
                      textColor: Colors.white,
                      onPressed: onUpcomingEmiPressed,
                    ),
                  if (showViewButton) ...[
                    const SizedBox(width: 8),
                    _buildActionButton(
                      text: "View",
                      color: Colors.white,
                      textColor: AppColors.black,
                      onPressed: onViewPressed,
                      hasBorder: true,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback? onPressed,
    bool hasBorder = false,
  }) {
    return SizedBox(
      height: 35,
      width: 75,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          side: hasBorder ? BorderSide(color: Colors.grey.shade300) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}