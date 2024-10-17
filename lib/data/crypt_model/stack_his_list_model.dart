import 'dart:convert';


StackHistoryListmodel stackHistoryListmodelFromJson(String str) => StackHistoryListmodel.fromJson(json.decode(str));

String stackHistoryListmodelToJson(StackHistoryListmodel data) => json.encode(data.toJson());

class StackHistoryListmodel {
  bool? success;
  List<StackHistoryList>? data;
  String? message;
  dynamic livePrice;

  StackHistoryListmodel({
    this.success,
    this.data,
    this.message,
    this.livePrice,
  });

  factory StackHistoryListmodel.fromJson(Map<String, dynamic> json) => StackHistoryListmodel(
    success: json["success"],
    data: List<StackHistoryList>.from(json["data"].map((x) => StackHistoryList.fromJson(x))),
    message: json["message"],
      livePrice: json["live_price"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
    "live_price": livePrice,
  };
}

class StackHistoryList {
  dynamic id;
  String? txid;
  dynamic uid;
  dynamic stakId;
  String? stakingTitle;
  String? depositCoin;
  dynamic noOfCoin;
  dynamic actualStakingAmount;
  dynamic contractDuration;
  String? durationTitle;
  dynamic status;
  dynamic expiryDate;
  dynamic cancelDate;
  dynamic annualYield;
  dynamic cancellationFee;
  String? cancellationType;
  dynamic lastReward;
  dynamic nextReward;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic totalEstimatedReward;

  StackHistoryList({
    this.id,
    this.txid,
    this.uid,
    this.stakId,
    this.stakingTitle,
    this.depositCoin,
    this.noOfCoin,
    this.actualStakingAmount,
    this.contractDuration,
    this.durationTitle,
    this.status,
    this.expiryDate,
    this.cancelDate,
    this.annualYield,
    this.cancellationFee,
    this.cancellationType,
    this.lastReward,
    this.nextReward,
    this.createdAt,
    this.updatedAt,
    this.totalEstimatedReward,
  });

  factory StackHistoryList.fromJson(Map<String, dynamic> json) => StackHistoryList(
    id: json["id"],
    txid: json["txid"],
    uid: json["uid"],
    stakId: json["stak_id"],
    stakingTitle: json["staking_title"],
    depositCoin: json["deposit_coin"],
    noOfCoin: json["no_of_coin"],
    actualStakingAmount: json["actual_staking_amount"],
    contractDuration: json["contract_duration"],
    durationTitle: json["duration_title"],
    status: json["status"],
    expiryDate: json["expiry_date"],
    cancelDate: json["cancel_date"],
    annualYield: json["annual_yield"].toDouble(),
    cancellationFee: json["cancellation_fee"],
    cancellationType: json["cancellation_type"],
    lastReward: json["last_reward"],
    nextReward: json["next_reward"],
    createdAt:json["created_at"],
    updatedAt: json["updated_at"],
    totalEstimatedReward: json["total_estimated_reward"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "txid": txid,
    "uid": uid,
    "stak_id": stakId,
    "staking_title": stakingTitle,
    "deposit_coin": depositCoin,
    "no_of_coin": noOfCoin,
    "actual_staking_amount": actualStakingAmount,
    "contract_duration": contractDuration,
    "duration_title": durationTitle,
    "status": status,
    "expiry_date": expiryDate,
    "cancel_date": cancelDate,
    "annual_yield": annualYield,
    "cancellation_fee": cancellationFee,
    "cancellation_type": cancellationType,
    "last_reward": lastReward,
    "next_reward": nextReward,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "total_estimated_reward": totalEstimatedReward,
  };
}

