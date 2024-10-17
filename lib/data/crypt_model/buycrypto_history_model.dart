import 'dart:convert';

BuyCryptoHistoryModel buyCryptoHistoryModelFromJson(String str) => BuyCryptoHistoryModel.fromJson(json.decode(str));

String buyCryptoHistoryModelToJson(BuyCryptoHistoryModel data) => json.encode(data.toJson());

class BuyCryptoHistoryModel {
  bool? success;
  List<BuyCryptoResult>? result;
  String? message;

  BuyCryptoHistoryModel({
    this.success,
    this.result,
    this.message,
  });

  factory BuyCryptoHistoryModel.fromJson(Map<String, dynamic> json) => BuyCryptoHistoryModel(
    success: json["success"],
    result: List<BuyCryptoResult>.from(json["result"].map((x) => BuyCryptoResult.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class BuyCryptoResult {
  String? transId;
  SpendCoin? spendCoin;
  dynamic receiveCoin;
  String? volume;
  String? value;
  dynamic price;
  dynamic amount;
  String? commission;
  String? fees;
  dynamic status;

  BuyCryptoResult({
    this.transId,
    this.spendCoin,
    this.receiveCoin,
    this.volume,
    this.value,
    this.price,
    this.amount,
    this.commission,
    this.fees,
    this.status,
  });

  factory BuyCryptoResult.fromJson(Map<String, dynamic> json) => BuyCryptoResult(
    transId: json["trans_id"],
    spendCoin: json["spend_coin"],
    receiveCoin: json["receive_coin"],
    volume: json["volume"],
    value: json["value"],
    price: json["price"].toDouble(),
    amount: json["amount"].toDouble(),
    commission: json["commission"],
    fees: json["fees"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "trans_id": transId,
    "spend_coin": spendCoin,
    "receive_coin": receiveCoin,
    "volume": volume,
    "value": value,
    "price": price,
    "amount": amount,
    "commission": commission,
    "fees": fees,
    "status": status,
  };
}

enum SpendCoin {
  INR,
  XOF
}

final spendCoinValues = EnumValues({
  "INR": SpendCoin.INR,
  "XOF": SpendCoin.XOF
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
