import 'dart:convert';

EarningListmodel earningListmodelFromJson(String str) => EarningListmodel.fromJson(json.decode(str));

String earningListmodelToJson(EarningListmodel data) => json.encode(data.toJson());

class EarningListmodel {
  bool? success;
  List<EarningList>? result;
  String? message;

  EarningListmodel({
    this.success,
    this.result,
    this.message,
  });

  factory EarningListmodel.fromJson(Map<String, dynamic> json) => EarningListmodel(
    success: json["success"],
    result: List<EarningList>.from(json["result"].map((x) => EarningList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class EarningList {
  String? name;
  dynamic amount;
  String? key;
  String? image;

  EarningList({
    this.name,
    this.amount,
    this.key,
    this.image,
  });

  factory EarningList.fromJson(Map<String, dynamic> json) => EarningList(
    name: json["name"],
    amount: json["amount"],
    key: json["key"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
    "key": key,
    "image": image,
  };
}
