import 'dart:convert';

SwapBalanceListModel swapBalanceListModelFromJson(String str) => SwapBalanceListModel.fromJson(json.decode(str));

String swapBalanceListModelToJson(SwapBalanceListModel data) => json.encode(data.toJson());

class SwapBalanceListModel {
  bool? success;
  dynamic balance;
  List<SwapBalanceList>? result;
  String? message;

  SwapBalanceListModel({
    this.success,
    this.balance,
    this.result,
    this.message,
  });

  factory SwapBalanceListModel.fromJson(Map<String, dynamic> json) => SwapBalanceListModel(
    success: json["success"],
    balance: json["balance"],
    result: List<SwapBalanceList>.from(json["result"].map((x) => SwapBalanceList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "balance": balance,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class SwapBalanceList {
  String? cointwo;
  dynamic balance;
  dynamic liveprice;
  dynamic commissionPercentage;
  String? type;

  SwapBalanceList({
    this.cointwo,
    this.balance,
    this.liveprice,
    this.commissionPercentage,
    this.type,
  });

  factory SwapBalanceList.fromJson(Map<String, dynamic> json) => SwapBalanceList(
    cointwo: json["cointwo"],
    balance: json["balance"],
    liveprice: json["liveprice"].toDouble(),
    commissionPercentage: json["commission_percentage"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "cointwo": cointwo,
    "balance": balance,
    "liveprice": liveprice,
    "commission_percentage": commissionPercentage,
    "type": type,
  };
}
