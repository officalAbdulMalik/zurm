import 'dart:convert';

TradeHistoryModel tradeHistoryModelFromJson(String str) => TradeHistoryModel.fromJson(json.decode(str));

String tradeHistoryModelToJson(TradeHistoryModel data) => json.encode(data.toJson());

class TradeHistoryModel {
  bool? success;
  Result? result;
  String? message;

  TradeHistoryModel({
    this.success,
    this.result,
    this.message,
  });

  factory TradeHistoryModel.fromJson(Map<String, dynamic> json) => TradeHistoryModel(
    success: json["success"],
    result: Result.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class Result {
  List<TradeHistory>? tradeHistory;
  List<BuyCryptoHistory>? buyCryptoHistory;

  Result({
    this.tradeHistory,
    this.buyCryptoHistory,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    tradeHistory: List<TradeHistory>.from(json["tradeHistory"].map((x) => TradeHistory.fromJson(x))),
    buyCryptoHistory: List<BuyCryptoHistory>.from(json["buyCryptoHistory"].map((x) => BuyCryptoHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tradeHistory": List<dynamic>.from(tradeHistory!.map((x) => x.toJson())),
    "buyCryptoHistory": List<dynamic>.from(buyCryptoHistory!.map((x) => x.toJson())),
  };
}

class BuyCryptoHistory {
  dynamic spend;
  dynamic receive;
  String? transId;
  String? price;
  String? volume;
  String? amount;
  String? fees;
  dynamic status;
  dynamic statusText;
  DateTime? createdAt;
  DateTime? updatedAt;

  BuyCryptoHistory({
    this.spend,
    this.receive,
    this.transId,
    this.price,
    this.volume,
    this.amount,
    this.fees,
    this.status,
    this.statusText,
    this.createdAt,
    this.updatedAt,
  });

  factory BuyCryptoHistory.fromJson(Map<String, dynamic> json) => BuyCryptoHistory(
    spend: json["spend"],
    receive: json["receive"],
    transId: json["trans_id"],
    price: json["price"],
    volume: json["volume"],
    amount: json["amount"],
    fees: json["fees"],
    status: json["status"],
    statusText: json["status_text"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "spend": spend,
    "receive": receive,
    "trans_id": transId,
    "price": price,
    "volume": volume,
    "amount": amount,
    "fees": fees,
    "status": status,
    "status_text": statusText,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}



class TradeHistory {
  String? pair;
  String? tradeType;
  String? orderType;
  String? price;
  String? volume;
  String? remaining;
  String? fees;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  TradeHistory({
    this.pair,
    this.tradeType,
    this.orderType,
    this.price,
    this.volume,
    this.remaining,
    this.fees,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory TradeHistory.fromJson(Map<String, dynamic> json) => TradeHistory(
    pair: json["pair"],
    tradeType: json["trade_type"],
    orderType: json["order_type"],
    price: json["price"],
    volume: json["volume"],
    remaining: json["remaining"],
    fees: json["fees"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "pair": pair,
    "trade_type": tradeType,
    "order_type": orderType,
    "price": price,
    "volume": volume,
    "remaining": remaining,
    "fees": fees,
    "status": status,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

