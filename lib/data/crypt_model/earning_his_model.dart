import 'dart:convert';

EarningHistoryListmodel earningHistoryListmodelFromJson(String str) => EarningHistoryListmodel.fromJson(json.decode(str));

String earningHistoryListmodelToJson(EarningHistoryListmodel data) => json.encode(data.toJson());

class EarningHistoryListmodel {
  bool? success;
  List<EarningHistoryList>? result;
  String? message;

  EarningHistoryListmodel({
    this.success,
    this.result,
    this.message,
  });

  factory EarningHistoryListmodel.fromJson(Map<String, dynamic> json) => EarningHistoryListmodel(
    success: json["success"],
    result: List<EarningHistoryList>.from(json["result"].map((x) => EarningHistoryList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class EarningHistoryList {
  dynamic id;
  dynamic uid;
  dynamic stakId;
  dynamic depositId;
  String? txid;
  dynamic coin;
  dynamic interestType;
  dynamic interestAmt;
  dynamic durationTitle;
  dynamic period;
  dynamic amount;
  dynamic amountStaked;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;

  EarningHistoryList({
    this.id,
    this.uid,
    this.stakId,
    this.depositId,
    this.txid,
    this.coin,
    this.interestType,
    this.interestAmt,
    this.durationTitle,
    this.period,
    this.amount,
    this.amountStaked,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory EarningHistoryList.fromJson(Map<String, dynamic> json) => EarningHistoryList(
    id: json["id"],
    uid: json["uid"],
    stakId: json["stak_id"],
    depositId: json["deposit_id"],
    txid: json["txid"],
    coin: json["coin"],
    interestType: json["interest_type"],
    interestAmt: json["interest_amt"],
    durationTitle: json["duration_title"],
    period: json["period"],
    amount: json["amount"],
    amountStaked: json["amount_staked"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "stak_id": stakId,
    "deposit_id": depositId,
    "txid": txid,
    "coin": coin,
    "interest_type": interestType,
    "interest_amt": interestAmt,
    "duration_title": durationTitle,
    "period": period,
    "amount": amount,
    "amount_staked": amountStaked,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}


