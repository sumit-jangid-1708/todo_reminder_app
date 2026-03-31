// lib/view_models/controller/home_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/models/permissions/permission_type.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as PermissionType;
import 'package:intl/intl.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import 'package:todo_reminder/view_models/controller/reminder_controller.dart';
import 'package:todo_reminder/view_models/service/home_service.dart';
import '../../data/storage/token_storage.dart';
import '../../model/contact_model.dart';
import '../../model/transaction_model.dart';
import '../../model/transaction_response_model.dart';
import '../../notification_service.dart';
import '../../res/components/app_alerts.dart';
import 'base_controller.dart';

class HomeController extends GetxController with BaseController {
  final HomeService _homeService = HomeService();

  var selectedTab = 0.obs;
  var selectedFilter = "Payable".obs;
  var isCreditor = true.obs;

  // ✅ Contacts Lists (Changed from Transaction to Contact)
  final RxList<ContactModel> creditorsList = <ContactModel>[].obs;
  final RxList<ContactModel> debitorsList = <ContactModel>[].obs;

  // ✅ Check if lists are empty
  bool get hasTransactions {
    if (isCreditor.value) {
      return creditorsList.isNotEmpty;
    } else {
      return debitorsList.isNotEmpty;
    }
  }

  // ✅ Get current list based on selection
  List<ContactModel> get currentList {
    if (isCreditor.value) {
      return creditorsList;
    } else {
      return debitorsList;
    }
  }

  // ✅ Dynamic Filters based on Creditor/Debitor
  List<String> get filters {
    if (isCreditor.value) {
      return ["Payable", "Due Payment", "Upcoming due", "Latest"];
    } else {
      return ["Receivable", "Due Payment", "Upcoming due", "Latest"];
    }
  }

  // Form Fields
  var selectedType = "".obs;
  var selectedBalanceType = "".obs;
  var isRecurring = false.obs;

  final fullNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final noteController = TextEditingController();
  final totalAmountController = TextEditingController();
  final pendingAmountController = TextEditingController();
  final installmentController = TextEditingController();
  final installmentDateController = TextEditingController();

  // ✅ Installment Date State
  final Rx<DateTime?> selectedInstallmentDate = Rx<DateTime?>(null);

  // Loading State
  final RxBool isLoading = false.obs;

  void toggleRecurring(bool value) => isRecurring.value = value;

  final GetStorage _storage = GetStorage();
  String get userName => _storage.read('user_name') ?? 'User';

  final RxString weekDay = ''.obs;
  final RxString date = ''.obs;
  final RxString month = ''.obs;
  final RxString year = ''.obs;

  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setCurrentDate();
    // ✅ Load contacts from API
    fetchAllContacts();
    // ✅ Send FCM token on app start (if user is logged in)
    _sendFcmTokenInBackground();

