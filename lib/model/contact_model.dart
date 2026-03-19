class ContactsModel {
  final bool success;
  final String message;
  final List<ContactModel> data;

  ContactsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    return ContactsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => ContactModel.fromJson(e))
          .toList(),
    );
  }
}

class ContactModel {
  final String name;
  final String phone;
  final String personType;
  final String totalGiven;
  final String totalReceived;
  final int pendingAmount;
  final String balanceType;
  final String lastTransaction;

  ContactModel({
    required this.name,
    required this.phone,
    required this.personType,
    required this.totalGiven,
    required this.totalReceived,
    required this.pendingAmount,
    required this.balanceType,
    required this.lastTransaction,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      personType: json['person_type'] ?? '',
      totalGiven: json['total_given'] ?? '0.00',
      totalReceived: json['total_received'] ?? '0.00',
      pendingAmount: json['pending_amount'] ?? 0,
      balanceType: json['balance_type'] ?? '',
      lastTransaction: json['last_transaction'] ?? '',
    );
  }
}
