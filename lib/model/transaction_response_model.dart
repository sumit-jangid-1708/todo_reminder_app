// lib/model/transaction_models/transaction_response_model.dart

import 'package:intl/intl.dart'; // optional, agar date formatting chahiye to

class TransactionResponseModel {
  final bool success;
  final String message;
  final TransactionData? data;

  const TransactionResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? TransactionData.fromJson(json['data']) : null,
    );
  }
}

class TransactionData {
  final int id;
  final int userId;
  final String name;
  final String phone;

  // Naye fields API ke hisaab se
  final String personType;      // "creditor" or "debtor"
  final String transactionType; // "received" or "given" (jo bhi backend bhej raha hai)

  final double totalAmount;
  final double pendingAmount;
  final String paymentType;     // "to_pay" or "to_receive"

  final bool isRecurring;
  final double? installmentAmount;
  final String? installmentDate;
  final String? date;
  final String? note;

  final String createdAt;
  final String updatedAt;

  const TransactionData({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.personType,
    required this.transactionType,
    required this.totalAmount,
    required this.pendingAmount,
    required this.paymentType,
    required this.isRecurring,
    this.installmentAmount,
    this.installmentDate,
    this.date,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',

      // Updated fields
      personType: json['person_type'] ?? '',
      transactionType: json['transaction_type'] ?? '',

      totalAmount: _parseDouble(json['total_amount']),
      pendingAmount: _parseDouble(json['pending_amount']),
      paymentType: json['payment_type'] ?? '',

      isRecurring: json['is_recurring'] == true || json['is_recurring'] == 1,

      installmentAmount: json['installment_amount'] != null
          ? _parseDouble(json['installment_amount'])
          : null,
      installmentDate: json['installment_date'],
      date: json['date'],
      note: json['note'],

      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  /// Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Optional: Formatted dates
  String get formattedDate {
    if (date == null || date!.isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(date!);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return date!;
    }
  }

  String get formattedCreatedAt {
    try {
      final dt = DateTime.parse(createdAt);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      return createdAt;
    }
  }

  /// Convert to Map (for local storage, Hive, etc.)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'person_type': personType,
      'transaction_type': transactionType,
      'total_amount': totalAmount,
      'pending_amount': pendingAmount,
      'payment_type': paymentType,
      'is_recurring': isRecurring,
      'installment_amount': installmentAmount,
      'installment_date': installmentDate,
      'date': date,
      'note': note,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}