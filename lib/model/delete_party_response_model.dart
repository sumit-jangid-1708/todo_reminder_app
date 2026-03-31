class DeletePartyResponseModel {
  final bool success;
  final String message;

  DeletePartyResponseModel({
    required this.success,
    required this.message,
  });

  factory DeletePartyResponseModel.fromJson(Map<String, dynamic> json) {
    return DeletePartyResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
    };
  }
}