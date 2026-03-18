// lib/res/components/app_alerts.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../color/app_color.dart';
import '../color/app_color.dart';

abstract final class AppAlerts {
  static void error(String messageKey) {
    if (Get.isDialogOpen ?? false) Get.back();

    Get.snackbar(
      'error'.tr,
      messageKey.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: AppColors.white),
    );
  }

  static void success(String messageKey) {
    if (Get.isDialogOpen ?? false) Get.back();

    Get.snackbar(
      'success'.tr,
      messageKey.tr,
      backgroundColor: AppColors.success,
      snackPosition: SnackPosition.TOP,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle_outline, color: AppColors.white),
    );
  }

  static void info(String messageKey) {
    Get.snackbar(
      'info'.tr,
      messageKey.tr,
      backgroundColor: AppColors.info,
      snackPosition: SnackPosition.TOP,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      icon: const Icon(Icons.info_outline, color: AppColors.white),
    );
  }

  static void warning(String messageKey) {
    Get.snackbar(
      'warning'.tr,
      messageKey.tr,
      backgroundColor: AppColors.warning,
      snackPosition: SnackPosition.TOP,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      icon: const Icon(Icons.warning_amber_outlined, color: AppColors.white),
    );
  }
}