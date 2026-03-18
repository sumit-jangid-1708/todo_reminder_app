// lib/res/components/widgets/tab_button.dart

import 'package:flutter/material.dart';
import 'package:todo_reminder/res/color/app_color.dart';

class TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Image ke hisaab se horizontal padding zyada di hai
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          // Pill shape ke liye circular radius 25+ rakha hai
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : const Color(0xFFE0E0E0), // Subtle light gray border
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.white : const Color(0xFF424242),
          ),
        ),
      ),
    );
  }
}