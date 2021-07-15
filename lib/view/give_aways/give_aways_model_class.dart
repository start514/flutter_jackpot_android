// To parse this JSON data, do
//
//     final loginSignUpModel = loginSignUpModelFromJson(jsonString);

import 'dart:convert';

GiveAWaysModel loginSignUpModelFromJson(String str) =>
    GiveAWaysModel.fromJson(json.decode(str));

String loginSignUpModelToJson(GiveAWaysModel data) =>
    json.encode(data.toJson());

class GiveAWaysModel {
  GiveAWaysModel({
    this.status,
    this.message,
    this.giveAWaysRecord,
  });

  int? status;
  String? message;
  List<GiveAWaysRecord>? giveAWaysRecord;

  factory GiveAWaysModel.fromJson(Map<String, dynamic> json) =>
      GiveAWaysModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        giveAWaysRecord: json["records"] == null
            ? null
            : List<GiveAWaysRecord>.from(json["records"].map((x) => GiveAWaysRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "records": giveAWaysRecord == null
            ? null
            : List<dynamic>.from(giveAWaysRecord!.map((x) => x.toJson())),
      };
}

class GiveAWaysRecord {
  GiveAWaysRecord({
    this.id,
    this.name,
    this.photoThumb,
  });

  String? id;
  String? name;
  String? photoThumb;

  factory GiveAWaysRecord.fromJson(Map<String, dynamic> json) => GiveAWaysRecord(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        photoThumb: json["photo_thumb"] == null ? null : json["photo_thumb"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "photo_thumb": photoThumb == null ? null : photoThumb,
      };
}
