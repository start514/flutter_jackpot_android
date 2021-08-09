// To parse this JSON data, do
//
//     final getStreak = getStreakFromJson(jsonString);

import 'dart:convert';

SubmitStreakResponse submitStreakResponseFromJson(String str) =>
    SubmitStreakResponse.fromJson(json.decode(str));

String submitStreakResponseToJson(SubmitStreakResponse data) =>
    json.encode(data.toJson());

class SubmitStreakResponse {
  int? status;
  String? message;
  int? score;
  int? rank;
  int? originalScore;

  SubmitStreakResponse({
    this.status,
    this.message,
    this.score,
    this.rank,
    this.originalScore,
  });

  factory SubmitStreakResponse.fromJson(Map<String, dynamic> json) =>
      SubmitStreakResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        score: json["score"] == null ? null : int.parse(json["score"]),
        rank: json["rank"] == null ? null : int.parse(json["rank"]),
        originalScore: json["originalScore"] == null
            ? null
            : int.parse(json["originalScore"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "score": score == null ? null : score,
        "rank": rank == null ? null : rank,
        "originalScore": originalScore == null ? null : originalScore,
      };
}
