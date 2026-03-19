// lib/model/quick_transaction_response_model.dart

class QuickTransactionResponseModel {
  final bool success;
  final String message;
  final QuickTransactionData? transaction;
  final QuickContactData? contact;

  const QuickTransactionResponseModel({
    required this.success,
    required this.message,
    this.transaction,
    this.contact,
  });

  factory QuickTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return QuickTransactionResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      transaction: json['transaction'] != null
          ? QuickTransactionData.fromJson(json['transaction'])
          : null,
      contact: json['contact'] != null
          ? QuickContactData.fromJson(json['contact'])
          : null,
    );
  }
}

class QuickTransactionData {
  final int id;
  final String personType;
  final String transactionType;
  final String direction;
  final String arrow;
  final double amount;
  final String date;
  final String time;

  const QuickTransactionData({
    required this.id,
    required this.personType,
    required this.transactionType,
    required this.direction,
    required this.arrow,
    required this.amount,
    required this.date,
    required this.time,
  });

  factory QuickTransactionData.fromJson(Map<String, dynamic> json) {
    return QuickTransactionData(
      id: json['id'] ?? 0,
      personType: json['person_type'] ?? '',
      transactionType: json['transaction_type'] ?? '',
      direction: json['direction'] ?? '',
      arrow: json['arrow'] ?? '',
      amount: _parseDouble(json['amount']),
      date: json['date'] ?? '',
      time: json['time'] ?? '',
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

class QuickContactData {
  final String name;
  final String phone;
  final String personType;
  final double totalGiven;
  final double totalReceived;
  final double pendingAmount;
  final String balanceLabel;
  final String balanceType;

  const QuickContactData({
    required this.name,
    required this.phone,
    required this.personType,
    required this.totalGiven,
    required this.totalReceived,
    required this.pendingAmount,
    required this.balanceLabel,
    required this.balanceType,
  });

  factory QuickContactData.fromJson(Map<String, dynamic> json) {
    return QuickContactData(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      personType: json['person_type'] ?? '',
      totalGiven: _parseDouble(json['total_given']),
      totalReceived: _parseDouble(json['total_received']),
      pendingAmount: _parseDouble(json['pending_amount']),
      balanceLabel: json['balance_label'] ?? '',
      balanceType: json['balance_type'] ?? '',
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