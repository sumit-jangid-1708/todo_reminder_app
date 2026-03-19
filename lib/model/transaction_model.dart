class Transaction1Model {
  final String amount;
  final String time;
  final bool isGiven; // true if Given (Right), false if Received (Left)

  Transaction1Model({required this.amount, required this.time, required this.isGiven});
}

// lib/model/transaction_model.dart

class GetTransactionsResponseModel {
  final bool success;
  final String message;
  final SummaryModel? summary;
  final List<TransactionModel> data;

  const GetTransactionsResponseModel({
    required this.success,
    required this.message,
    this.summary,
    required this.data,
  });

  factory GetTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetTransactionsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      summary: json['summary'] != null
          ? SummaryModel.fromJson(json['summary'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => TransactionModel.fromJson(e)).toList()
          : [],
    );
  }
}

class SummaryModel {
  final int totalTransactions;
  final double totalAmount;
  final double totalPending;
  final double totalGiven;
  final double totalReceived;

  const SummaryModel({
    required this.totalTransactions,
    required this.totalAmount,
    required this.totalPending,
    required this.totalGiven,
    required this.totalReceived,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      totalTransactions: json['total_transactions'] ?? 0,
      totalAmount: _parseDouble(json['total_amount']),
      totalPending: _parseDouble(json['total_pending']),
      totalGiven: _parseDouble(json['total_given']),
      totalReceived: _parseDouble(json['total_received']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class TransactionModel {
  final int id;
  final int userId;
  final String name;
  final String phone;

  // ✅ Updated fields to match backend
  final String personType;      // "creditor" or "debtor"
  final String transactionType; // "given" or "received"

  final double totalAmount;
  final double pendingAmount;
  final String paymentType;
  final bool isRecurring;
  final double? installmentAmount;
  final String? installmentDate;
  final String date;
  final String? note;
  final String createdAt;
  final String updatedAt;

  const TransactionModel({
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
    required this.date,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',

      // ✅ Updated field mapping
      personType: json['person_type'] ?? json['personType'] ?? '',
      transactionType: json['transaction_type'] ?? json['transactionType'] ?? '',

      totalAmount: _parseDouble(json['total_amount']),
      pendingAmount: _parseDouble(json['pending_amount']),
      paymentType: json['payment_type'] ?? '',
      isRecurring: json['is_recurring'] == true || json['is_recurring'] == 1,
      installmentAmount: json['installment_amount'] != null
          ? _parseDouble(json['installment_amount'])
          : null,
      installmentDate: json['installment_date'],
      date: json['date'] ?? '',
      note: json['note'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

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

  // ✅ Helper getters for UI
  String get displayPersonType {
    return personType == 'creditor' ? 'Creditor' : 'Debtor';
  }

  String get displayTransactionType {
    return transactionType == 'given' ? 'Given ↑' : 'Received ↓';
  }

  String get displayAmount {
    return '₹${pendingAmount.toStringAsFixed(0)}';
  }

  // ✅ Backward compatibility (if old code uses 'type' field)
  String get type => personType;
}