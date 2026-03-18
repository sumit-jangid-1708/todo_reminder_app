// lib/model/reminder_models/get_reminders_response_model.dart

import 'reminder_response_model.dart';

class GetRemindersResponseModel {
  final bool success;
  final String message;
  final ReminderSummary summary;
  final List<ReminderData> data;

  const GetRemindersResponseModel({
    required this.success,
    required this.message,
    required this.summary,
    required this.data,
  });

  factory GetRemindersResponseModel.fromJson(Map<String, dynamic> json) {
    return GetRemindersResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      summary: ReminderSummary.fromJson(json['summary'] ?? {}),
      data: List<ReminderData>.from(
        (json['data'] ?? []).map((x) => ReminderData.fromJson(x)),
      ),
    );
  }
}

class ReminderSummary {
  final int total;
  final int pending;
  final int complete;

  const ReminderSummary({
    required this.total,
    required this.pending,
    required this.complete,
  });

  factory ReminderSummary.fromJson(Map<String, dynamic> json) {
    return ReminderSummary(
      total: json['total'] ?? 0,
      pending: json['pending'] ?? 0,
      complete: json['complete'] ?? 0,
    );
  }
}