// lib/view_models/service/reminder_service.dart

import 'package:todo_reminder/data/network/network_api_service.dart';
import '../../res/app_url/app_url.dart';

class ReminderService {
  final NetworkApiService _apiService = NetworkApiService();

  /// Create Reminder
  Future<T> createReminder<T>(Map<String, dynamic> data) async {
    return await _apiService.postApi<T>(
      AppUrl.reminders,
      data,
    );
  }

  /// Get All Reminders (with optional status filter)
  Future<T> getAllReminders<T>({String? status}) async {
    String url = AppUrl.reminders;
    if (status != null && status.isNotEmpty) {
      url = '$url?status=$status';
    }
    return await _apiService.getApi<T>(url);
  }

  /// Get Single Reminder
  Future<T> getReminderById<T>(int id) async {
    return await _apiService.getApi<T>(
      AppUrl.getReminderById(id),
    );
  }

  /// Update Reminder
  Future<T> updateReminder<T>(int id, Map<String, dynamic> data) async {
    return await _apiService.putApi<T>(
      AppUrl.updateReminder(id),
      data,
    );
  }

  /// Mark Reminder as Complete
  Future<T> completeReminder<T>(int id) async {
    return await _apiService.postApi<T>(
      AppUrl.completeReminder(id),
      {},
    );
  }

  /// Delete Reminder
  Future<T> deleteReminder<T>(int id) async {
    return await _apiService.deleteApi<T>(
      AppUrl.deleteReminder(id),
    );
  }
}