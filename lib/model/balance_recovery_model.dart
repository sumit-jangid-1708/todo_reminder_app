class BalanceSummaryResponseModel {
  final bool success;
  final String message;
  final BalanceDataModel data;

  BalanceSummaryResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BalanceSummaryResponseModel.fromJson(
      Map<String, dynamic> json) {
    return BalanceSummaryResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: BalanceDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class BalanceDataModel {
  final int youWillReceive;
  final int youWillPay;
  final int netBalance;

  BalanceDataModel({
    required this.youWillReceive,
    required this.youWillPay,
    required this.netBalance,
  });

  factory BalanceDataModel.fromJson(Map<String, dynamic> json) {
    return BalanceDataModel(
      youWillReceive: json['you_will_receive'] ?? 0,
      youWillPay: json['you_will_pay'] ?? 0,
      netBalance: json['net_balance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'you_will_receive': youWillReceive,
      'you_will_pay': youWillPay,
      'net_balance': netBalance,
    };
  }
}