import 'dart:convert';

GetBalanceModel getBalanceModelFromJson(String str) => GetBalanceModel.fromJson(json.decode(str));

String getBalanceModelToJson(GetBalanceModel data) => json.encode(data.toJson());

class GetBalanceModel {
  bool? success;
  GetBalanceResult? result;
  String? message;

  GetBalanceModel({
    this.success,
    this.result,
    this.message,
  });

  factory GetBalanceModel.fromJson(Map<String, dynamic> json) => GetBalanceModel(
    success: json["success"],
    result: GetBalanceResult.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class GetBalanceResult {
  String? amount;
  String? liveprice;
  String? paidamount;
  String? fees;
  String? buycon;
  String? feecon;
  dynamic comm;

  GetBalanceResult({
    this.amount,
    this.liveprice,
    this.paidamount,
    this.fees,
    this.buycon,
    this.feecon,
    this.comm,
  });

  factory GetBalanceResult.fromJson(Map<String, dynamic> json) => GetBalanceResult(
    amount: json["amount"],
    liveprice: json["liveprice"],
    paidamount: json["paidamount"],
    fees: json["fees"],
    buycon: json["buycon"],
    feecon: json["feecon"],
    comm: json["comm"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "liveprice": liveprice,
    "paidamount": paidamount,
    "fees": fees,
    "buycon": buycon,
    "feecon": feecon,
    "comm": comm,
  };
}
