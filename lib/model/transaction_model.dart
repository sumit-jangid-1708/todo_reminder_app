class Transaction1Model {
  final String amount;
  final String time;
  final bool isGiven; // true if Given (Right), false if Received (Left)

  Transaction1Model({required this.amount, required this.time, required this.isGiven});
}

class GetTransactionsResponseModel {
  final bool success;
  final String message;
  final SummaryModel summary;
  final List<TransactionModel> data;

  GetTransactionsResponseModel({
    required this.success,
    required this.message,
    required this.summary,
    required this.data,
  });

  factory GetTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetTransactionsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      summary: SummaryModel.fromJson(json['summary'] ?? {}),
      data: List<TransactionModel>.from(
        (json['data'] ?? []).map(
              (x) => TransactionModel.fromJson(x),
        ),
      ),
    );
  }
}

class SummaryModel {
  final int totalTransactions;
  final int totalAmount;
  final int totalPending;

  SummaryModel({
    required this.totalTransactions,
    required this.totalAmount,
    required this.totalPending,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      totalTransactions: json['total_transactions'] ?? 0,
      totalAmount: json['total_amount'] ?? 0,
      totalPending: json['total_pending'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_transactions': totalTransactions,
      'total_amount': totalAmount,
      'total_pending': totalPending,
    };
  }
}

class TransactionModel {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String type;
  final int totalAmount;
  final int pendingAmount;
  final String paymentType;
  final bool isRecurring;
  final int installmentAmount;
  final String installmentDate;
  final String date;
  final String note;
  final String createdAt;
  final String updatedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.type,
    required this.totalAmount,
    required this.pendingAmount,
    required this.paymentType,
    required this.isRecurring,
    required this.installmentAmount,
    required this.installmentDate,
    required this.date,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      type: json['type'] ?? '',
      totalAmount: json['total_amount'] ?? 0,
      pendingAmount: json['pending_amount'] ?? 0,
      paymentType: json['payment_type'] ?? '',
      isRecurring: json['is_recurring'] == true || json['is_recurring'] == 1,
      installmentAmount: json['installment_amount'] ?? 0,
      installmentDate: json['installment_date'] ?? '',
      date: json['date'] ?? '',
      note: json['note'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'type': type,
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