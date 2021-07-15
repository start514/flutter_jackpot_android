// To parse this JSON data, do
//
//     final getWinnersImagesModel = getWinnersImagesModelFromJson(jsonString);

import 'dart:convert';

GetWinnersImagesModel getWinnersImagesModelFromJson(String str) =>
    GetWinnersImagesModel.fromJson(json.decode(str));

String getWinnersImagesModelToJson(GetWinnersImagesModel data) =>
    json.encode(data.toJson());

class GetWinnersImagesModel {
  GetWinnersImagesModel({
    this.status,
    this.message,
    this.winnersImages,
  });

  int? status;
  String? message;
  List<WinnersImages>? winnersImages;

  factory GetWinnersImagesModel.fromJson(Map<String, dynamic> json) =>
      GetWinnersImagesModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        winnersImages: json["records"] == null
            ? null
            : List<WinnersImages>.from(
                json["records"].map((x) => WinnersImages.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "records": winnersImages == null
            ? null
            : List<dynamic>.from(winnersImages!.map((x) => x.toJson())),
      };
}

class WinnersImages {
  WinnersImages({
    this.id,
    this.imgType,
    this.filename,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? imgType;
  String? filename;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory WinnersImages.fromJson(Map<String, dynamic> json) => WinnersImages(
        id: json["id"] == null ? null : json["id"],
        imgType: json["img_type"] == null ? null : json["img_type"],
        filename: json["filename"] == null ? null : json["filename"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "img_type": imgType == null ? null : imgType,
        "filename": filename == null ? null : filename,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
