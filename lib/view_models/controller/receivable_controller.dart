// lib/view_models/controller/receivable_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import 'package:todo_reminder/view_models/controller/base_controller.dart';
import 'package:todo_reminder/view_models/service/transaction_service.dart';

import '../../model/receivable_model.dart';

class ReceivableController extends GetxController with BaseController {
  final TransactionService _transactionService = TransactionService();

  // Loading State
  final RxBool isLoading = false.obs;

  // Data
  final Rx<ReceivableResponseModel?> receivableData = Rx<ReceivableResponseModel?>(null);
  final RxList<ReceivableData> filteredList = <ReceivableData>[].obs;

  // Search
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Filter Tabs
  final RxInt selectedTab = 0.obs;
  final List<String> tabFilters = ['all', 'due_payment', 'upcoming_emi'];

  @override
  void onInit() {
    super.onInit();

    // Listen to search changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _applySearchFilter();
    });

    // Fetch initial data
    fetchReceivables();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ==================== FETCH RECEIVABLES ====================

  Future<void> fetchReceivables() async {
    try {
      isLoading.value = true;

      final filter = tabFilters[selectedTab.value];
      print('📥 Fetching receivables with filter: $filter');

      final response = await _transactionService.getReceivables<Map<String, dynamic>>(filter);
      final model = ReceivableResponseModel.fromJson(response);

      if (model.success) {
        receivableData.value = model;
        filteredList.value = model.data;
        _applySearchFilter();
        print('✅ Fetched ${model.data.length} receivables');
      } else {
        print('❌ Failed to fetch receivables: ${model.message}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== FILTER ====================

  void changeTab(int index) {
    selectedTab.value = index;
    fetchReceivables(); // Fetch new data based on filter
  }

  // ==================== SEARCH ====================

  void _applySearchFilter() {
    if (receivableData.value == null) return;

    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredList.value = receivableData.value!.data;
    } else {
      filteredList.value = receivableData.value!.data.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.phone.contains(query);
      }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _applySearchFilter();
  }

  // ==================== NAVIGATION ====================

  void navigateToTransaction(ReceivableData data) {
    // Navigate to TransactionScreen with receivable data
    Get.toNamed(
      RouteName.transactionScreen,
      arguments: {
        'transaction': {
          'name': data.name,
          'phone': data.phone,
          'personType': 'debtor', // Receivable = Debtor
          'pendingAmount': data.totalPending,
        },
      },
    );
  }

  // ==================== UI HELPERS ====================

  String get totalReceivable {
    if (receivableData.value == null) return '₹0';
    return '₹${receivableData.value!.summary.totalReceivable.toStringAsFixed(0)}';
  }

  int get totalPeople {
    return receivableData.value?.summary.totalPeople ?? 0;
  }
}