// To parse this JSON data, do
//
//     final getStreak = getStreakFromJson(jsonString);

import 'dart:convert';

GetStreak getStreakFromJson(String str) => GetStreak.fromJson(json.decode(str));

String getStreakToJson(GetStreak data) => json.encode(data.toJson());

class GetStreak {
  int? status;
  String? message;
  List<StreakEntry>? leaders;
  DateTime? endDate;
  int? prize1;
  int? prize2;
  int? prize3;
  int? score;
  int? scoreMax;

  GetStreak({
    this.status,
    this.message,
    this.leaders,
    this.endDate,
    this.prize1,
    this.prize2,
    this.prize3,
    this.score,
    this.scoreMax,
  });

  factory GetStreak.fromJson(Map<String, dynamic> json) => GetStreak(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        leaders: json["leaders"] == null
            ? null
            : List<StreakEntry>.from(
                json["leaders"].map((x) => StreakEntry.fromJson(x))),
        prize1: json["prize1"] == null ? null : int.parse("${json["prize1"]}"),
        prize2: json["prize2"] == null ? null : int.parse("${json["prize2"]}"),
        prize3: json["prize3"] == null ? null : int.parse("${json["prize3"]}"),
        score: json["score"] == null ? null : int.parse("${json["score"]}"),
        scoreMax: json["score_max"] == null
            ? null
            : int.parse("${json["score_max"]}"),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "end_date": endDate == null ? null : endDate!.toIso8601String(),
        "leaders": leaders == null
            ? null
            : List<dynamic>.from(leaders!.map((x) => x.toJson())),
        "prize1": prize1 == null ? null : prize1,
        "prize2": prize2 == null ? null : prize2,
        "prize3": prize3 == null ? null : prize3,
        "score": score == null ? null : score,
        "score_max": scoreMax == null ? null : scoreMax,
      };
}

class StreakEntry {
  String? name;
  int? score;
  int? max_score;

  StreakEntry({
    this.name,
    this.score,
    this.max_score,
  });

  factory StreakEntry.fromJson(Map<String, dynamic> json) => StreakEntry(
        name: json["name"] == null ? null : json["name"],
        score: json["score"] == null ? null : int.parse(json["score"]),
        max_score:
            json["max_score"] == null ? null : int.parse(json["max_score"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "score": score == null ? null : score,
        "max_score": max_score == null ? null : max_score,
      };
}
