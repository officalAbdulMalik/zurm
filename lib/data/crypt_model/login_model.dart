import 'dart:convert';
import 'dart:convert';

LoginDetailsModel loginDetailsModelFromJson(String str) => LoginDetailsModel.fromJson(json.decode(str));

String loginDetailsModelToJson(LoginDetailsModel data) => json.encode(data.toJson());

class LoginDetailsModel {
  bool? success;
  LoginDetails? result;
  Kycstatus? kycstatus;
  Twofactor? twofactor;
  String? message;

  LoginDetailsModel({
    this.success,
    this.result,
    this.kycstatus,
    this.twofactor,
    this.message,
  });

  factory LoginDetailsModel.fromJson(Map<String, dynamic> json) => LoginDetailsModel(
    success: json["success"],
    result: json["result"]==null || json["result"]=="null" ? LoginDetails() : LoginDetails.fromJson(json["result"]),
    kycstatus: json["kycstatus"]== null || json["kycstatus"]=="null" ? Kycstatus(): Kycstatus.fromJson(json["kycstatus"]),
    twofactor: json["twofactor"]== null || json["twofactor"]== "null"? Twofactor() : Twofactor.fromJson(json["twofactor"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "kycstatus": kycstatus!.toJson(),
    "twofactor": twofactor!.toJson(),
    "message": message,
  };
}

class Kycstatus {
  String? status;
  dynamic value;

  Kycstatus({
    this.status,
    this.value,
  });

  factory Kycstatus.fromJson(Map<String, dynamic> json) => Kycstatus(
    status: json["status"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "value": value,
  };
}

class LoginDetails {
  String? accessToken;
  String? tokenType;
  dynamic expiresAt;
  UserDetails? userDetails;

  LoginDetails({
    this.accessToken,
    this.tokenType,
    this.expiresAt,
    this.userDetails,
  });

  factory LoginDetails.fromJson(Map<String, dynamic> json) => LoginDetails(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresAt: DateTime.parse(json["expires_at"]),
    userDetails: UserDetails.fromJson(json["user_details"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "expires_at": expiresAt.toIso8601String(),
    "user_details": userDetails!.toJson(),
  };
}

class UserDetails {
  String? firstName;
  String? lastName;
  String? email;
  dynamic kycVerify;
  dynamic emailVerify;
  dynamic smsVerify;

  UserDetails({
    this.firstName,
    this.lastName,
    this.email,
    this.kycVerify,
    this.emailVerify,
    this.smsVerify,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    kycVerify: json["kyc_verify"],
    emailVerify: json["email_verify"],
    smsVerify: json["sms_verify"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "kyc_verify": kycVerify,
    "email_verify": emailVerify,
    "sms_verify": smsVerify,
  };
}

class Twofactor {
  String? type;
  String? image;
  String? secret;

  Twofactor({
    this.type,
    this.image,
    this.secret,
  });

  factory Twofactor.fromJson(Map<String, dynamic> json) => Twofactor(
    type: json["type"],
    image: json["image"],
    secret: json["secret"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "image": image,
    "secret": secret,
  };
}
