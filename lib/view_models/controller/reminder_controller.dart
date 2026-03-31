// lib/view_models/controller/reminder_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_reminder/view_models/controller/base_controller.dart';
import 'package:todo_reminder/view_models/service/reminder_service.dart';
import '../../model/get_reminder_response_model.dart';
import '../../model/reminder_response_model.dart';
import '../../res/components/app_alerts.dart';

class ReminderController extends GetxController with BaseController {
  final ReminderService _reminderService = ReminderService();

  // Form Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // States
  final RxBool isLoading = false.obs;
  final RxString selectedReminderBefore = "1".obs; // 1 Day Before
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // Reminder Lists
  final RxList<ReminderData> allReminders = <ReminderData>[].obs;
  final RxList<ReminderData> pendingReminders = <ReminderData>[].obs;
  final RxList<ReminderData> completeReminders = <ReminderData>[].obs;

  // Summary
  final Rx<ReminderSummary?> summary = Rx<ReminderSummary?>(null);

  // Get reminders based on status
  List<ReminderData> getTodoReminders() => pendingReminders;
  List<ReminderData> getCompleteReminders() => completeReminders;
  List<ReminderData> getPendingReminders() {
    // Pending = reminders whose date has passed but not complete
    final now = DateTime.now();
    return pendingReminders.where((reminder) {
      final reminderDate = DateTime.parse(reminder.reminderDate);
      return reminderDate.isBefore(now);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllReminders();
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    dateController.dispose();
    notesController.dispose();
    super.onClose();
  }

  // ==================== FETCH ALL REMINDERS ====================

  Future<void> fetchAllReminders({String? status}) async {
    try {
      isLoading.value = true;

      final response = await _reminderService.getAllReminders<Map<String, dynamic>>(
        status: status,
      );
      final model = GetRemindersResponseModel.fromJson(response);

      if (model.success) {
        summary.value = model.summary;
        allReminders.value = model.data;

        // Separate pending and complete
        pendingReminders.value = model.data.where((r) => r.status == 'pending').toList();
        completeReminders.value = model.data.where((r) => r.status == 'complete').toList();

        print('✅ Fetched ${model.data.length} reminders');
        print('Pending: ${pendingReminders.length}');
        print('Complete: ${completeReminders.length}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== CREATE REMINDER ====================

  Future<void> createReminder() async {
    if (!_validateReminderInputs()) return;

    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {
        "title": titleController.text.trim(),
        "amount": int.tryParse(amountController.text.replaceAll(RegExp(r'[₹,\s]'), '')) ?? 0,
        "reminder_date": DateFormat('yyyy-MM-dd').format(selectedDate.value!),
        "reminder_before": int.parse(selectedReminderBefore.value),
        "note": notesController.text.trim(),
      };

      final response = await _reminderService.createReminder<Map<String, dynamic>>(data);
      final model = ReminderResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);
        clearForm();

        // Refresh reminders
        await fetchAllReminders();

        await Future.delayed(const Duration(seconds: 1));
        Get.back();
      } else {
        AppAlerts.error(model.message.isNotEmpty ? model.message : 'Failed to create reminder');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== UPDATE REMINDER ====================

  Future<void> updateReminder(int id) async {
    if (!_validateReminderInputs()) return;

    try {
      isLoading.value = true;

      // Build update data - only send fields that are provided
      final Map<String, dynamic> data = {};

      // Title
      final title = titleController.text.trim();
      if (title.isNotEmpty) {
        data["title"] = title;
      }

      // Amount (required field based on API)
      final amountText = amountController.text.replaceAll(RegExp(r'[₹,\s]'), '');
      final amount = int.tryParse(amountText);
      if (amount != null) {
        data["amount"] = amount;
      }

      // Reminder date
      if (selectedDate.value != null) {
        data["reminder_date"] = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
      }

      // Reminder before
      final reminderBefore = int.tryParse(selectedReminderBefore.value);
      if (reminderBefore != null) {
        data["reminder_before"] = reminderBefore;
      }

      // Note (can be empty)
      data["note"] = notesController.text.trim();

      print('📤 Updating reminder $id with data: $data');

      final response = await _reminderService.updateReminder<Map<String, dynamic>>(id, data);
      final model = ReminderResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);
        clearForm();

        await fetchAllReminders();

        await Future.delayed(const Duration(milliseconds: 500));
        Get.back();
      } else {
        AppAlerts.error(model.message.isNotEmpty ? model.message : 'Failed to update reminder');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== MARK AS COMPLETE ====================

  Future<void> markAsComplete(int id) async {
    try {
      isLoading.value = true;

      final response = await _reminderService.completeReminder<Map<String, dynamic>>(id);
      final model = ReminderResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);
        await fetchAllReminders();
        Get.back(); // Close dialog
      } else {
        AppAlerts.error(model.message.isNotEmpty ? model.message : 'Failed to mark as complete');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== DELETE REMINDER ====================

  Future<void> deleteReminder(int id) async {
    try {
      isLoading.value = true;

      final response = await _reminderService.deleteReminder<Map<String, dynamic>>(id);

      if (response['success'] == true) {
        AppAlerts.success(response['message'] ?? 'Reminder deleted successfully');
        await fetchAllReminders();
        Get.back(); // Close dialog
      } else {
        AppAlerts.error(response['message'] ?? 'Failed to delete reminder');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== DATE PICKER ====================

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      selectedDate.value = picked;
      dateController.text = DateFormat('dd MMMM yyyy').format(picked);
    }
  }

  // ==================== VALIDATION ====================

  bool _validateReminderInputs() {
    final title = titleController.text.trim();
    final amount = amountController.text.trim();

    if (title.isEmpty) {
      AppAlerts.error('Please enter reminder title');
      return false;
    }

    if (amount.isEmpty) {
      AppAlerts.error('Please enter amount');
      return false;
    }

    if (selectedDate.value == null) {
      AppAlerts.error('Please select reminder date');
      return false;
    }

    return true;
  }

  void clearForm() {
    titleController.clear();
    amountController.clear();
    dateController.clear();
    notesController.clear();
    selectedDate.value = null;
    selectedReminderBefore.value = "1";
  }

  // ==================== LOAD REMINDER FOR EDIT ====================

  void loadReminderForEdit(ReminderData reminder) {
    print('📝 Loading reminder for edit: ${reminder.id}');
    print('Title: ${reminder.title}');
    print('Amount: ${reminder.amount}');
    print('Date: ${reminder.reminderDate}');
    print('Note: ${reminder.note}');
    print('Reminder Before: ${reminder.reminderBefore}');

    titleController.text = reminder.title;
    amountController.text = reminder.amount.toString();

    try {
      selectedDate.value = DateTime.parse(reminder.reminderDate);
      dateController.text = DateFormat('dd MMMM yyyy').format(DateTime.parse(reminder.reminderDate));
    } catch (e) {
      print('❌ Error parsing date: $e');
    }

    notesController.text = reminder.note;
    selectedReminderBefore.value = reminder.reminderBefore.toString();

    print('✅ Reminder loaded for editing');
  }
}