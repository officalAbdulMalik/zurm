import 'dart:convert';

OpenOrdersModel openOrdersModelFromJson(String str) => OpenOrdersModel.fromJson(json.decode(str));

String openOrdersModelToJson(OpenOrdersModel data) => json.encode(data.toJson());

class OpenOrdersModel {
  bool? success;
  List<OpenOrders>? result;
  String? message;

  OpenOrdersModel({
    this.success,
    this.result,
    this.message,
  });

  factory OpenOrdersModel.fromJson(Map<String, dynamic> json) => OpenOrdersModel(
    success: json["success"],
    result: List<OpenOrders>.from(json["result"].map((x) => OpenOrders.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class OpenOrders {
  dynamic id;
  dynamic uid;
  String? tradeType;
  String? ouid;
  String? orderId;
  dynamic pair;
  dynamic orderType;
  dynamic price;
  dynamic volume;
  dynamic value;
  dynamic fees;
  dynamic commission;
  dynamic remaining;
  dynamic stoplimit;
  dynamic status;
  String? statusText;
  dynamic priceperunit;
  dynamic leverage;
  dynamic spend;
  String? postTy;
  dynamic balance;
  dynamic isType;
  dynamic filled;
  DateTime? createdAt;
  DateTime? updatedAt;

  OpenOrders({
    this.id,
    this.uid,
    this.tradeType,
    this.ouid,
    this.orderId,
    this.pair,
    this.orderType,
    this.price,
    this.volume,
    this.value,
    this.fees,
    this.commission,
    this.remaining,
    this.stoplimit,
    this.status,
    this.statusText,
    this.priceperunit,
    this.leverage,
    this.spend,
    this.postTy,
    this.balance,
    this.isType,
    this.filled,
    this.createdAt,
    this.updatedAt,
  });

  factory OpenOrders.fromJson(Map<String, dynamic> json) => OpenOrders(
    id: json["id"],
    uid: json["uid"],
    tradeType: json["trade_type"],
    ouid: json["ouid"],
    orderId: json["order_id"],
    pair: json["pair"],
    orderType: json["order_type"],
    price: json["price"],
    volume: json["volume"],
    value: json["value"],
    fees: json["fees"],
    commission: json["commission"],
    remaining: json["remaining"],
    stoplimit: json["stoplimit"],
    status: json["status"],
    statusText: json["status_text"],
    priceperunit: json["priceperunit"],
    leverage: json["leverage"],
    spend: json["spend"],
    postTy: json["post_ty"],
    balance: json["balance"],
    isType: json["is_type"],
    filled: json["filled"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "trade_type": tradeType,
    "ouid": ouid,
    "order_id": orderId,
    "pair": pair,
    "order_type": orderType,
    "price": price,
    "volume": volume,
    "value": value,
    "fees": fees,
    "commission": commission,
    "remaining": remaining,
    "stoplimit": stoplimit,
    "status": status,
    "status_text": statusText,
    "priceperunit": priceperunit,
    "leverage": leverage,
    "spend": spend,
    "post_ty": postTy,
    "balance": balance,
    "is_type": isType,
    "filled": filled,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
