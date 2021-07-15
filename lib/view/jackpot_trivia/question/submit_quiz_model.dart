// To parse this JSON data, do
//
//     final submitQuiz = submitQuizFromJson(jsonString);

import 'dart:convert';

SubmitQuiz submitQuizFromJson(String str) =>
    SubmitQuiz.fromJson(json.decode(str));

String submitQuizToJson(SubmitQuiz data) => json.encode(data.toJson());

class SubmitQuiz {
  SubmitQuiz({
    this.status,
    this.rank,
    this.points,
    this.totalScore,
    this.quizScore,
    this.quizBonus,
    this.correctQuestions,
  });

  int? status;
  String? rank;
  dynamic points;

  int? totalScore;
  String? quizScore;
  String? quizBonus;
  int? correctQuestions;

  factory SubmitQuiz.fromJson(Map<String, dynamic> json) => SubmitQuiz(
        status: json["status"] == null ? null : json["status"],
        rank: json["rank"] == null ? null : json["rank"],
        points: json["points"],
        totalScore: json["total_score"] == null ? null : json["total_score"],
        quizScore: json["quiz_score"] == null ? null : json["quiz_score"],
        quizBonus: json["quiz_bonus"] == null ? null : json["quiz_bonus"],
        correctQuestions: json["correct_questions"] == null
            ? null
            : json["correct_questions"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "rank": rank == null ? null : rank,
        "points": points,
        "total_score": totalScore == null ? null : totalScore,
        "quiz_score": quizScore == null ? null : quizScore,
        "quiz_bonus": quizBonus == null ? null : quizBonus,
        "correct_questions": correctQuestions == null ? null : correctQuestions,
      };
}
