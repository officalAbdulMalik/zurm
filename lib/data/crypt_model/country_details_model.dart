import 'dart:convert';

CountryDetailsModel countryDetailsModelFromJson(String str) => CountryDetailsModel.fromJson(json.decode(str));

String countryDetailsModelToJson(CountryDetailsModel data) => json.encode(data.toJson());

class CountryDetailsModel {
  bool? success;
  List<CountryDetails>? result;
  String? message;

  CountryDetailsModel({
    this.success,
    this.result,
    this.message,
  });

  factory CountryDetailsModel.fromJson(Map<String, dynamic> json) => CountryDetailsModel(
    success: json["success"],
    result: List<CountryDetails>.from(json["result"].map((x) => CountryDetails.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message,
  };
}

class CountryDetails {
  dynamic id;
  String? code;
  String? name;
  dynamic createdAt;
  dynamic updatedAt;

  CountryDetails({
    this.id,
    this.code,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory CountryDetails.fromJson(Map<String, dynamic> json) => CountryDetails(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
