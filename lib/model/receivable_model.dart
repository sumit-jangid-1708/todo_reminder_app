// lib/model/transaction_models/receivable_model.dart

class ReceivableResponseModel {
  final bool success;
  final String message;
  final ReceivableSummary summary;
  final List<ReceivableData> data;

  const ReceivableResponseModel({
    required this.success,
    required this.message,
    required this.summary,
    required this.data,
  });

  factory ReceivableResponseModel.fromJson(Map<String, dynamic> json) {
    return ReceivableResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      summary: ReceivableSummary.fromJson(json['summary'] ?? {}),
      data: json['data'] != null
          ? (json['data'] as List)
          .map((item) => ReceivableData.fromJson(item))
          .toList()
          : [],
    );
  }
}

// ==================== Summary ====================
class ReceivableSummary {
  final double totalReceivable;
  final int totalPeople;

  const ReceivableSummary({
    required this.totalReceivable,
    required this.totalPeople,
  });

  factory ReceivableSummary.fromJson(Map<String, dynamic> json) {
    return ReceivableSummary(
      totalReceivable: _parseDouble(json['total_receivable']),
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
class ReceivableData {
  final String name;
  final String phone;
  final double totalPending;
  final String? upcomingDue;
  final String dueStatus;

  const ReceivableData({
    required this.name,
    required this.phone,
    required this.totalPending,
    this.upcomingDue,
    required this.dueStatus,
  });

  factory ReceivableData.fromJson(Map<String, dynamic> json) {
    return ReceivableData(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      totalPending: _parseDouble(json['total_pending']),
      upcomingDue: json['upcoming_due'],
      dueStatus: json['due_status'] ?? 'no_due',
    );
  }

  /// Helper method
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Optional: Formatted Amount
  String get formattedPending {
    return "₹${totalPending.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";
  }

  /// Due Status ke hisaab se color aur text ke liye helper
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
}