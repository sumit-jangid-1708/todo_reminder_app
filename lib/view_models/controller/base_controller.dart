// lib/view_models/controller/base_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/app_exceptions.dart';
import '../../res/color/app_color.dart';
import '../../res/components/app_dialog.dart';
import '../../res/color/app_color.dart';

mixin BaseController {
  /// Handle errors with proper localization
  void handleError(Object error, {VoidCallback? onRetry}) {
    if (!Get.isRegistered<GetMaterialController>()) return;
    if (Get.isDialogOpen == true) return;
    if (Get.context == null) return;

    String titleKey = 'error';
    String messageKey = 'unknown_error';
    IconData icon = Icons.error_outline_rounded;
    Color color = AppColors.error;

    if (error is AppException) {
      messageKey = error.messageKey;

      if (error is InternetException) {
        titleKey = 'error';
        icon = Icons.wifi_off_rounded;
        color = AppColors.warning;
      } else if (error is ServerException) {
        titleKey = 'error';
        icon = Icons.dns_rounded;
      } else if (error is UnauthorizedException) {
        titleKey = 'error';
        icon = Icons.lock_outline_rounded;
        // Auto logout logic can be added here
      }
    } else {
      messageKey = error.toString();
    }

    Future.microtask(() {
      if (Get.context != null) {
        AppDialog.show(
          titleKey: titleKey,
          messageKey: messageKey,
          icon: icon,
          color: color,
          onConfirm: onRetry,
        );
      }
    });
  }

  /// Handle success messages
  void handleSuccess(String messageKey) {
    if (Get.context == null) return;
    if (Get.isDialogOpen == true) return;

    Future.microtask(() {
      if (Get.context != null) {
        AppDialog.show(
          titleKey: 'success',
          messageKey: messageKey,
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
        );
      }
    });
  }
}