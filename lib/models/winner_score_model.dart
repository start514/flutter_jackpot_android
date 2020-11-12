// To parse this JSON data, do
//
//     final winnerScore = winnerScoreFromJson(jsonString);

import 'dart:convert';

WinnerScore winnerScoreFromJson(String str) =>
    WinnerScore.fromJson(json.decode(str));

String winnerScoreToJson(WinnerScore data) => json.encode(data.toJson());

class WinnerScore {
  WinnerScore({
    this.s,
    this.m,
    this.winnerScore,
  });

  int s;
  String m;
  String winnerScore;

  factory WinnerScore.fromJson(Map<String, dynamic> json) => WinnerScore(
        s: json["s"] == null ? null : json["s"],
        m: json["m"] == null ? null : json["m"],
        winnerScore: json["winner_score"] == null ? null : json["winner_score"],
      );

  Map<String, dynamic> toJson() => {
        "s": s == null ? null : s,
        "m": m == null ? null : m,
        "winner_score": winnerScore == null ? null : winnerScore,
      };
}
