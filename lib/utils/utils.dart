// lib/utils/utils.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract final class Utils {
  /// Change focus between fields
  static void fieldFocusChange(
      BuildContext context,
      FocusNode current,
      FocusNode nextFocus,
      ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  /// Email validation
  static bool isEmailValid(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email.trim());
  }

  /// Show snackbar
  static void snackBar(String titleKey, String messageKey) {
    Get.snackbar(titleKey.tr, messageKey.tr);
  }

  /// Format currency
  static String formatCurrency(double amount, {String symbol = '₹'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Parse double safely
  static double parseDouble(Object? value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}