class PartyProfileModel {
  final String name;
  final String phone;
  final String? address;
  final String? avatarUrl;
  final String totalGiven;
  final String totalReceived;
  final int balance;
  final String balanceLabel;
  final String balanceType;

  PartyProfileModel({
    required this.name,
    required this.phone,
    this.address,
    this.avatarUrl,
    required this.totalGiven,
    required this.totalReceived,
    required this.balance,
    required this.balanceLabel,
    required this.balanceType,
  });

  factory PartyProfileModel.fromJson(Map<String, dynamic> json) {
    return PartyProfileModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'],
      avatarUrl: json['avatar_url'],
      totalGiven: json['total_given'] ?? '0.00',
      totalReceived: json['total_received'] ?? '0.00',
      balance: json['balance'] ?? 0,
      balanceLabel: json['balance_label'] ?? '',
      balanceType: json['balance_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "address": address,
      "avatar_url": avatarUrl,
      "total_given": totalGiven,
      "total_received": totalReceived,
      "balance": balance,
      "balance_label": balanceLabel,
      "balance_type": balanceType,
    };
  }
}