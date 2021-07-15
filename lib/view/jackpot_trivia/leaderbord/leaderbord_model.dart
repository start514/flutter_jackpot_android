// To parse this JSON data, do
//
//     final leaderBordModel = leaderBordModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

LeaderBordModel leaderBordModelFromJson(String str) =>
    LeaderBordModel.fromJson(json.decode(str));

String leaderBordModelToJson(LeaderBordModel data) =>
    json.encode(data.toJson());

class LeaderBordModel {
  LeaderBordModel({
    this.status,
    this.message,
    this.leaderBordRecord,
  });

  int? status;
  String? message;
  List<LeaderBordRecord>? leaderBordRecord;

  factory LeaderBordModel.fromJson(Map<String, dynamic> json) =>
      LeaderBordModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        leaderBordRecord: json["records"] == null
            ? null
            : List<LeaderBordRecord>.from(json["records"].map((x) => LeaderBordRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "records": leaderBordRecord == null
            ? null
            : List<dynamic>.from(leaderBordRecord!.map((x) => x.toJson())),
      };
}

class LeaderBordRecord {
  LeaderBordRecord({
    this.userId,
    this.quizId,
    this.dateTime,
    this.score,
    this.userDetail,
  });

  String? userId;
  String? quizId;
  String? dateTime;
  String? score;
  UserDetail? userDetail;
  int? rank;
  Color? color;

  factory LeaderBordRecord.fromJson(Map<String, dynamic> json) => LeaderBordRecord(
        userId: json["user_id"] == null ? null : json["user_id"],
        quizId: json["quiz_id"] == null ? null : json["quiz_id"],
        dateTime: json["date_time"] == null ? null : json["date_time"],
        score: json["score"] == null ? null : json["score"],
        userDetail: json["user_detail"] == null
            ? null
            : UserDetail.fromJson(json["user_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "quiz_id": quizId == null ? null : quizId,
        "date_time": dateTime == null ? null : dateTime,
        "score": score == null ? null : score,
        "user_detail": userDetail == null ? null : userDetail!.toJson(),
      };
}

class UserDetail {
  UserDetail({
    this.id,
    this.name,
    this.email,
    this.apiKey,
    this.token,
    this.status,
  });

  String? id;
  String? name;
  String? email;
  String? apiKey;
  String? token;
  String? status;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        apiKey: json["api_key"] == null ? null : json["api_key"],
        token: json["token"] == null ? null : json["token"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "api_key": apiKey == null ? null : apiKey,
        "token": token == null ? null : token,
        "status": status == null ? null : status,
      };
}
