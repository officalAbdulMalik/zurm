import 'dart:convert';

TradeAllPairListModel tradeAllPairListModelFromJson(String str) => TradeAllPairListModel.fromJson(json.decode(str));

String tradeAllPairListModelToJson(TradeAllPairListModel data) => json.encode(data.toJson());

class TradeAllPairListModel {
  bool? success;
  List<TradeAllPairList>? result;
  String? message;

  TradeAllPairListModel({
    this.success,
    this.result,
    this.message,
  });

  factory TradeAllPairListModel.fromJson(Map<String, dynamic> json) => TradeAllPairListModel(
    success: json["success"],
    result: List<TradeAllPairList>.from(json["result"].map((x) => TradeAllPairList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class TradeAllPairList {
  String? tradePair;
  int? pairId;
  String? symbol;
  String? baseAsset;
  dynamic marketAsset;
  String? image;
  String? hrVolume;
  String? currentPrice;
  String? hrExchange;
  String? open;
  String? close;
  String? high;
  String? low;
  dynamic coinoneDecimal;
  dynamic cointwoDecimal;
  dynamic isInstant;

  TradeAllPairList({
    this.tradePair,
    this.pairId,
    this.symbol,
    this.baseAsset,
    this.marketAsset,
    this.image,
    this.hrVolume,
    this.currentPrice,
    this.hrExchange,
    this.open,
    this.close,
    this.high,
    this.low,
    this.coinoneDecimal,
    this.cointwoDecimal,
    this.isInstant,
  });

  factory TradeAllPairList.fromJson(Map<String, dynamic> json) => TradeAllPairList(
    tradePair: json["trade_pair"],
    pairId: json["pair_id"],
    symbol: json["symbol"],
    baseAsset: json["base_asset"],
    marketAsset: json["market_asset"],
    image: json["image"],
    hrVolume: json["hr_volume"],
    currentPrice: json["current_price"],
    hrExchange: json["hr_exchange"],
    open: json["open"],
    close: json["close"],
    high: json["high"],
    low: json["low"],
    coinoneDecimal: json["coinone_decimal"],
    cointwoDecimal: json["cointwo_decimal"],
    isInstant: json["is_instant"],
  );

  Map<String, dynamic> toJson() => {
    "trade_pair": tradePair,
    "pair_id": pairId,
    "symbol": symbol,
    "base_asset": baseAsset,
    "market_asset": marketAsset,
    "image": image,
    "hr_volume": hrVolume,
    "current_price": currentPrice,
    "hr_exchange": hrExchange,
    "open": open,
    "close": close,
    "high": high,
    "low": low,
    "coinone_decimal": coinoneDecimal,
    "cointwo_decimal": cointwoDecimal,
    "is_instant": isInstant,
  };
}


