import 'dart:convert';

UploadImageModel uploadImageModelFromJson(String str) => UploadImageModel.fromJson(json.decode(str));

String uploadImageModelToJson(UploadImageModel data) => json.encode(data.toJson());

class UploadImageModel {
  bool? success;
  String? result;
  String? message;

  UploadImageModel({
    this.success,
    this.result,
    this.message,
  });

  factory UploadImageModel.fromJson(Map<String, dynamic> json) => UploadImageModel(
    success: json["success"],
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result,
    "message": message,
  };
}
