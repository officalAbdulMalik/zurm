import 'dart:convert';

SwapHistoryModel swapHistoryModelFromJson(String str) => SwapHistoryModel.fromJson(json.decode(str));

String swapHistoryModelToJson(SwapHistoryModel data) => json.encode(data.toJson());

class SwapHistoryModel {
  bool? success;
  List<SwapHistory>? result;
  String? message;

  SwapHistoryModel({
    this.success,
    this.result,
    this.message,
  });

  factory SwapHistoryModel.fromJson(Map<String, dynamic> json) => SwapHistoryModel(
    success: json["success"],
    result: List<SwapHistory>.from(json["result"].map((x) => SwapHistory.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class SwapHistory {
  String? orderId;
  String? receiveCoin;
  String? spendCoin;
  String? volume;
  String? value;
  dynamic liveprice;
  String? fees;
  String? statusText;

  SwapHistory({
    this.orderId,
    this.receiveCoin,
    this.spendCoin,
    this.volume,
    this.value,
    this.liveprice,
    this.fees,
    this.statusText,
  });

  factory SwapHistory.fromJson(Map<String, dynamic> json) => SwapHistory(
    orderId: json["order_id"],
    receiveCoin: json["receive_coin"],
    spendCoin: json["spend_coin"],
    volume: json["volume"],
    value: json["value"],
    liveprice: json["liveprice"].toDouble(),
    fees: json["fees"],
    statusText: json["status_text"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "receive_coin": receiveCoin,
    "spend_coin": spendCoin,
    "volume": volume,
    "value": value,
    "liveprice": liveprice,
    "fees": fees,
    "status_text": statusText,
  };
}
