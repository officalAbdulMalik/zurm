import 'dart:convert';

import 'package:zurumi/data/crypt_model/user_wallet_balance_model.dart';

DepositDetailsModel depositDetailsModelFromJson(String str) => DepositDetailsModel.fromJson(json.decode(str));

String depositDetailsModelToJson(DepositDetailsModel data) => json.encode(data.toJson());

class DepositDetailsModel {
  bool? success;
  DepositDetail? result;
  String? message;
  List<NetworkAddress>? network;

  DepositDetailsModel({
     this.success,
     this.result,
     this.message,
     this.network
  });

  factory DepositDetailsModel.fromJson(Map<String, dynamic> json) => DepositDetailsModel(
    success: json["success"],
    result: json["result"]=="null"|| json["result"]==null?DepositDetail():DepositDetail.fromJson(json["result"]),
    message: json["message"],
    network: json["network"]==null || json["network"]==[]?[]:List<NetworkAddress>.from(json["network"].map((x) => NetworkAddress.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "network": List<dynamic>.from(network!.map((x) => x.toJson())),
    "message": message,
  };
}

class DepositDetail {
  dynamic asset;
  dynamic symbol;
  dynamic address;
  dynamic qrcode;
  dynamic name;
  dynamic type;
  dynamic image;
  dynamic pointValue;
  dynamic perdayWithdraw;
  dynamic withdrawCommission;
  dynamic fee;
  dynamic balance;
  dynamic escrow;
  dynamic total;

  DepositDetail({
     this.asset,
     this.symbol,
     this.address,
     this.qrcode,
     this.name,
     this.type,
     this.image,
     this.pointValue,
     this.perdayWithdraw,
     this.withdrawCommission,
     this.fee,
     this.balance,
     this.escrow,
     this.total,
  });

  factory DepositDetail.fromJson(Map<String, dynamic> json) => DepositDetail(
    asset: json["asset"],
    symbol: json["symbol"],
    address: json["address"],
    qrcode: json["qrcode"],
    name: json["name"],
    type: json["type"],
    image: json["image"],
    pointValue: json["point_value"],
    perdayWithdraw: json["perday_withdraw"],
    withdrawCommission: json["withdraw_commission"],
    fee: json["fee"],
    balance: json["balance"],
    escrow: json["escrow"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "asset": asset,
    "symbol": symbol,
    "address": address,
    "qrcode": qrcode,
    "name": name,
    "type": type,
    "image": image,
    "point_value": pointValue,
    "perday_withdraw": perdayWithdraw,
    "withdraw_commission": withdrawCommission,
    "fee": fee,
    "balance": balance,
    "escrow": escrow,
    "total": total,
  };
}

