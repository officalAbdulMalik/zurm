import 'dart:convert';

WithdrawModel withdrawModelFromJson(String str) => WithdrawModel.fromJson(json.decode(str));

String withdrawModelToJson(WithdrawModel data) => json.encode(data.toJson());

class WithdrawModel {
  bool? success;
  dynamic result;
  String? message;

  WithdrawModel({
    this.success,
    this.result,
    this.message,
  });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) => WithdrawModel(
    success: json["success"],
    result:json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result,
    "message": message,
  };
}


