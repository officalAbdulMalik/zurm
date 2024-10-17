import 'dart:convert';

OrangePayDetails orangePayDetailsFromJson(String str) => OrangePayDetails.fromJson(json.decode(str));

String orangePayDetailsToJson(OrangePayDetails data) => json.encode(data.toJson());

class OrangePayDetails {
  bool? success;
  Result? result;
  String? message;

  OrangePayDetails({
    this.success,
    this.result,
    this.message,
  });

  factory OrangePayDetails.fromJson(Map<String, dynamic> json) => OrangePayDetails(
    success: json["success"],
    result:Result.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class Result {
  String? qrCode;
  String? qrId;

  Result({
    this.qrCode,
    this.qrId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    qrCode: json["qrCode"],
    qrId: json["qrID"],
  );

  Map<String, dynamic> toJson() => {
    "qrCode": qrCode,
    "qrID": qrId,
  };
}
