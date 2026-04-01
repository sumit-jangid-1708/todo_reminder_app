// lib/view_models/controller/transaction_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/model/delete_party_response_model.dart';
import 'package:todo_reminder/model/party_profile_model.dart';
import 'package:todo_reminder/model/quick_transaction_response_model.dart';
import 'package:todo_reminder/model/statement_model.dart';
import 'package:todo_reminder/res/components/app_alerts.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import 'package:todo_reminder/view_models/controller/base_controller.dart';
import 'package:todo_reminder/view_models/service/transaction_service.dart';

class TransactionController extends GetxController with BaseController {
  final TransactionService _transactionService = TransactionService();

  // Form Controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingStatement = false.obs;
  final RxBool isLoadingProfile = false.obs;
  final RxBool isSavingProfile = false.obs;
  final RxBool isDeletingContact = false.obs;

  // ✅ contactName is RxString so Obx can observe it and update the AppBar
  //    after a profile save. Other fields stay plain strings — they don't
  //    need to drive reactive UI.
  final RxString contactName = ''.obs;
  String contactPhone = '';
  String personType = '';       // "creditor" | "debtor"
  String transactionType = '';  // "given"    | "received"

  // Observable data
  final Rx<StatementModel?> statementData = Rx<StatementModel?>(null);
  final Rx<PartyProfileModel?> profileData = Rx<PartyProfileModel?>(null);

  // Newly picked avatar file (cleared after a successful save)
  final Rx<File?> selectedAvatarFile = Rx<File?>(null);

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }

  // ==================== TRANSACTION SETUP ====================

  void initializeTransaction({
    required String name,
    required String phone,
    required String personType,
    required String transactionType,
  }) {
    contactName.value = name; // ✅ .value
    contactPhone = phone;
    this.personType = personType;
    this.transactionType = transactionType;
  }

  void setPersonType(String type) {
    personType = type;
  }

  // ==================== STATEMENT ====================

  Future<void> fetchStatement(String phone) async {
    try {
      isLoadingStatement.value = true;

      final response = await _transactionService
          .getStatement<Map<String, dynamic>>(phone);
      final model = StatementModel.fromJson(response);

      if (model.success) {
        statementData.value = model;
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoadingStatement.value = false;
    }
  }

  // ==================== CONTACT PROFILE ====================

  /// Fetch profile data and pre-populate fields
  Future<void> fetchContactProfile(String phone) async {
    try {
      isLoadingProfile.value = true;
      selectedAvatarFile.value = null;

      final response = await _transactionService
          .getContactProfile<Map<String, dynamic>>(phone);

      if (response['success'] == true) {
        profileData.value = PartyProfileModel.fromJson(
            response['data'] as Map<String, dynamic>);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// Update profile — uses multipartApi under the hood
  Future<void> updateContactProfile({
    required String phone,
    required String name,
    String? address,
    File? avatarFile,
  }) async {
    if (name.trim().isEmpty) {
      AppAlerts.error('Name cannot be empty');
      return;
    }

    try {
      isSavingProfile.value = true;

      final response = await _transactionService
          .updateContactProfile<Map<String, dynamic>>(
        phone: phone,
        name: name.trim(),
        address: address,
        avatarFile: avatarFile,
      );

      if (response['success'] == true) {
        profileData.value = PartyProfileModel.fromJson(
            response['data'] as Map<String, dynamic>);

        // ✅ Update RxString → AppBar in TransactionScreen rebuilds automatically
        contactName.value = profileData.value!.name;

        selectedAvatarFile.value = null;

        AppAlerts.success(
            response['message'] ?? 'Profile updated successfully');

        Get.back();
      } else {
        AppAlerts.error(
            response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isSavingProfile.value = false;
    }
  }

  /// Delete contact + all transactions → navigate to HomeScreen
  Future<void> deleteContact(String phone) async {
    try {
      isDeletingContact.value = true;

      final response = await _transactionService
          .deleteContact<Map<String, dynamic>>(phone);
      final model = DeletePartyResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(RouteName.homeScreen);
      } else {
        AppAlerts.error(model.message);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isDeletingContact.value = false;
    }
  }

  // ==================== QUICK TRANSACTION ====================

  Future<void> submitQuickTransaction() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {
        "name": contactName.value, // ✅ .value
        "phone": contactPhone,
        "person_type": personType,
        "transaction_type": transactionType,
        "amount": _parseAmount(amountController.text),
        "note": noteController.text.trim(),
      };

      final response = await _transactionService
          .quickTransaction<Map<String, dynamic>>(data);
      final model = QuickTransactionResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);
        _clearForm();
        // await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true);
      } else {
        AppAlerts.error(model.message.isNotEmpty
            ? model.message
            : 'Failed to add transaction');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== VALIDATION ====================

  bool _validateInputs() {
    final amount = amountController.text.trim();
    if (amount.isEmpty) {
      AppAlerts.error('Please enter amount');
      return false;
    }
    if (_parseAmount(amount) <= 0) {
      AppAlerts.error('Amount must be greater than 0');
      return false;
    }
    return true;
  }

  // ==================== HELPERS ====================

  double _parseAmount(String amount) {
    final cleaned = amount.replaceAll(RegExp(r'[₹,\s]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  void _clearForm() {
    amountController.clear();
    noteController.clear();
  }

  // ==================== UI COMPUTED PROPS ====================

  String get actionLabel =>
      transactionType == 'given' ? 'Given ↑' : 'Received ↓';

  Color get actionColor =>
      transactionType == 'given' ? Colors.red : Colors.green;

  String get balanceLabel {
    if (statementData.value == null) return '₹0';
    final balance = statementData.value!.balanceSummary;
    return personType == 'creditor'
        ? '₹${balance.youWillPay}'
        : '₹${balance.youWillReceive}';
  }

  String get balanceText {
    String current = personType;
    if (current.isEmpty && statementData.value != null) {
      current = statementData.value!.contact.personType;
    }
    return current == 'creditor' ? 'You Will Pay' : 'You Will Receive';
  }
}