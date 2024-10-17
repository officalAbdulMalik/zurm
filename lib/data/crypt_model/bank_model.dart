import 'dart:convert';

BankListModel bankListModelFromJson(String str) => BankListModel.fromJson(json.decode(str));

String bankListModelToJson(BankListModel data) => json.encode(data.toJson());

class BankListModel {
  bool? success;
  List<BankList>? result;
  String? message;

  BankListModel({
    this.success,
    this.result,
    this.message,
  });

  factory BankListModel.fromJson(Map<String, dynamic> json) => BankListModel(
    success: json["success"],
    result: List<BankList>.from(json["result"].map((x) => BankList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class BankList {
  dynamic id;
  dynamic uid;
  String? accountName;
  String? accountNo;
  String? bankName;
  dynamic bankBranch;
  dynamic bankAddress;
  dynamic paypalId;
  dynamic swiftCode;
  dynamic accounttype;
  dynamic branchCode;
  dynamic type;
  dynamic aliasupi;
  dynamic status;
  dynamic upiid;
  dynamic qrcode;
  DateTime? createdAt;
  DateTime? updatedAt;

  BankList({
    this.id,
    this.uid,
    this.accountName,
    this.accountNo,
    this.bankName,
    this.bankBranch,
    this.bankAddress,
    this.paypalId,
    this.swiftCode,
    this.accounttype,
    this.branchCode,
    this.type,
    this.aliasupi,
    this.status,
    this.upiid,
    this.qrcode,
    this.createdAt,
    this.updatedAt,
  });

  factory BankList.fromJson(Map<String, dynamic> json) => BankList(
    id: json["id"],
    uid: json["uid"],
    accountName: json["account_name"],
    accountNo: json["account_no"],
    bankName: json["bank_name"],
    bankBranch: json["bank_branch"],
    bankAddress: json["bank_address"],
    paypalId: json["paypal_id"],
    swiftCode: json["swift_code"],
    accounttype: json["accounttype"],
    branchCode: json["branch_code"],
    type: json["type"],
    aliasupi: json["aliasupi"],
    status: json["status"],
    upiid: json["upiid"],
    qrcode: json["qrcode"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "account_name": accountName,
    "account_no": accountNo,
    "bank_name": bankName,
    "bank_branch": bankBranch,
    "bank_address": bankAddress,
    "paypal_id": paypalId,
    "swift_code": swiftCode,
    "accounttype": accounttype,
    "branch_code": branchCode,
    "type": type,
    "aliasupi": aliasupi,
    "status": status,
    "upiid": upiid,
    "qrcode": qrcode,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
