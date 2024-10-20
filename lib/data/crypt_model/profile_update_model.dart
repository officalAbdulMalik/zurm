import 'dart:convert';

ProfileUpdateModel profileUpdateModelFromJson(String str) => ProfileUpdateModel.fromJson(json.decode(str));

String profileUpdateModelToJson(ProfileUpdateModel data) => json.encode(data.toJson());

class ProfileUpdateModel {
  bool? success;
  ProfileUpdate? result;
  String? message;

  ProfileUpdateModel({
    this.success,
    this.result,
    this.message,
  });

  factory ProfileUpdateModel.fromJson(Map<String, dynamic> json) => ProfileUpdateModel(
    success: json["success"],
    result: ProfileUpdate.fromJson(json["result"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result!.toJson(),
    "message": message,
  };
}

class ProfileUpdate {
  dynamic id;
  String? role;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? emailVerifiedAt;
  String? phoneCountry;
  String? phoneNo;
  dynamic phoneVerified;
  dynamic country;
  String? nationality;
  DateTime? dob;
  String? profileimg;
  dynamic address;
  String? twofa;
  dynamic twofaStatus;
  String? google2FaSecret;
  dynamic google2FaVerify;
  dynamic emailVerify;
  dynamic kycVerify;
  dynamic profileOtp;
  dynamic companyType;
  dynamic xid;
  dynamic businessName;
  dynamic businessCountry;
  dynamic businessEmail;
  dynamic businessFirstName;
  dynamic businessMiddleName;
  dynamic businessLastName;
  dynamic status;
  dynamic freeze;
  dynamic reason;
  dynamic verifyToken;
  dynamic isLogged;
  String? ipaddr;
  String? device;
  String? location;
  String? type;
  String? mobileUser;
  dynamic isAddress;
  String? referralId;
  dynamic parentId;
  dynamic activationToken;
  dynamic apiToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProfileUpdate({
    this.id,
    this.role,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.phoneCountry,
    this.phoneNo,
    this.phoneVerified,
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
    this.profileOtp,
    this.companyType,
    this.xid,
    this.businessName,
    this.businessCountry,
    this.businessEmail,
    this.businessFirstName,
    this.businessMiddleName,
    this.businessLastName,
    this.status,
    this.freeze,
    this.reason,
    this.verifyToken,
    this.isLogged,
    this.ipaddr,
    this.device,
    this.location,
    this.type,
    this.mobileUser,
    this.isAddress,
    this.referralId,
    this.parentId,
    this.activationToken,
    this.apiToken,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileUpdate.fromJson(Map<String, dynamic> json) => ProfileUpdate(
    id: json["id"],
    role: json["role"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
    phoneCountry: json["phone_country"],
    phoneNo: json["phone_no"],
    phoneVerified: json["phone_verified"],
    country: json["country"],
    nationality: json["nationality"],
    dob: DateTime.parse(json["dob"]),
    profileimg: json["profileimg"],
    address: json["address"],
    twofa: json["twofa"],
    twofaStatus: json["twofa_status"],
    google2FaSecret: json["google2fa_secret"],
    google2FaVerify: json["google2fa_verify"],
    emailVerify: json["email_verify"],
    kycVerify: json["kyc_verify"],
    profileOtp: json["profile_otp"],
    companyType: json["company_type"],
    xid: json["xid"],
    businessName: json["business_name"],
    businessCountry: json["business_country"],
    businessEmail: json["business_email"],
    businessFirstName: json["business_first_name"],
    businessMiddleName: json["business_middle_name"],
    businessLastName: json["business_last_name"],
    status: json["status"],
    freeze: json["freeze"],
    reason: json["reason"],
    verifyToken: json["verifyToken"],
    isLogged: json["is_logged"],
    ipaddr: json["ipaddr"],
    device: json["device"],
    location: json["location"],
    type: json["type"],
    mobileUser: json["mobile_user"],
    isAddress: json["is_address"],
    referralId: json["referral_id"],
    parentId: json["parent_id"],
    activationToken: json["activation_token"],
    apiToken: json["api_token"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "email_verified_at": emailVerifiedAt!.toIso8601String(),
    "phone_country": phoneCountry,
    "phone_no": phoneNo,
    "phone_verified": phoneVerified,
    "country": country,
    "nationality": nationality,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "profileimg": profileimg,
    "address": address,
    "twofa": twofa,
    "twofa_status": twofaStatus,
    "google2fa_secret": google2FaSecret,
    "google2fa_verify": google2FaVerify,
    "email_verify": emailVerify,
    "kyc_verify": kycVerify,
    "profile_otp": profileOtp,
    "company_type": companyType,
    "xid": xid,
    "business_name": businessName,
    "business_country": businessCountry,
    "business_email": businessEmail,
    "business_first_name": businessFirstName,
    "business_middle_name": businessMiddleName,
    "business_last_name": businessLastName,
    "status": status,
    "freeze": freeze,
    "reason": reason,
    "verifyToken": verifyToken,
    "is_logged": isLogged,
    "ipaddr": ipaddr,
    "device": device,
    "location": location,
    "type": type,
    "mobile_user": mobileUser,
    "is_address": isAddress,
    "referral_id": referralId,
    "parent_id": parentId,
    "activation_token": activationToken,
    "api_token": apiToken,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
