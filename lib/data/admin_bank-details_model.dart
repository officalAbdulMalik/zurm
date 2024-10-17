import 'dart:convert';

AdminBankDetails adminBankDetailsFromJson(String str) => AdminBankDetails.fromJson(json.decode(str));

String adminBankDetailsToJson(AdminBankDetails data) => json.encode(data.toJson());

class AdminBankDetails {
  bool? success;
  List<String>? result;
  String? message;

  AdminBankDetails({
    this.success,
    this.result,
    this.message,
  });

  factory AdminBankDetails.fromJson(Map<String, dynamic> json) => AdminBankDetails(
    success: json["success"],
    result: List<String>.from(json["result"].map((x) => x)),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x)),
    "message": message,
  };
}
