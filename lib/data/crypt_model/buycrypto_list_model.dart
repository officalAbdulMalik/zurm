import 'dart:convert';

BuyCryptoListModel buyCryptoListModelFromJson(String str) => BuyCryptoListModel.fromJson(json.decode(str));

String buyCryptoListModelToJson(BuyCryptoListModel data) => json.encode(data.toJson());

class BuyCryptoListModel {
  bool? success;
  String? result;
  List<Coinone>? coinone;
  List<Cointwo>? cointwo;
  String? message;

  BuyCryptoListModel({
    this.success,
    this.result,
    this.coinone,
    this.cointwo,
    this.message,
  });

  factory BuyCryptoListModel.fromJson(Map<String, dynamic> json) => BuyCryptoListModel(
    success: json["success"],
    result: json["result"],
    coinone: List<Coinone>.from(json["coinone"].map((x) => Coinone.fromJson(x))),
    cointwo: List<Cointwo>.from(json["cointwo"].map((x) => Cointwo.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result,
    "coinone": List<dynamic>.from(coinone!.map((x) => x.toJson())),
    "cointwo": List<dynamic>.from(cointwo!.map((x) => x.toJson())),
    "message": message,
  };
}

class Coinone {
  String? coinone;
  dynamic maxId;

  Coinone({
    this.coinone,
    this.maxId,
  });

  factory Coinone.fromJson(Map<String, dynamic> json) => Coinone(
    coinone: json["coinone"],
    maxId: json["max_id"],
  );

  Map<String, dynamic> toJson() => {
    "coinone": coinone,
    "max_id": maxId,
  };
}

class Cointwo {
  String? cointwo;
  dynamic maxId;

  Cointwo({
    this.cointwo,
    this.maxId,
  });

  factory Cointwo.fromJson(Map<String, dynamic> json) => Cointwo(
    cointwo: json["cointwo"],
    maxId: json["max_id"],
  );

  Map<String, dynamic> toJson() => {
    "cointwo": cointwo,
    "max_id": maxId,
  };
}
