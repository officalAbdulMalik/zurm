import 'dart:convert';

ReferralHistoryListmodel referralHistoryListmodelFromJson(String str) => ReferralHistoryListmodel.fromJson(json.decode(str));

String referralHistoryListmodelToJson(ReferralHistoryListmodel data) => json.encode(data.toJson());

class ReferralHistoryListmodel {
  bool? success;
  Data? data;
  String? message;

  ReferralHistoryListmodel({
    this.success,
    this.data,
    this.message,
  });

  factory ReferralHistoryListmodel.fromJson(Map<String, dynamic> json) => ReferralHistoryListmodel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data!.toJson(),
    "message": message,
  };
}

class Data {
  ReferralInformation? referralInformation;
  Map<String, List<LevelInformation>>? levelInformation;

  Data({
    this.referralInformation,
    this.levelInformation,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    referralInformation: ReferralInformation.fromJson(json["referral_information"]),
    levelInformation: Map.from(json["level_information"]).map((k, v) => MapEntry<String, List<LevelInformation>>(k, List<LevelInformation>.from(v.map((x) => LevelInformation.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "referral_information": referralInformation!.toJson(),
    "level_information": Map.from(levelInformation!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
  };
}

class LevelInformation {
  String? name;
  String? mail;
  dynamic overAllStake;
  dynamic business;
  dynamic total;
  dynamic role;
  String? parentInfo;

  LevelInformation({
    this.name,
    this.mail,
    this.overAllStake,
    this.business,
    this.total,
    this.role,
    this.parentInfo,
  });

  factory LevelInformation.fromJson(Map<String, dynamic> json) => LevelInformation(
    name: json["name"],
    mail: json["mail"],
    overAllStake: json["over_all_stake"],
    business: json["business"],
    total: json["total"],
    role: json["role"],
    parentInfo: json["parent_info"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "mail": mail,
    "over_all_stake": overAllStake,
    "business": business,
    "total": total,
    "role": role,
    "parent_info": parentInfo,
  };
}

class ReferralInformation {
  String? referUrl;
  String? referId;
  String? myRole;
  dynamic myOverAllStake;
  dynamic myBussiness;
  dynamic strongLeg;
  dynamic otherLeg;
  String? strongemail;

  ReferralInformation({
    this.referUrl,
    this.referId,
    this.myRole,
    this.myOverAllStake,
    this.myBussiness,
    this.strongLeg,
    this.otherLeg,
    this.strongemail,
  });

  factory ReferralInformation.fromJson(Map<String, dynamic> json) => ReferralInformation(
    referUrl: json["refer_url"],
    referId: json["refer_id"],
    myRole: json["my_role"],
    myOverAllStake: json["my_overAll_stake"],
    myBussiness: json["my_bussiness"],
    strongLeg: json["strong_leg"],
    otherLeg: json["other_leg"],
    strongemail: json["strongemail"],
  );

  Map<String, dynamic> toJson() => {
    "refer_url": referUrl,
    "refer_id": referId,
    "my_role": myRole,
    "my_overAll_stake": myOverAllStake,
    "my_bussiness": myBussiness,
    "strong_leg": strongLeg,
    "other_leg": otherLeg,
    "strongemail": strongemail,
  };
}
