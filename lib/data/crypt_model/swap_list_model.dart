import 'dart:convert';

SwapListModel swapListModelFromJson(String str) => SwapListModel.fromJson(json.decode(str));

String swapListModelToJson(SwapListModel data) => json.encode(data.toJson());

class SwapListModel {
  bool? success;
  List<SwapList>? result;
  String? message;

  SwapListModel({
    this.success,
    this.result,
    this.message,
  });

  factory SwapListModel.fromJson(Map<String, dynamic> json) => SwapListModel(
    success: json["success"],
    result: List<SwapList>.from(json["result"].map((x) => SwapList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class SwapList {
  dynamic id;
  String? coinone;
  DateTime? createdAt;
  DateTime? updatedAt;

  SwapList({
    this.id,
    this.coinone,
    this.createdAt,
    this.updatedAt,
  });

  factory SwapList.fromJson(Map<String, dynamic> json) => SwapList(
    id: json["id"],
    coinone: json["coinone"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "coinone": coinone,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
