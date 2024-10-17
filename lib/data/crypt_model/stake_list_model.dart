import 'dart:convert';

StakeListmodel stakeListmodelFromJson(String str) => StakeListmodel.fromJson(json.decode(str));

String stakeListmodelToJson(StakeListmodel data) => json.encode(data.toJson());

class StakeListmodel {
  bool? success;
  List<StakeList>? result;
  String? message;

  StakeListmodel({
    this.success,
    this.result,
    this.message,
  });

  factory StakeListmodel.fromJson(Map<String, dynamic> json) => StakeListmodel(
    success: json["success"],
    result: List<StakeList>.from(json["result"].map((x) => StakeList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class StakeList {
  String? id;
  String? title;
  String? depositCoin;
  String? minAmt;
  String? maxAmt;
  String? durationTitle;
  String? rewardToken;

  StakeList({
    this.id,
    this.title,
    this.depositCoin,
    this.minAmt,
    this.maxAmt,
    this.durationTitle,
    this.rewardToken,
  });

  factory StakeList.fromJson(Map<String, dynamic> json) => StakeList(
    id: json["id"],
    title: json["title"],
    depositCoin: json["deposit_coin"],
    minAmt: json["min_amt"],
    maxAmt: json["max_amt"],
    durationTitle: json["duration_title"],
    rewardToken: json["reward_token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "deposit_coin": depositCoin,
    "min_amt": minAmt,
    "max_amt": maxAmt,
    "duration_title": durationTitle,
    "reward_token": rewardToken,
  };
}