    ever(isCreditor, (_) {
      selectedFilter.value = filters.first;
    });
  }

  @override
  void onClose() {
    fullNameController.dispose();
    mobileNumberController.dispose();
    noteController.dispose();
    totalAmountController.dispose();
    pendingAmountController.dispose();
    installmentController.dispose();
    installmentDateController.dispose();
    super.onClose();
  }

  /// ✅ Send FCM Token in Background
  Future<void> _sendFcmTokenInBackground() async {
    try {
      // Check if user is logged in
      final token = await TokenStorage().getToken();
      if (token != null && token.isNotEmpty) {
        await NotificationService.sendFcmTokenToServer();
      }
    } catch (e) {
      print('Error sending FCM token: $e');
    }
  }

  // ==================== INSTALLMENT DATE PICKER ====================

  /// ✅ Select Installment Date
  Future<void> selectInstallmentDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedInstallmentDate.value ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      selectedInstallmentDate.value = picked;
      installmentDateController.text = DateFormat('dd MMMM yyyy').format(picked);
    }
  }

  // ==================== FETCH ALL CONTACTS ====================

  /// ✅ Fetch contacts from /api/contacts endpoint
  Future<void> fetchAllContacts() async {
    try {
      isLoading.value = true;

      final response = await _homeService.getContacts<Map<String, dynamic>>();
      final model = ContactsModel.fromJson(response);

      if (model.success) {
        // Separate creditors and debtors based on person_type
        creditorsList.clear();
        debitorsList.clear();

        for (var contact in model.data) {
          if (contact.personType.toLowerCase() == 'creditor') {
            creditorsList.add(contact);
          } else if (contact.personType.toLowerCase() == 'debtor') {
            debitorsList.add(contact);
          }
        }

        print('✅ Fetched ${model.data.length} contacts');
        print('Creditors: ${creditorsList.length}');
        print('Debtors: ${debitorsList.length}');
      } else {
        print('❌ Failed to fetch contacts: ${model.message}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== ADD TRANSACTION API ====================

  Future<void> addTransaction() async {
    if (!_validateTransactionInputs()) return;

    try {
      isLoading.value = true;

      // ✅ Determine person_type and transaction_type
      final personType = _getPersonType();
      final transactionType = _getTransactionType();

      // Prepare data
      final Map<String, dynamic> data = {
        // ✅ Updated fields
        "person_type": personType,           // "creditor" or "debtor"
        "transaction_type": transactionType, // "given" or "received"

        "name": fullNameController.text.trim(),
        "phone": mobileNumberController.text.trim(),
        "total_amount": _parseAmount(totalAmountController.text),
        "pending_amount": _parseAmount(pendingAmountController.text),
        "payment_type": _getPaymentType(),
        "is_recurring": isRecurring.value,
        "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };

      // ✅ Add installment fields if recurring is enabled
      if (isRecurring.value) {
        if (installmentController.text.isNotEmpty) {
          data["installment_amount"] = _parseAmount(installmentController.text);
        }

        // ✅ Use selected date or default to next month
        if (selectedInstallmentDate.value != null) {
          data["installment_date"] = DateFormat('yyyy-MM-dd').format(selectedInstallmentDate.value!);
        } else {
          final nextMonth = DateTime.now().add(const Duration(days: 30));
          data["installment_date"] = DateFormat('yyyy-MM-dd').format(nextMonth);
        }
      }

      if (noteController.text.isNotEmpty) {
        data["note"] = noteController.text.trim();
      }

      print('📤 Sending transaction data: $data');

      // Call API
      final response = await _homeService.addTransaction<Map<String, dynamic>>(data);
      final model = TransactionResponseModel.fromJson(response);

      if (model.success) {
        AppAlerts.success(model.message);
        _clearTransactionForm();

        // ✅ Refresh contacts from API
        await fetchAllContacts();

        await Future.delayed(const Duration(seconds: 1));
        Get.back();
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

  bool _validateTransactionInputs() {
    final name = fullNameController.text.trim();
    final phone = mobileNumberController.text.trim();
    final pendingAmount = pendingAmountController.text.trim();

    if (selectedType.value.isEmpty) {
      AppAlerts.error('Please select transaction type (Debtor/Creditor)');
      return false;
    }

    if (name.isEmpty) {
      AppAlerts.error('Please enter full name');
      return false;
    }

    if (name.length < 2) {
      AppAlerts.error('Name must be at least 2 characters');
      return false;
    }

    if (phone.isEmpty) {
      AppAlerts.error('Please enter mobile number');
      return false;
    }

    if (phone.length < 10) {
      AppAlerts.error('Mobile number must be at least 10 digits');
      return false;
    }

    if (pendingAmount.isEmpty) {
      AppAlerts.error('Please enter pending amount');
      return false;
    }

    if (_parseAmount(pendingAmount) <= 0) {
      AppAlerts.error('Pending amount must be greater than 0');
      return false;
    }

    if (selectedBalanceType.value.isEmpty) {
      AppAlerts.error('Please select balance type (To Pay/To Receive)');
      return false;
    }

    // ✅ Validate installment fields if recurring is enabled
    if (isRecurring.value) {
      if (installmentController.text.isEmpty) {
        AppAlerts.error('Please enter installment amount for recurring payment');
        return false;
      }

      if (_parseAmount(installmentController.text) <= 0) {
        AppAlerts.error('Installment amount must be greater than 0');
        return false;
      }
    }

    return true;
  }

  // ==================== HELPER METHODS ====================

  /// ✅ Get person_type from selectedType
  /// Returns: "creditor" or "debtor"
  String _getPersonType() {
    return selectedType.value.toLowerCase(); // "Creditor" -> "creditor"
  }

  /// ✅ Determine transaction_type based on person_type
  /// Logic:
  /// - Creditor (lendhar) + Opening Balance = received (liya hai)
  /// - Debtor (dendhar) + Opening Balance = given (diya hai)
  String _getTransactionType() {
    final personType = _getPersonType();

    if (personType == "creditor") {
      // Creditor se liya hai (opening balance)
      return "received";
    } else {
      // Debtor ko diya hai (opening balance)
      return "given";
    }
  }

  /// ✅ Get payment_type from selectedBalanceType
  String _getPaymentType() {
    if (selectedBalanceType.value == "To Pay") {
      return "to_pay";
    } else {
      return "to_receive";
    }
  }

  double _parseAmount(String amount) {
    final cleaned = amount.replaceAll(RegExp(r'[₹,\s]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  void _clearTransactionForm() {
    fullNameController.clear();
    mobileNumberController.clear();
    noteController.clear();
    totalAmountController.clear();
    pendingAmountController.clear();
    installmentController.clear();
    installmentDateController.clear();
    selectedType.value = "";
    selectedBalanceType.value = "";
    isRecurring.value = false;
    selectedInstallmentDate.value = null;
  }

  // ==================== CONTACT PICKER ====================

  // Future<Map<String, String>?> pickContact() async {
  //   final status = await FlutterContacts.permissions.request(PermissionType.read);

  //   if (status != PermissionStatus.granted) {
  //     return null;
  //   }

  //   final String? contactId = await FlutterContacts.native.showPicker();

  //   if (contactId == null) return null;

  //   final Contact? contact = await FlutterContacts.get(
  //     contactId,
  //     properties: {
  //       ContactProperty.name,
  //       ContactProperty.phone,
  //     },
  //   );

  //   if (contact == null) return null;

  //   String? name = contact.displayName;

  //   String number = "";
  //   if (contact.phones.isNotEmpty) {
  //     number = contact.phones.first.number;
  //     number = number.replaceAll(RegExp(r'[^0-9]'), '');

  //     if (number.startsWith("91") && number.length > 10) {
  //       number = number.substring(number.length - 10);
  //     }

  //     if (number.length > 10) {
  //       number = number.substring(number.length - 10);
  //     }
  //   }

  //   return {
  //     "name": name ?? "",
  //     "number": number,
  //   };
  // }

  void _setCurrentDate() {
    final now = DateTime.now();
    weekDay.value = DateFormat('EEE').format(now);
    date.value = DateFormat('d').format(now);
    month.value = DateFormat('MMMM').format(now);
    year.value = DateFormat('yyyy').format(now);
  }

  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;
      _setCurrentDate();
      // ✅ Fetch contacts from API
      await fetchAllContacts();
      // ✅ Also refresh reminders
      final reminderController = Get.find<ReminderController>();
      await reminderController.fetchAllReminders();
    } catch (e) {
      print('Refresh error: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  void onFilterChipTap(String filterName) {
    selectedFilter.value = filterName;

    if (isCreditor.value) {
      _navigateCreditorScreen(filterName);
    } else {
      _navigateDebitorScreen(filterName);
    }
  }

  void _navigateCreditorScreen(String filterName) {
    switch (filterName) {
      case "Payable":
        Get.toNamed(RouteName.payableScreen);
        break;
      case "Due Payment":
        Get.toNamed(RouteName.payableScreen, arguments: {"tab": 1});
        break;
      case "Upcoming due":
        Get.toNamed(RouteName.payableScreen, arguments: {"tab": 2});
        break;
      case "Latest":
        Get.toNamed(RouteName.payableScreen);
        break;
    }
  }

  void _navigateDebitorScreen(String filterName) {
    switch (filterName) {
      case "Receivable":
        Get.toNamed(RouteName.receivableScreen);
        break;
      case "Due Payment":
        Get.toNamed(RouteName.receivableScreen, arguments: {"tab": 1});
        break;
      case "Upcoming due":
        Get.toNamed(RouteName.receivableScreen, arguments: {"tab": 2});
        break;
      case "Latest":
        Get.toNamed(RouteName.receivableScreen);
        break;
    }
  }

  // ==================== CONTACT TAP (Navigate to Transaction Screen) ====================

  /// ✅ Navigate to Transaction Screen with contact data
  void onContactTap(ContactModel contact) {
    // Convert ContactModel to TransactionModel for navigation
    final transactionModel = TransactionModel(
      id: 0, // Not needed for display
      userId: 0, // Not needed for display
      name: contact.name,
      phone: contact.phone,
      personType: contact.personType,
      transactionType: '', // Not needed for transaction screen display
      totalAmount: 0.0, // Not needed for display
      pendingAmount: contact.pendingAmount.toDouble(),
      paymentType: contact.balanceType == 'you_will_pay' ? 'to_pay' : 'to_receive',
      isRecurring: false,
      installmentAmount: null,
      installmentDate: null,
      date: DateTime.now().toString(),
      note: null,
      createdAt: contact.lastTransaction,
      updatedAt: contact.lastTransaction,
    );

    Get.toNamed(
      RouteName.transactionScreen,
      arguments: {
        'transaction': transactionModel,
      },
    );
  }
}


// @override
// void onInit() {
//   super.onInit();
//   _setCurrentDate();
//   // ✅ Load transactions from API
//   fetchAllTransactions();
//   // ✅ Send FCM token on app start (if user is logged in)
//   _sendFcmTokenInBackground();
//
//   ever(isCreditor, (_) {
//     selectedFilter.value = filters.first;
//   });
// }
// Future<void> fetchAllTransactions() async {
//   try {
//     isLoading.value = true;
//
//     final response = await _homeService.getAllTransactions<Map<String, dynamic>>();
//     final model = GetTransactionsResponseModel.fromJson(response);
//
//     if (model.success) {
//       // Save summary
//       summary.value = model.summary;
//
//       // Separate creditors and debitors based on person_type
//       creditorsList.clear();
//       debitorsList.clear();
//
//       for (var transaction in model.data) {
//         // ✅ Updated to use person_type instead of type
//         if (transaction.personType.toLowerCase() == 'creditor') {
//           creditorsList.add(transaction);
//         } else if (transaction.personType.toLowerCase() == 'debtor') {
//           debitorsList.add(transaction);
//         }
//       }
//
//       print('✅ Fetched ${model.data.length} transactions');
//       print('Creditors: ${creditorsList.length}');
//       print('Debitors: ${debitorsList.length}');
//     } else {
//       print('❌ Failed to fetch transactions: ${model.message}');
//     }
//   } catch (e) {
//     handleError(e);
//   } finally {
//     isLoading.value = false;
//   }
// }

// Future<void> refreshData() async {
//   try {
//     isRefreshing.value = true;
//     _setCurrentDate();
//     // ✅ Fetch transactions from API
//     await fetchAllTransactions();
//     // ✅ Also refresh reminders
//     final reminderController = Get.find<ReminderController>();
//     await reminderController.fetchAllReminders();
//   } catch (e) {
//     print('Refresh error: $e');
//   } finally {
//     isRefreshing.value = false;
//   }
// }