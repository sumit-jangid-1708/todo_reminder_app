// lib/view_models/service/transaction_service.dart

import 'dart:io';

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

  /// GET — fetch contact profile by phone
  Future<T> getContactProfile<T>(String phone) async {
    return await _apiService
        .getApi<T>("${AppUrl.contactsList}/$phone");
  }

  /// POST (multipart) — update contact profile
  /// Uses the existing [NetworkApiService.multipartApi] which auto-attaches
  /// the Bearer token from TokenStorage.
  Future<T> updateContactProfile<T>({
    required String phone,
    required String name,
    String? address,
    File? avatarFile,
  }) async {
    // Build string fields map (only include address if provided)
    final Map<String, String> fields = {
      'name': name,
      if (address != null && address.isNotEmpty) 'address': address,
    };

    return await _apiService.multipartApi<T>(
      "${AppUrl.contactsList}/$phone",
      fields,
      file: avatarFile,       // null is fine — multipartApi handles it
      fileField: 'avatar',    // matches API field name
    );
  }

  /// DELETE — delete contact and all their transactions
  Future<T> deleteContact<T>(String phone) async {
    return await _apiService
        .deleteApi<T>("${AppUrl.contactsList}/$phone");
  }

}