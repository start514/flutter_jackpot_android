// To parse this JSON data, do
//
//     final getStreak = getStreakFromJson(jsonString);

import 'dart:convert';

GetStreak getStreakFromJson(String str) => GetStreak.fromJson(json.decode(str));

String getStreakToJson(GetStreak data) => json.encode(data.toJson());

class GetStreak {
  int? status;
  String? message;
  List<StreakEntry>? top3;
  DateTime? endDate;
  int? score;
  int? scoreMax;

  GetStreak({
    this.status,
    this.message,
    this.top3,
    this.endDate,
    this.score,
    this.scoreMax,
  });

  factory GetStreak.fromJson(Map<String, dynamic> json) => GetStreak(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        top3: json["top3"] == null
            ? null
            : List<StreakEntry>.from(json["top3"].map((x) => StreakEntry.fromJson(x))),
        score: json["score"] == null ? null : int.parse(json["score"]),
        scoreMax: json["score_max"] == null ? null : int.parse(json["score_max"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "end_date": endDate == null ? null : endDate!.toIso8601String(),
        "top3": top3 == null
            ? null
            : List<dynamic>.from(top3!.map((x) => x.toJson())),
        "score": score == null ? null : score,
        "score_max": scoreMax == null ? null : scoreMax,
      };
}

class StreakEntry {
  String? name;
  int? score;

  StreakEntry({
    this.name,
    this.score,
  });

  factory StreakEntry.fromJson(Map<String, dynamic> json) => StreakEntry(
        name: json["name"] == null ? null : json["name"],
        score: json["score"] == null ? null : int.parse(json["score"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "score": score == null ? null : score,
      };
}