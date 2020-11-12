// To parse this JSON data, do
//
//     final giveAWaysDetailsModel = giveAWaysDetailsModelFromJson(jsonString);

import 'dart:convert';

GiveAWaysDetailsModel giveAWaysDetailsModelFromJson(String str) =>
    GiveAWaysDetailsModel.fromJson(json.decode(str));

String giveAWaysDetailsModelToJson(GiveAWaysDetailsModel data) =>
    json.encode(data.toJson());

class GiveAWaysDetailsModel {
  GiveAWaysDetailsModel({
    this.status,
    this.message,
    this.giveADetailsModelRecord,
  });

  int status;
  String message;
  List<GiveAWaysDetailsModelRecord> giveADetailsModelRecord;

  factory GiveAWaysDetailsModel.fromJson(Map<String, dynamic> json) =>
      GiveAWaysDetailsModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        giveADetailsModelRecord: json["records"] == null
            ? null
            : List<GiveAWaysDetailsModelRecord>.from(json["records"].map((x) => GiveAWaysDetailsModelRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "records": giveADetailsModelRecord == null
            ? null
            : List<dynamic>.from(giveADetailsModelRecord.map((x) => x.toJson())),
      };
}

class GiveAWaysDetailsModelRecord {
  GiveAWaysDetailsModelRecord({
    this.id,
    this.name,
    this.photo,
    this.photoThumb,
    this.itemsTotal,
    this.itemsAvailable,
    this.startDate,
    this.endDate,
    this.isFreeEntry,
    this.rules,
    this.task,
  });

  String id;
  String name;
  String photo;
  String photoThumb;
  String itemsTotal;
  String itemsAvailable;
  DateTime startDate;
  DateTime endDate;
  String isFreeEntry;
  String rules;
  List<Task> task;

  factory GiveAWaysDetailsModelRecord.fromJson(Map<String, dynamic> json) => GiveAWaysDetailsModelRecord(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        photo: json["photo"] == null ? null : json["photo"],
        photoThumb: json["photo_thumb"] == null ? null : json["photo_thumb"],
        itemsTotal: json["items_total"] == null ? null : json["items_total"],
        itemsAvailable:
            json["items_available"] == null ? null : json["items_available"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        isFreeEntry: json["isFreeEntry"] == null ? null : json["isFreeEntry"],
        rules: json["rules"] == null ? null : json["rules"],
        task: json["task"] == null
            ? null
            : List<Task>.from(json["task"].map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "photo": photo == null ? null : photo,
        "photo_thumb": photoThumb == null ? null : photoThumb,
        "items_total": itemsTotal == null ? null : itemsTotal,
        "items_available": itemsAvailable == null ? null : itemsAvailable,
        "start_date": startDate == null ? null : startDate.toIso8601String(),
        "end_date": endDate == null ? null : endDate.toIso8601String(),
        "isFreeEntry": isFreeEntry == null ? null : isFreeEntry,
        "rules": rules == null ? null : rules,
        "task": task == null
            ? null
            : List<dynamic>.from(task.map((x) => x.toJson())),
      };
}

class Task {
  Task({
    this.id,
    this.url,
    this.entry,
    this.media,
    this.name,
  });

  String id;
  dynamic url;
  String entry;
  String media;
  String name;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"] == null ? null : json["id"],
        url: json["url"],
        entry: json["entry"] == null ? null : json["entry"],
        media: json["media"] == null ? null : json["media"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "url": url,
        "entry": entry == null ? null : entry,
        "media": media == null ? null : media,
        "name": name == null ? null : name,
      };
}
