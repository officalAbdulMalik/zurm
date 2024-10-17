import 'dart:convert';

InstantSubmitModel instantSubmitModelFromJson(String str) => InstantSubmitModel.fromJson(json.decode(str));

String instantSubmitModelToJson(InstantSubmitModel data) => json.encode(data.toJson());

class InstantSubmitModel {
  bool? success;
  InstantResult? result;
  String? message;

  InstantSubmitModel({
    this.success,
    this.result,
    this.message,
  });

  factory InstantSubmitModel.fromJson(Map<String, dynamic> json) => InstantSubmitModel(
    success: json["success"],
    result: json["result"]=="null"|| json["result"]==null?InstantResult():InstantResult.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class InstantResult {
  String? qrCode;
  String? qrId;
  String? oMlink;
  String? maxiTlink;

  InstantResult({
    this.qrCode,
    this.qrId,
    this.oMlink,
    this.maxiTlink,
  });

  factory InstantResult.fromJson(Map<String, dynamic> json) => InstantResult(
    qrCode: json["qrCode"],
    qrId: json["qrID"],
    oMlink: json["OMlink"],
    maxiTlink: json["MAXITlink"],
  );

  Map<String, dynamic> toJson() => {
    "qrCode": qrCode,
    "qrID": qrId,
    "OMlink": oMlink,
    "MAXITlink": maxiTlink,
  };
}

