// lib/model/reminder_models/reminder_response_model.dart

class ReminderResponseModel {
  final bool success;
  final String message;
  final ReminderData? data;

  const ReminderResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ReminderResponseModel.fromJson(Map<String, dynamic> json) {
    return ReminderResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ReminderData.fromJson(json['data']) : null,
    );
  }
}

class ReminderData {
  final int id;
  final int userId;
  final String title;
  final int amount;
  final String reminderDate;
  final int reminderBefore;
  final String note;
  final String status;
  final bool isNotified;
  final String createdAt;
  final String updatedAt;

  const ReminderData({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.reminderDate,
    required this.reminderBefore,
    required this.note,
    required this.status,
    required this.isNotified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReminderData.fromJson(Map<String, dynamic> json) {
    return ReminderData(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      title: json['title'] ?? '',
      amount: int.tryParse(json['amount'].toString()) ?? 0,
      reminderDate: json['reminder_date'] ?? '',
      reminderBefore:
      int.tryParse(json['reminder_before'].toString()) ?? 0,
      note: json['note'] ?? '',
      status: json['status'] ?? 'pending',
      isNotified: json['is_notified'] == true ||
          json['is_notified'] == 1 ||
          json['is_notified'] == "1",
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'reminder_date': reminderDate,
      'reminder_before': reminderBefore,
      'note': note,
      'status': status,
      'is_notified': isNotified,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}