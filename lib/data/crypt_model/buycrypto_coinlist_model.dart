import 'dart:convert';

CoinListModel coinListModelFromJson(String str) => CoinListModel.fromJson(json.decode(str));

String coinListModelToJson(CoinListModel data) => json.encode(data.toJson());

class CoinListModel {
  bool? success;
  List<String>? result;
  String? message;

  CoinListModel({
    this.success,
    this.result,
    this.message,
  });

  factory CoinListModel.fromJson(Map<String, dynamic> json) => CoinListModel(
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
