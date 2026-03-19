// lib/model/transaction_models/payable_model.dart

class PayableResponseModel {
  final bool success;
  final String message;
  final PayableSummary summary;
  final List<PayableData> data;

  const PayableResponseModel({
    required this.success,
    required this.message,
    required this.summary,
    required this.data,
  });

  factory PayableResponseModel.fromJson(Map<String, dynamic> json) {
    return PayableResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      summary: PayableSummary.fromJson(json['summary'] ?? {}),
      data: json['data'] != null
          ? (json['data'] as List)
          .map((item) => PayableData.fromJson(item))
          .toList()
          : [],
    );
  }
}

// ==================== Summary ====================
class PayableSummary {
  final double totalPayable;
  final int totalPeople;

  const PayableSummary({
    required this.totalPayable,
    required this.totalPeople,
  });

  factory PayableSummary.fromJson(Map<String, dynamic> json) {
    return PayableSummary(
      totalPayable: _parseDouble(json['total_payable']),
      totalPeople: json['total_people'] ?? 0,
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

// ==================== Data ====================
class PayableData {
  final String name;
  final String phone;
  final double totalPending;
  final String? upcomingDue;
  final String dueStatus;

  const PayableData({
    required this.name,
    required this.phone,
    required this.totalPending,
    this.upcomingDue,
    required this.dueStatus,
  });

  factory PayableData.fromJson(Map<String, dynamic> json) {
    return PayableData(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      totalPending: _parseDouble(json['total_pending']),
      upcomingDue: json['upcoming_due'],
      dueStatus: json['due_status'] ?? 'no_due',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Formatted Amount (₹1,00,000)
  String get formattedPending {
    return "₹${totalPending.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    )}";
  }

  /// Due Status ke hisaab se readable text
  String get dueStatusText {
    switch (dueStatus.toLowerCase()) {
      case 'overdue':
        return 'Overdue';
      case 'due_soon':
        return 'Due Soon';
      case 'no_due':
        return 'No Due';
      default:
        return 'No Due';
    }
  }

/// Optional: Due status ke hisaab se color (Flutter mein use karne ke liye)
// Color get dueStatusColor {
//   switch (dueStatus.toLowerCase()) {
//     case 'overdue': return Colors.red;
//     case 'due_soon': return Colors.orange;
//     default: return Colors.green;
//   }
// }
}