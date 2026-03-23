// lib/view_models/service/transaction_service.dart

import 'package:todo_reminder/data/network/network_api_service.dart';
import 'package:todo_reminder/res/app_url/app_url.dart';

class TransactionService {
  final NetworkApiService _apiService = NetworkApiService();

  /// Quick Transaction
  Future<T> quickTransaction<T>(Map<String, dynamic> data) async {
    return await _apiService.postApi<T>(AppUrl.quickTransaction, data);
  }

  /// Get Statement
  Future<T> getStatement<T>(String contactPhone) async {
    return await _apiService.getApi<T>("${AppUrl.statements}/$contactPhone/statement/");
  }

  /// ✅ Get Receivables with filter
  Future<T> getReceivables<T>(String filter) async {
    return await _apiService.getApi<T>("${AppUrl.receivables}?filter=$filter");
  }

  /// ✅ Get Payables with filter
  Future<T> getPayables<T>(String filter) async {
    return await _apiService.getApi<T>("${AppUrl.payables}?filter=$filter");
  }
}