import 'dart:convert';

UserDetailsModel userDetailsModelFromJson(String str) => UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) => json.encode(data.toJson());

class UserDetailsModel {
  bool? success;
  UserDetails? result;
  String? message;

  UserDetailsModel({
    this.success,
    this.result,
    this.message,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
    success: json["success"],
    result: UserDetails.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class UserDetails {
  String? firstName;
  String? lastName;
  String? email;
  dynamic phoneCountry;
  dynamic phoneNo;
  dynamic country;
  dynamic nationality;
  dynamic dob;
  dynamic profileimg;
  dynamic address;
  String? twofa;
  dynamic twofaStatus;
  String? google2FaSecret;
  dynamic google2FaVerify;
  dynamic emailVerify;
  dynamic kycVerify;
  String? referralId;
  dynamic parentId;

  UserDetails({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneCountry,
    this.phoneNo,
    this.country,
    this.nationality,
    this.dob,
    this.profileimg,
    this.address,
    this.twofa,
    this.twofaStatus,
    this.google2FaSecret,
    this.google2FaVerify,
    this.emailVerify,
    this.kycVerify,
    this.referralId,
    this.parentId,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phoneCountry: json["phone_country"],
    phoneNo: json["phone_no"],
    country: json["country"],
    nationality: json["nationality"],
    dob: json["dob"],
    profileimg: json["profileimg"],
    address: json["address"],
    twofa: json["twofa"],
    twofaStatus: json["twofa_status"],
    google2FaSecret: json["google2fa_secret"],
    google2FaVerify: json["google2fa_verify"],
    emailVerify: json["email_verify"],
    kycVerify: json["kyc_verify"],
    referralId: json["referral_id"],
    parentId: json["parent_id"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone_country": phoneCountry,
    "phone_no": phoneNo,
    "country": country,
    "nationality": nationality,
    "dob": dob,
    "profileimg": profileimg,
    "address": address,
    "twofa": twofa,
    "twofa_status": twofaStatus,
    "google2fa_secret": google2FaSecret,
    "google2fa_verify": google2FaVerify,
    "email_verify": emailVerify,
    "kyc_verify": kycVerify,
    "referral_id": referralId,
    "parent_id": parentId,
  };
}
