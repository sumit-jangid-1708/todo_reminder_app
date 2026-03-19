class StatementModel {
  final bool success;
  final String message;
  final Contact contact;
  final String filter;
  final BalanceSummary balanceSummary;
  final List<StatementDateData> data;

  StatementModel({
    required this.success,
    required this.message,
    required this.contact,
    required this.filter,
    required this.balanceSummary,
    required this.data,
  });

  factory StatementModel.fromJson(Map<String, dynamic> json) {
    return StatementModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      contact: Contact.fromJson(json['contact'] ?? {}),
      filter: json['filter'] ?? '',
      balanceSummary:
      BalanceSummary.fromJson(json['balance_summary'] ?? {}),
      data: (json['data'] as List? ?? [])
          .map((e) => StatementDateData.fromJson(e))
          .toList(),
    );
  }
}


class Contact {
  final String name;
  final String phone;
  final String personType;

  Contact({
    required this.name,
    required this.phone,
    required this.personType,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      personType: json['person_type'] ?? '',
    );
  }
}

class BalanceSummary {
  final int youWillReceive;
  final int youWillPay;

  BalanceSummary({
    required this.youWillReceive,
    required this.youWillPay,
  });

  factory BalanceSummary.fromJson(Map<String, dynamic> json) {
    return BalanceSummary(
      youWillReceive: json['you_will_receive'] ?? 0,
      youWillPay: json['you_will_pay'] ?? 0,
    );
  }
}

class StatementDateData {
  final String date;
  final List<TransactionModel> transactions;

  StatementDateData({
    required this.date,
    required this.transactions,
  });

  factory StatementDateData.fromJson(Map<String, dynamic> json) {
    return StatementDateData(
      date: json['date'] ?? '',
      transactions: (json['transactions'] as List? ?? [])
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
    );
  }
}

class TransactionModel {
  final int id;
  final String transactionType;
  final String direction;
  final String arrow;
  final int totalAmount;
  final int pendingAmount;
  final String note;
  final String time;

  TransactionModel({
    required this.id,
    required this.transactionType,
    required this.direction,
    required this.arrow,
    required this.totalAmount,
    required this.pendingAmount,
    required this.note,
    required this.time,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      transactionType: json['transaction_type'] ?? '',
      direction: json['direction'] ?? '',
      arrow: json['arrow'] ?? '',
      totalAmount: json['total_amount'] ?? 0,
      pendingAmount: json['pending_amount'] ?? 0,
      note: json['note'] ?? '',
      time: json['time'] ?? '',
    );
  }
}
