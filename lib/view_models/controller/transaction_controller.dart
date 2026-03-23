import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/model/quick_transaction_response_model.dart';
import 'package:todo_reminder/model/statement_model.dart';
import 'package:todo_reminder/res/components/app_alerts.dart';
import 'package:todo_reminder/view_models/controller/base_controller.dart';
import 'package:todo_reminder/view_models/service/transaction_service.dart';

class TransactionController extends GetxController with BaseController {
  final TransactionService _transactionService = TransactionService();

  // Form Controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // Loading State
  final RxBool isLoading = false.obs;
  final RxBool isLoadingStatement = false.obs;

  // Transaction Data (passed from TransactionScreen)
  String contactName = '';
  String contactPhone = '';
  String personType = '';      // "creditor" or "debtor"
  String transactionType = ''; // "given" or "received"

  // ✅ Statement Data
  final Rx<StatementModel?> statementData = Rx<StatementModel?>(null);

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }

  // ==================== INITIALIZE TRANSACTION DATA ====================

  /// Called when navigating to PaymentScreen
  /// Sets up the transaction data based on which button was clicked
  void initializeTransaction({
    required String name,
    required String phone,
    required String personType,
    required String transactionType,
  }) {
    contactName = name;
    contactPhone = phone;
    this.personType = personType;
    this.transactionType = transactionType;

    print('📝 Transaction initialized:');
    print('   Name: $name');
    print('   Phone: $phone');
    print('   Person Type: $personType');
    print('   Transaction Type: $transactionType');
  }

  // ==================== SET PERSON TYPE ====================

  /// ✅ NEW: Set person type from transaction model
  /// Called when TransactionScreen loads
  void setPersonType(String type) {
    personType = type;
    print('📝 Person type set: $personType');
  }

  // ==================== FETCH STATEMENT ====================

  /// ✅ Fetch transaction statement for contact
  Future<void> fetchStatement(String phone) async {
    try {
      isLoadingStatement.value = true;

      final response = await _transactionService.getStatement<Map<String, dynamic>>(phone);
      final model = StatementModel.fromJson(response);

      if (model.success) {
        statementData.value = model;
        print('✅ Fetched statement: ${model.data.length} date groups');
      } else {
        print('❌ Failed to fetch statement: ${model.message}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoadingStatement.value = false;
    }
  }

  // ==================== QUICK TRANSACTION API ====================

  Future<void> submitQuickTransaction() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {
        "name": contactName,
        "phone": contactPhone,
        "person_type": personType,
        "transaction_type": transactionType,
        "amount": _parseAmount(amountController.text),
        "note": noteController.text.trim(),
      };

      print('📤 Sending quick transaction: $data');

      final response = await _transactionService.quickTransaction<Map<String, dynamic>>(data);
      final model = QuickTransactionResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);
        _clearForm();

        // Go back to TransactionScreen and refresh
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true); // Pass true to indicate success
      } else {
        AppAlerts.error(
          model.message.isNotEmpty ? model.message : 'Failed to add transaction',
        );
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

  // ==================== HELPER METHODS ====================

  double _parseAmount(String amount) {
    final cleaned = amount.replaceAll(RegExp(r'[₹,\s]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  void _clearForm() {
    amountController.clear();
    noteController.clear();
  }

  // ==================== UI HELPERS ====================

  String get actionLabel {
    if (transactionType == 'given') {
      return 'Given ↑';
    } else {
      return 'Received ↓';
    }
  }

  Color get actionColor {
    if (transactionType == 'given') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  // ✅ Get balance display
  String get balanceLabel {
    if (statementData.value == null) return '₹0';

    final balance = statementData.value!.balanceSummary;
    if (personType == 'creditor') {
      return '₹${balance.youWillPay}';
    } else {
      return '₹${balance.youWillReceive}';
    }
  }

  // ✅ FIXED: Check if personType is empty and use statement data as fallback
  String get balanceText {
    // If personType is not set, try to get it from statement data
    String currentPersonType = personType;

    if (currentPersonType.isEmpty && statementData.value != null) {
      currentPersonType = statementData.value!.contact.personType;
    }

    if (currentPersonType == 'creditor') {
      return 'You Will Pay';
    } else {
      return 'You Will Receive';
    }
  }
}